// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./RootsERC20.sol";

contract RootsERC20Claimable is RootsERC20 {

    mapping(address => uint) public unclaimed;
    mapping(address => uint) public claimed;

    /**
     * @dev Store value in address mapped with unclaimed amounts
     * @param _account account to store value
     * @param _amount amount to add to unclaimed
     */
    function addUnclaimed(address _account, uint256 _amount) internal {
        unclaimed[_account] += _amount;
    }

    /**
     * @dev Store value in address mapped with unclaimed amounts
     * @param _account account to store value
     * @param _amount amount to add to unclaimed
     */
    function removeUnclaimed(address _account, uint256 _amount) internal {
        require(_amount <= unclaimed[_account], "Amount to remove cannot be greater than unclaimed amount");
        unclaimed[_account] -= _amount;
    }

    /**
     * @dev Store value in address mapped with claimed amounts
     * @param _account account to store value
     * @param _amount amount to add to claimed
     */
    function setClaimed(address _account, uint256 _amount) internal {
        claimed[_account] += _amount;
    }

    /**
     * @dev Store value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value from offchain
     */
    function createClaimable(address _account, uint256 _amount) external onlyRole(REWARDER_ROLE){
        uint256 _unclaimed = _amount - claimed[_account] - unclaimed[_account];
        require(_unclaimed > 0, 'claimable must be greater than 0');
        addUnclaimed(_account, _unclaimed);
    }

    /**
     * @dev Remove value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value to remove
     */
    function removeClaimable(address _account, uint256 _amount) external onlyRole(REWARDER_ROLE){
        removeUnclaimed(_account, _amount);
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a <= b ? a : b;
    }

    /**
     * @dev Transfer unclaimed value
     */
    function claim() public payable {
        uint _unclaimed = unclaimed[msg.sender];
        //check if unclaimed is 0, total supply == cap
        require(_unclaimed > 0, "Unclaimed balance must be greater than 0");
        require(ERC20.totalSupply() <= cap(), "The max supply has been exhausted.");
        //get distance to max supply
        uint to_maxSupply = cap() - ERC20.totalSupply();
        //take minimum to allow minting less when close to max supply
        uint min_unclaimed = min(_unclaimed, to_maxSupply);
        //add unclaimed to claimed
        claimed[msg.sender] += min_unclaimed;
        //reset unclaimed
        unclaimed[msg.sender] = 0;
        //mint tokens to sender
        _mint(msg.sender, min_unclaimed);
    }
}