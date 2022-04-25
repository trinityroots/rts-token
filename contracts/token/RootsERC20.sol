// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../lib/RBACTransparent.sol";

/**
 * @dev creates an ERC20 token with RBAC using OpenZeppelin
 * 
 * ERC20: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
 * AccessControl: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol
 */
contract RootsERC20 is ERC20, AccessControl {

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /**
     * @dev Initializes the contract giving the deployer all roles and setting max cap
     */
    constructor() ERC20("Roots Token", "RTS") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }

    /**
     * @dev expose mint as public allowing only the minter to execute
     *
     * We can leverage this to define a function in our interface when calling this contract
     */
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) returns (bool) {
        _mint(to, amount); 
        return true;
    }

    /**
     * @dev expose burn as public allowing only the burner to execute
     * 
     * We can leverage this to define a function in our interface when calling this contract
     */
    function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) returns (bool) {
        _burn(from, amount);
        return true;
    }
    
}
