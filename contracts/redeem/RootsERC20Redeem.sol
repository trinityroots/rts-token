// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @dev defining functions we will use in this contract through an interface
 */
interface IRootsERC20 is IERC20 {
    // Redeem is assumed to burn the token and thus reduce totalSupply
    function burn(address from, uint256 amount) external returns (bool);
}

/**
 * @dev Creating a redeem service for ERC20
 */
contract RootsERC20Redeem is AccessControl {

    using SafeMath for uint256;

    event NewRedeem(address sender, uint value);

    IRootsERC20 public rootsERC20;

    mapping(address => uint) public redeemed;

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
     * @dev Redeem tokens in address through burn
     */
    function redeem() public payable {
        require(msg.value > 0, "Value cannot be zero");
        require(msg.value <= rootsERC20.balanceOf(msg.sender), "Balance insufficient");
        redeemed[msg.sender] = redeemed[msg.sender].add(msg.value);
        rootsERC20.burn(msg.sender, msg.value);
        emit NewRedeem(msg.sender, msg.value);
    }

}
