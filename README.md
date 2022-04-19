# Roots Token (RTS)

## Token Contract
- Name: RootsERC20.sol
- Contract ID: 0x6Cba4Cd6b395193fd33772DA9713325Cc41CC7f8
- Location: Avalanche FUJI C-Chain
- Explorer: https://testnet.snowtrace.io/address/0x6Cba4Cd6b395193fd33772DA9713325Cc41CC7f8

## Token Features
- Name: Roots Token
- Symbol: RTS
- Decimals: 18
- Max Supply: 100,000,000
- Expiry: None
- Transferable
- Mintable
- Burnable
- RBAC: Admin, Minter, Burner


## Claim
- Name: RootsERC20Claim.sol
- Contract ID: 0x03e2Dbd707fBC02201a671c5f97aB48daEDfC587
- Token Interface: Roots Token (RTS)
- RBAC: Admin


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
