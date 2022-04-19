# Roots Token (RTS)

## Token Contract
- Name: RootsERC20.sol
- Contract ID: 0x6Cba4Cd6b395193fd33772DA9713325Cc41CC7f8
- Location: Avalanche FUJI C-Chain
- Explorer: https://testnet.snowtrace.io/address/0x6Cba4Cd6b395193fd33772DA9713325Cc41CC7f8

This token contract uses OpenZeppelin for standard implementations of ERC.
See the following: https://github.com/OpenZeppelin/openzeppelin-contracts

## Tokenomics
### Features
- Name: Roots Token
- Symbol: RTS
- Decimals: 18
- Max Supply: 100,000,000
- Expiration: None
- Transferable
- Mintable
- Burnable
- RBAC: Admin, Minter, Burner

### Token Earn and Usage
Roots Token (RTS) is used solely a utility token on the Roots ecosystem. Due to the following behaviors, the total supply is expected to fluctuate in accordance to rate of earn and usage.
- Tokens are earned through activities that contribute to the health of the Roots ecosystem. Through claiming, new tokens are minted into existence.
- Used tokens are removed from circulation through token burn, thus reducing total supply.


## Claim
- Name: RootsERC20Claim.sol
- Contract ID: 0x03e2Dbd707fBC02201a671c5f97aB48daEDfC587
- Token Interface: Roots Token (RTS)
- RBAC: Admin

The claim system operates with the token through IERC20, the interface for ERC20. It holds both unclaimed and claimed balances. Unclaimed balances are set through calls from offchain and computed as follows:

diff = amount_offchain - claimed - unclaimed

e.g
amount_offchain = 10
claimed = 5
unclaimed = 3

-> diff = 2

This diff value is then added to unclaimed as an update, ready to be claimed. This allows for synchronizing between values offchain and onchain.


## Redeem
The redeem contract interfaces with RootsERC20 for the purpose of redeeming rewards.
- Name: RootsERC20Redeem.sol
- Contract ID: 0xBfe8114879964ca7188477AA0717f1F4067b1C00
- Token Interface: Roots Token (RTS)
- RBAC: Admin


## Adding the Custom RPC
After adding the following custom RPC, you may import the token using its contract address.
- Network Name: Avalanche FUJI C-Chain
- New RPC URL: https://api.avax-test.network/ext/bc/C/rpc
- ChainID: 43113
- Symbol: AVAX
- Block Explorer URL: https://cchain.explorer.avax-test.network
