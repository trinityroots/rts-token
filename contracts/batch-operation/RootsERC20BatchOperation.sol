// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../../interfaces/IRootsERC20.sol";

/**
 * @dev Setting batch operations for transfer
 */
contract RootsERC20BatchOperation {

    IRootsERC20 public rootsERC20;

    struct TransferRow {
        address account;
        uint amount;
    }

    /**
     * @dev granting admin role to the sender
     */
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Set the contract address for the ERC20 token
     * @param _address address of the ERC20 token contract
     */
    function setRootsERC20Contract(address _address) public onlyRole(DEFAULT_ADMIN_ROLE) {
        rootsERC20 = IRootsERC20(_address);
    }

    /**
     * @dev Batch Transfer Operation
     * @param rows struct array i.e. [[0xa...,1],[0xb...,2]]
     */
    function batchTransfer(TransferRow[] memory rows) public returns (bool) {
        for (uint i = 0; i < rows.length; i++) {
            rootsERC20.transfer(rows[i].account, rows[i].amount);
        }
        return true;
    }

}
