// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./RootsERC20Claimable.sol";

contract RootsERC20Redeemable is RootsERC20Claimable {

    mapping(address => uint) public redeemed;

    /**
     * @dev Redeem tokens in address
     */
    function redeem() public payable {
        require(msg.value > 0, "Redeem tokens must be greater than 0");
        redeemed[msg.sender] += msg.value;
        _burn(msg.sender, msg.value);
    }

}
