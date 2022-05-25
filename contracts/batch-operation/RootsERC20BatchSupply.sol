// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../../interfaces/IRootsERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @dev Setting batch operations for transfer
 */
contract RootsERC20BatchSupply is AccessControl {

    IRootsERC20 public rootsERC20;

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct SupplyRow {
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
     * @dev Batch Mint Operation
     * @param rows struct array i.e. [[0xa...,1],[0xb...,2]]
     */
    function batchMint(SupplyRow[] memory rows) public returns (bool) {
        require(rootsERC20.hasRole(MINTER_ROLE, msg.sender), "AccessControl: You must be minter.");
        for (uint i = 0; i < rows.length; i++) {
            rootsERC20.mint(rows[i].account, rows[i].amount);
        }
        return true;
    }

    /**
     * @dev Batch Burn Operation
     * @param rows struct array i.e. [[0xa...,1],[0xb...,2]]
     */
    function batchBurn(SupplyRow[] memory rows) public returns (bool) {
        require(rootsERC20.hasRole(BURNER_ROLE, msg.sender), "AccessControl: You must be burner.");
        for (uint i = 0; i < rows.length; i++) {
            rootsERC20.burn(rows[i].account, rows[i].amount);
        }
        return true;
    }

}
