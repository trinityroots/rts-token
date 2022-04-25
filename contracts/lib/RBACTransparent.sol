// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @dev adds a role log to access control from OZ
 *
 * AccessControl: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol
 */
contract RBACTransparent is AccessControl {

    // message construct stores the single chat message and its metadata
    struct RoleTransaction {
        address addr;
        uint timestamp;
        string action;
    }

    // role log for transparency
    mapping(bytes32 => RoleTransaction[]) public roleLog;

    /**
     * @dev override grantRole in OZ AccessControl to provide more transparency
     * @param role bytes32 representation of role
     * @param account account to grant role
     */
    function _grantRole(bytes32 role, address account) internal virtual override {
        if(!hasRole(role, account)){
            // add user to the role log
            RoleTransaction memory newTxn = RoleTransaction(account, block.timestamp, "grant");
            roleLog[role].push(newTxn);
        }
        super._grantRole(role, account);
    }

    /**
     * @dev override revokeRole in OZ AccessControl to provide more transparency
     * @param role bytes32 representation of role
     * @param account account to revoke role
     */
    function _revokeRole(bytes32 role, address account) internal virtual override {
        if(hasRole(role, account)){
            //add user to the role log
            RoleTransaction memory newTxn = RoleTransaction(account, block.timestamp, "revoke");
            roleLog[role].push(newTxn);
        }
        super._revokeRole(role, account);
    }

    /**
     * @dev return account list of when members were added to a role
     * @param role bytes32 representation of role
     */
    function getRoleLog(bytes32 role) public view returns(RoleTransaction[] memory){
        return roleLog[role];
    }
    
}
