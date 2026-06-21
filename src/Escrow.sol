// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IEscrow} from "src/interfaces/IEscrow.sol";

contract Escrow is IEscrow {

    struct CollabDetails {}

    mapping(address => uint) public escrowed;

    function requestCollab() external {}

    function fillCollab() external {}

    function offerCollab() external {}
}
