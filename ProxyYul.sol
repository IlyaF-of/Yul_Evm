// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Оптимизированный EIP-1967 Прокси на Yul
/// @notice Выполняет полное делегирование вызовов к имплементации, защищая стейт от коллизий
contract YulProxy {
    
    // Позиция слота в хранилище для адреса логики. Рассчитывается как:
    // bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
    // Так как переменная constant, она заменяется в байткоде и не занимает slot(0).
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    /// @notice Установка первичной логики при деплое
    /// @param _impl Адрес контракта с логикой
    constructor(address _impl) {
        // Проверяем, что адрес имплементации не нулевой
        require(_impl != address(0), "Zero address implementation");
        
        assembly {
            // Сохраняем адрес логики в защищенный EIP-1967 слот хранилища
            sstore(IMPLEMENTATION_SLOT, _impl)
        }
    }

    /// @notice Внешний интерфейс для получения текущего адреса логики
    /// @return impl Текущий адрес контракта имплементации
    function implementation() external view returns (address impl) {
        assembly {
            // Читаем 32-байтовое слово из защищенного слота и записываем в стек возврата
            impl := sload(IMPLEMENTATION_SLOT)
        }
    }

    /// @notice fallback-функция, перенаправляет все вызовы на имплементацию
    fallback() external payable {
        assembly {
            // 1. Загружаем адрес логики из хранилища Storage в стек
            let impl := sload(IMPLEMENTATION_SLOT)
            
            // 2. Копируем весь Calldata транзакции в оперативную память (Memory).
            // Начинаем запись с адреса 0x00, временно затирая Scratch Space и Free Memory Pointer.
            // Это безопасно, так как в конце fallback транзакция гарантированно прерывается (revert или return).
            // Сигнатура: calldatacopy(destOffset, offset, size)
            calldatacopy(0, 0, calldatasize())
            
            // 3. Выполняем delegatecall к контракту логики в его контексте.
            // Передаем:
            // - gas(): весь доступный газ транзакции
            // - impl: целевой адрес логики
            // - 0: смещение в памяти, где лежат входящие данные
            // - calldatasize(): размер входящих данных
            // - 0, 0: выходные параметры. Напишем 0, так как не знаем размер ответа заранее. 
            //   Мы заберем его нативно через returndatacopy на следующем шаге.
            let success := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            
            // 4. Копируем возвращенные контрактом логики данные в память по адресу 0x00.
            // Старый calldata перезаписываем результатом вызова.
            returndatacopy(0, 0, returndatasize())
            
            // 5. Проверяем статус выполнения delegatecall (0 - ошибка, 1 - успех)
            if iszero(success) {
                revert(0, returndatasize())
            }
            
            // Если вызов успешен, отдаем возвращенные данные вызывающему контракту
            return(0, returndatasize())
        }
    }
}

/// @title Контракт-логика для тестирования (Имплементация)
contract Logic {
    uint256 public value;  // slot(0)
    address public sender; // slot(1)

    /// @notice Изменение состояния стейта через прокси
    function setValue(uint256 _value) external {
        value = _value;
        sender = msg.sender; // Внутри delegatecall msg.sender — это тот, кто вызвал Proxy!
    }

    /// @notice Вызов ошибки с текстовым описанием
    function revertWithReason() external pure {
        revert("LogicError");
    }
}
