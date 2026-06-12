// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @dev Смотрим в структуру bytes и string в памяти,
///      а также вручную выделяем память с выравниванием по 32 байта.
contract MemoryInspector {
    struct BytesInfo {
        uint256 pointer;      // адрес начала блока памяти (указатель)
        uint256 length;       // длина данных (из первого 32‑байтового слота)
        uint256 freeMemPtr;   // текущий указатель свободной памяти (mload(0x40))
        bytes32 firstWord;    // первые 32 байта данных (сразу после длины)
        bytes32 secondWord;   // вторые 32 байта данных
    }

    /// @dev Возвращает структуру с информацией о расположении данных в памяти.
    ///      Структура в памяти занимает 5 * 32 = 160 байт (0x20..0x80 + 32 на длину не надо, т.к. это сам struct уже в памяти).
    ///      В Yul мы сохраняем поля в память, используя последовательные смещения.
    function inspectBytes(bytes memory data) external pure returns (BytesInfo memory info) {
        assembly {
            // info – указатель на начало выделенной памяти под возвращаемую структуру
            // data – указатель на начало области памяти, где лежит сам массив bytes
            let ptr := data

            // Поле pointer: сам адрес начала блока
            mstore(info, ptr)
            // Поле length: читаем первый слот по ptr – это длина массива байт
            mstore(add(info, 0x20), mload(ptr))
            // Поле freeMemPtr: текущий указатель свободной памяти (mload(0x40))
            mstore(add(info, 0x40), mload(0x40))
            // Поле firstWord: первые 32 байта данных (после поля длины)
            mstore(add(info, 0x60), mload(add(ptr, 0x20)))
            // Поле secondWord: вторые 32 байта данных
            mstore(add(info, 0x80), mload(add(ptr, 0x40)))
        }
    }

    /// @dev string хранится в памяти точно так же, как bytes (длина + данные).
    function inspectString(string memory str) external pure returns (BytesInfo memory info) {
        assembly {
            let ptr := str
            mstore(info, ptr)
            mstore(add(info, 0x20), mload(ptr))
            mstore(add(info, 0x40), mload(0x40))
            mstore(add(info, 0x60), mload(add(ptr, 0x20)))
            mstore(add(info, 0x80), mload(add(ptr, 0x40)))
        }
    }

    /// @notice Ручное выделение памяти с выравниванием на 32 байта
    /// @param size Запрошенный размер в байтах (может быть не кратным 32)
    /// @return ptr Адрес начала выделенной области
    /// @return freeAfter Новый указатель свободной памяти после выделения
    function allocate(uint256 size) external pure returns (uint256 ptr, uint256 freeAfter) {
        assembly {
            // Текущий свободный адрес из 0x40
            ptr := mload(0x40)

            // Вычисляем остаток от деления на 32
            let rem := mod(size, 32)
            // Если есть остаток, увеличиваем size до следующего кратного 32
            if gt(rem, 0) {
                // Добавляем (32 - остаток)
                size := add(size, sub(32, rem))
            }

            // Резервируем память, сдвигая указатель свободной памяти на size байт вперёд
            mstore(0x40, add(ptr, size))

            // Возвращаем новое значение free memory pointer
            freeAfter := mload(0x40)
        }
    }
}
