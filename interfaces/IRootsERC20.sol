// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev defining functions we will use in our contracts through an interface
 */
interface IRootsERC20 is IERC20 {
    function mint(address to, uint256 amount) external returns (bool);
    function burn(address from, uint256 amount) external returns (bool);
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external returns (bool);
    function revokeRole(bytes32 role, address account) external;
    function renounceRole(bytes32 role, address account) external;
}