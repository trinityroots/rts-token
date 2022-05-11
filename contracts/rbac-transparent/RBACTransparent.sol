// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev defining functions we will use in this contract through an interface
 */
interface IRootsERC20 is IERC20 {
    // grant role from AccessControl
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external returns (bool);
    function revokeRole(bytes32 role, address account) external;
}

/**
 * @dev interfaces with ERC20 to store 
 */
contract RBACTransparent is AccessControl{

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    IRootsERC20 public rootsERC20;

    // role list for transparency
    mapping(bytes32 => address[]) public roleList;

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
     * @dev Execute grantRole of ERC20 using the interface
     * @param role bytes32 representation of role
     * @param account address
     */
    function erc20GrantRole(bytes32 role, address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!rootsERC20.hasRole(role, account), "This account already has this role.");
        rootsERC20.grantRole(role, account);
        //update list
        roleList[role].push(account);
    }

    function indexOf(address[] memory arr, address searchFor) pure private returns (uint) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == searchFor) {
                return i;
            }
        }
        revert("Item not found");
    }

    function removeRole(bytes32 role, uint index) private {
        roleList[role][index] = roleList[role][roleList[role].length - 1];
        roleList[role].pop();
    }

    /**
     * @dev Execute revokeRole of ERC20 using the interface
     * @param role bytes32 representation of role
     * @param account address
     */
    function erc20RevokeRole(bytes32 role, address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(rootsERC20.hasRole(role, account), "This account doesn't have this role.");
        rootsERC20.revokeRole(role, account);
        //update list
        uint idx = indexOf(roleList[role], account);
        removeRole(role, idx);
    }

    /**
     * @dev return account list of members in a role
     * @param role bytes32 representation of role
     */
    function getRoleList(bytes32 role) public view returns(address[] memory){
        return roleList[role];
    }
    
}
