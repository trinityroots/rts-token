// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "../../interfaces/IRootsERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @dev Creating a claim service that distributes the ERC20 token
 */
contract RootsERC20Claim is AccessControl {

    using SafeMath for uint256;

    event NewClaim(address _address, uint _amount);

    IRootsERC20 public rootsERC20;

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
    function addClaimable(address _account, uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_amount > claimed[_account].add(unclaimed[_account]), "Amount must be greater than the sum of claim and unclaimed");
        uint diff = _amount.sub(claimed[_account]).sub(unclaimed[_account]);
        // The diff is value offchain - value onchain
        unclaimed[_account] = unclaimed[_account].add(diff);
    }

    /**
     * @dev Remove value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value to remove
     */
    function removeClaimable(address _account, uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(_amount <= unclaimed[_account], "Amount to remove cannot be greater than unclaimed amount");
        unclaimed[_account] =  unclaimed[_account].sub(_amount);
    }

    /**
     * @dev Transfer unclaimed value
     */
    function claim() public {
        require(unclaimed[msg.sender] > 0, "No tokens claimable.");
        uint _unclaimed = unclaimed[msg.sender];
        //add unclaimed to claimed
        claimed[msg.sender] = claimed[msg.sender].add(_unclaimed);
        //reset unclaimed
        unclaimed[msg.sender] = 0;
        //mint tokens to sender
        rootsERC20.mint(msg.sender, _unclaimed);
        //emit event
        emit NewClaim(msg.sender, _unclaimed);
    }

}
