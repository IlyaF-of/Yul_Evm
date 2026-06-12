// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @dev Показывает, как читать аргументы напрямую из calldata.
contract CallDataDecoder {
    /// @notice Декодирует три аргумента: uint256, address, bytes
    /// @dev ABI-порядок: [селектор (4B)] [uint256 a (32B)] [address b (32B, младшие 20B)] [смещение bytes c (32B)]
    ///      После смещения для c (которое считается от начала блока аргументов, т.е. от 0x04) идёт длина и данные.
    function decodeThreeArgs(
        uint256 a,
        address b,
        bytes calldata c
    )
        external
        pure
        returns (
            uint256 outA,          // прочитанное значение a
            address outB,          // прочитанное значение b
            uint256 cLength,       // длина массива байт c
            bytes32 cFirstWord,    // первые 32 байта данных c
            uint256 cOffsetInCalldata // абсолютное смещение начала данных c в calldata
        )
    {
        assembly {
            // uint256 a лежит сразу после селектора: смещение 0x04
            outA := calldataload(0x04)

            // address b занимает следующие 32 байта (смещение 0x24)
            outB := calldataload(0x24)

            // relOffset — относительное смещение для bytes c (отсчитывается от начала аргументов, т.е. от 0x04)
            let relOffset := calldataload(0x44)

            // Абсолютный адрес начала данных c в calldata = 0x04 + relOffset
            cOffsetInCalldata := add(0x04, relOffset)

            // По этому адресу сначала идёт длина массива байт (32 байта)
            cLength := calldataload(cOffsetInCalldata)

            // Данные начинаются сразу после длины: cOffsetInCalldata + 0x20
            cFirstWord := calldataload(add(cOffsetInCalldata, 0x20))
        }
    }

    /// @notice Декодирует динамический массив uint256[] и bool
    /// @dev ABI: [селектор] [смещение массива arr (32B)] [bool flag (32B)]
    ///      Сам массив лежит по смещению arr: [длина (32B)] [элементы...]
    function decodeArrayAndBool(
        uint256[] calldata arr,
        bool flag
    ) external pure returns (uint256 arrLength, uint256 firstElement, bool outFlag) {
        assembly {
            // Первый аргумент — динамический массив, поэтому сначала идёт его смещение (от 0x04)
            let relOffset := calldataload(0x04)

            // Начало данных массива (длина + элементы) в абсолютных адресах calldata
            let arrStart := add(0x04, relOffset)

            // Первое слово — длина массива
            arrLength := calldataload(arrStart)

            // Второе слово — первый элемент (если длина > 0, иначе 0, что допустимо)
            firstElement := calldataload(add(arrStart, 0x20))

            // bool flag лежит сразу после смещения массива: смещение 0x04 + 32 = 0x24
            outFlag := calldataload(0x24)
        }
    }
}
