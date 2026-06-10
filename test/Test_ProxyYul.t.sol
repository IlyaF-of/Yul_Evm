// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Импортируем базовый тестовый контракт Foundry
import "forge-std/Test.sol";
// Импортируем наш прокси и контракт логики
import "../src/02_ProxyYul.sol";

contract ProxyYulTest is Test {
    YulProxy public proxy;
    Logic public logic;

    // Создаем тестовых пользователей для изоляции msg.sender
    address public alice = address(0x1111);

    /// @notice Настройка окружения перед каждым тестом
    function setUp() public {
        // 1. Деплоим контракт-логику 
        logic = new Logic();
        
        // 2. Деплоим прокси, передавая адрес логики в конструктор.
        // В этот момент внутри прокси срабатывает sstore в EIP-1967 слот.
        proxy = new YulProxy(address(logic));
    }

    /// @notice Проверка сохранения msg.sender и изоляции хранилища с применением Fuzzing
    /// @dev Foundry автоматически подставит сотни случайных чисел в параметр _fuzzValue
    function testFuzz_DelegateCallPreservesSender(uint256 _fuzzValue) public {
        // Читкод vm.prank заставляет EVM считать, что следующую транзакцию совершает Alice
        vm.prank(alice);

        // Приводим адрес прокси к типу Logic. 
        // Вызов setValue() сгенерирует calldata селектора [0x552410ac] + упакованное _fuzzValue.
        // Так как у прокси нет функции setValue, вызов падает в fallback(), 
        // который делает delegatecall(..., logic, ...)
        Logic(address(proxy)).setValue(_fuzzValue);

        // Проверяем Стейт Прокси: Читаем значение из СЛОТА 0 контракта Proxy.
        // Оно должно быть равно нашему зафузженному значению.
        assertEq(Logic(address(proxy)).value(), _fuzzValue, "Proxy state was not updated correctly");

        // Проверяем msg.sender на Прокси: Из-за delegatecall контракт Logic выполнил код
        // в контексте Прокси, и msg.sender должен остаться первоначальным (Alice).
        assertEq(Logic(address(proxy)).sender(), alice, "msg.sender context was lost in delegatecall");
    }

        // Делаем вызов через прокси. 
        Logic(address(proxy)).revertWithReason();
    }

    /// @notice Проверка корректности чтения EIP-1967 слота через view-вызов
    function test_ImplementationSlot() public view {
        // Тестируем функцию implementation(). 
        // Внутри нее Yul-опкод sload(IMPLEMENTATION_SLOT) должен вернуть 
        // адрес контракта logic, который мы сохранили при деплое в setUp().
        assertEq(proxy.implementation(), address(logic), "EIP-1967 slot mismatch");
    }
}
