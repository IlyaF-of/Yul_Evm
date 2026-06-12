// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/03_MemoryInspector.sol";

contract MemoryInspectorTest is Test {
    MemoryInspector public inspector;

    function setUp() public {
        inspector = new MemoryInspector();
    }

    /// @notice Проверяем, как bytes массив выглядит в памяти
    function test_BytesLayout() public view {
        // Создаём 64-байтовый массив, инициализированный нулями
        bytes memory data = new bytes(64);
        // Записываем первый байт (самый старший в первом 32-байтовом слове) = 0xab
        data[0] = 0xab;
        // Записываем байт с индексом 32 (первый байт второго слова) = 0xcd
        data[32] = 0xcd;

        // Получаем информацию о памяти
        MemoryInspector.BytesInfo memory info = inspector.inspectBytes(data);

        // Длина массива должна быть 64
        assertEq(info.length, 64);

        // Первое слово данных – должно начинаться с 0xab (остальные байты – нули)
        assertEq(info.firstWord, bytes32(uint256(0xab)));

        // Второе слово данных – должно начинаться с 0xcd
        assertEq(info.secondWord, bytes32(uint256(0xcd)));

        // Указатель свободной памяти должен быть выровнен на 32 байта
        assertEq(info.freeMemPtr % 32, 0);
    }

    /// @notice Проверяем, как строка хранится в памяти (аналогично bytes)
    function test_StringLayout() public view {
        string memory str = "Hello, Yul!";   // 11 символов
        MemoryInspector.BytesInfo memory info = inspector.inspectString(str);

        // Длина строки должна быть 11
        assertEq(info.length, 11);

    }

    /// @notice Проверяем ручное выделение памяти с выравниванием
    function test_AllocateAlignment() public view {
        // Запрашиваем 33 байта (не кратно 32)
        (uint256 ptr, uint256 after_) = inspector.allocate(33);

        // Должно выделиться 64 байта (округление вверх до кратного 32)
        assertEq(after_ - ptr, 64);

        // Начальный адрес должен быть выровнен на 32
        assertEq(ptr % 32, 0);
    }
}
