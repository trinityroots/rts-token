// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Claim.sol";

contract FooToken is ERC20, AccessControl, Claim {

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant REWARDER_ROLE = keccak256("REWARDER_ROLE");

    uint public constant maxSupply = 100000000 * 10 ** 18;
    uint public mintedAmt;

    constructor() ERC20('Foo Token', 'FOO') {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function burn(address from, uint256 amount) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _burn(from, amount * 10 ** 18);
    }

    /**
     * @dev Store value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value from offchain
     */
    function createClaimable(address _account, uint256 _amount) external {
        require(hasRole(REWARDER_ROLE, msg.sender), "Caller is not a rewarder");
        uint256 _unclaimed = _amount - claimed[_account] - unclaimed[_account];
        require(_unclaimed > 0, 'claimable must be greater than 0');
        addUnclaimed(_account, _unclaimed * 10 ** 18);
    }

    /**
     * @dev Remove value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value to remove
     */
    function removeClaimable(address _account, uint256 _amount) external {
        require(hasRole(REWARDER_ROLE, msg.sender), "Caller is not a rewarder");
        removeUnclaimed(_account, _amount * 10 ** 18);
    }

    function min(uint256 a, uint256 b) public pure returns (uint256) {
        return a <= b ? a : b;
    }

    /**
     * @dev Transfer unclaimed value
     */
    function claim() public payable {
        uint256 _unclaimed = unclaimed[msg.sender];
        require(_unclaimed > 0, "Unclaimed balance must be greater than 0");
        uint256 to_maxSupply = maxSupply - mintedAmt;
        require(to_maxSupply > 0, "The max supply has been exhausted.");
        uint256 min_unclaimed = min(_unclaimed, to_maxSupply);
        claimed[msg.sender] += min_unclaimed;
        unclaimed[msg.sender] = 0;
        mintedAmt += min_unclaimed;
        _mint(msg.sender, min_unclaimed);
    }
}