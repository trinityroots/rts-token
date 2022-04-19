// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IRootsERC20 is IERC20 {
    function burn(address from, uint256 amount) external returns (bool);
}

contract RootsERC20Redeem is AccessControl {

    IRootsERC20 rootsERC20;

    mapping(address => uint) public redeemed;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setRootsERC20Contract(address _address) public onlyRole(DEFAULT_ADMIN_ROLE) {
        rootsERC20 = IRootsERC20(_address);
    }

    /**
     * @dev Redeem tokens in address
     */
    function redeem() public payable {
        require(msg.value > 0, "Redeem tokens must be greater than 0");
        redeemed[msg.sender] += msg.value;
        rootsERC20.burn(msg.sender, msg.value);
    }

}
