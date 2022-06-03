// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "../../interfaces/IRootsERC20.sol";

/**
 * @dev Creating a burn service for ERC20
 */
contract RootsERC20RedeemInternal is AccessControl {

    IRootsERC20 public rootsERC20;

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
     * @dev Public token burning
     */
    function burn(uint amount) public returns (bool){
        rootsERC20.burn(msg.sender, amount);
        return true;
    }

}
