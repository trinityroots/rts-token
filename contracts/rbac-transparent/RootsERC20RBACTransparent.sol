// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "../../interfaces/IRootsERC20.sol";

/**
 * @dev for the purpose of visibility this contract interfaces with ERC20 to store addresses and their respective roles
 */
contract RootsERC20RBACTransparent is AccessControl{

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

    /**
     * @dev Search for index of an item in an array
     * @param arr address array to search
     * @param searchFor address to search for
     */
    function indexOf(address[] memory arr, address searchFor) pure private returns (uint) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == searchFor) {
                return i;
            }
        }
        revert("Address not found");
    }

    /**
     * @dev Remove an address in the role list
     * @param role bytes32 representation of role
     * @param index integer index of item to remove
     */
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
