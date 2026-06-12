// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/04_CallDataDecoder.sol";

contract CallDataDecoderTest is Test {
    CallDataDecoder public decoder;

    function setUp() public {
        decoder = new CallDataDecoder();
    }

    /// @notice Проверяет ручное извлечение uint256, address и bytes из calldata
    function test_DecodeThreeArgs() public view {
        // Вызываем decodeThreeArgs с тестовыми значениями: число 42, текущий контракт как адрес, и строку "hello"
        (
            uint256 a,
            address b,
            uint256 cLen,
            bytes32 cWord,
            uint256 cOff
        ) = decoder.decodeThreeArgs(42, address(this), bytes("hello"));

        // Проверяем, что число a корректно прочитано из calldata
        assertEq(a, 42);

        // Проверяем, что адрес b совпадает с переданным
        assertEq(b, address(this));

        // Длина байтовой строки "hello" равна 5
        assertEq(cLen, 5);

        // cWord должно содержать первый 32-байтный блок данных строки.
        // В ABI упаковке байты выравниваются по левому краю, т.е. первый символ 'h' окажется самым старшим байтом.
        assertEq(cWord, bytes32(uint256(uint8(bytes1("h")))));

        // cOff – абсолютное смещение в calldata, где начинается длина массива байт.
        // Для трёх аргументов: a (32B), b (32B) и смещение для c (32B) → relOffset = 0x60.
        // Абсолютное смещение = 0x04 (селектор) + 0x60 = 0x64
        assertEq(cOff, 0x64); // 0x04 + 0x60
    }

    /// @notice Проверяет ручное извлечение динамического массива uint256[] и bool
    function test_DecodeArrayAndBool() public view {
        // Подготавливаем тестовый массив из трёх элементов
        uint256[] memory arr = new uint256[](3);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;

        // Вызываем decoder с массивом и флагом true
        (uint256 len, uint256 first, bool flag) = decoder.decodeArrayAndBool(arr, true);

        // Ожидаемая длина массива 3
        assertEq(len, 3);

        // Первый элемент массива должен быть равен 1
        assertEq(first, 1);

        // Флаг должен быть true
        assertTrue(flag);
    }
}
