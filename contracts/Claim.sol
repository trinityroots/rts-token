// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Claim {

    mapping(address => uint) public unclaimed;
    mapping(address => uint) public claimed;

    /**
     * @dev Store value in address mapped with unclaimed amounts
     * @param _account account to store value
     * @param _amt amount to add to unclaimed
     */
    function addUnclaimed(address _account, uint256 _amt) internal {
        unclaimed[_account] += _amt;
    }

    /**
     * @dev Store value in address mapped with unclaimed amounts
     * @param _account account to store value
     * @param _amt amount to add to unclaimed
     */
    function removeUnclaimed(address _account, uint256 _amt) internal {
        require(_amt <= unclaimed[_account], "Amount to remove cannot be greater than unclaimed amount");
        unclaimed[_account] -= _amt;
    }

    /**
     * @dev Store value in address mapped with claimed amounts
     * @param _account account to store value
     * @param _amt amount to add to claimed
     */
    function setClaimed(address _account, uint256 _amt) internal {
        claimed[_account] += _amt;
    }

}