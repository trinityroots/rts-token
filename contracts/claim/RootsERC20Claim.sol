// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev defining functions we will use in this contract through an interface
 */
interface IRootsERC20 is IERC20 {
    function mint(address to, uint256 amount) external returns (bool);
}

/**
 * @dev Creating a claim service that distributes the ERC20 token
 */
contract RootsERC20Claim is AccessControl {

    IRootsERC20 rootsERC20;

    mapping(address => uint) public unclaimed;
    mapping(address => uint) public claimed;

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
     * @dev Store value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value from offchain
     *
     * The offchain value sent must be greater than the total of claimed and unclaimed stored onchain
     */
    function createClaimable(address _account, uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_amount > claimed[_account] + unclaimed[_account], "Amount must be greater than the sum of claim and unclaimed");
        uint diff = _amount - claimed[_account] - unclaimed[_account];
        // The diff is value offchain - value onchain
        unclaimed[_account] += diff;
    }

    /**
     * @dev Remove value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value to remove
     */
    function removeClaimable(address _account, uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(_amount <= unclaimed[_account], "Amount to remove cannot be greater than unclaimed amount");
        unclaimed[_account] -= _amount;
    }

    /**
     * @dev Pure function for retrieving minimum of two unsigned integers
     */
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a <= b ? a : b;
    }

    /**
     * @dev Transfer unclaimed value
     */
    function claim() public payable {
        require(unclaimed[msg.sender] > 0, "No tokens claimable.");
        uint _unclaimed = unclaimed[msg.sender];
        //add unclaimed to claimed
        claimed[msg.sender] += _unclaimed;
        //reset unclaimed
        unclaimed[msg.sender] = 0;
        //mint tokens to sender
        rootsERC20.mint(msg.sender, _unclaimed);
    }

}
