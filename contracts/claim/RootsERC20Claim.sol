// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IRootsERC20 is IERC20 {
    function mint(address to, uint256 amount) external returns (bool);
    function _cap() external view returns (uint);
}

contract RootsERC20Claim is AccessControl {

    IRootsERC20 rootsERC20;

    mapping(address => uint) public unclaimed;
    mapping(address => uint) public claimed;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setRootsERC20Contract(address _address) public onlyRole(DEFAULT_ADMIN_ROLE) {
        rootsERC20 = IRootsERC20(_address);
    }

    /**
     * @dev Store value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value from offchain
     */
    function createClaimable(address _account, uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_amount > claimed[_account] + unclaimed[_account], "Amount must be greater than the sum of claim and unclaimed");
        uint diff = _amount - claimed[_account] - unclaimed[_account];
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

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a <= b ? a : b;
    }

    /**
     * @dev Transfer unclaimed value
     */
    function claim() public payable {
        uint _unclaimed = unclaimed[msg.sender];
        //get distance to max supply
        uint to_maxSupply = rootsERC20._cap() - rootsERC20.totalSupply();
        //take minimum to allow minting less when close to max supply
        uint min_unclaimed = min(_unclaimed, to_maxSupply);
        //add unclaimed to claimed
        claimed[msg.sender] += min_unclaimed;
        //reset unclaimed
        unclaimed[msg.sender] = 0;
        //mint tokens to sender
        rootsERC20.mint(msg.sender, min_unclaimed);
    }

}
