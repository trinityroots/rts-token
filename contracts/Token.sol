// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Claim.sol";

contract FooToken is ERC20, AccessControl, Claim {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant REWARDER_ROLE = keccak256("REWARDER_ROLE");

    constructor() ERC20('Foo Token', 'FOO') {
        _mint(address(this), 100000000 * 10 ** 18);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address to, uint amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    } 

    function burn(address from, uint256 amount) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _burn(from, amount);
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
        addUnclaimed(_account, _unclaimed);
    }

    /**
     * @dev Remove value in address mapped with unclaimed amounts using virtual amount (offchain value)
     * @param _account account with value stored
     * @param _amount value to remove
     */
    function removeClaimable(address _account, uint256 _amount) external {
        require(hasRole(REWARDER_ROLE, msg.sender), "Caller is not a rewarder");
        removeUnclaimed(_account, _amount);
    }

    /**
     * @dev Transfer unclaimed value
     */
    function claim() public payable {
        uint256 _unclaimed = unclaimed[msg.sender];
        require(_unclaimed > 0, "Unclaimed balance must be greater than 0");
        claimed[msg.sender] += _unclaimed;
        unclaimed[msg.sender] = 0;
        this.transfer(msg.sender, _unclaimed * 10 ** 18);
    }
}