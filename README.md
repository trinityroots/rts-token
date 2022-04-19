# Roots Token (RTS)

## Token Contract
- Name: RootsERC20.sol
- Contract ID: 0x8803ABa801633D715A359A561Be0c84Ae416C2B6
- Location: Avalanche FUJI C-Chain
- Explorer: https://testnet.snowtrace.io/address/0x8803ABa801633D715A359A561Be0c84Ae416C2B6

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


## Claim Contract
- Name: RootsERC20Claim.sol
- Contract ID: 0x0a0971960a16bCb527859AdFCCBAdCf07FF2a71a
- Token Interface: Roots Token (RTS)
- RBAC: Admin


## Redeem Contract
The redeem contract interfaces with RootsERC20 for the purpose of redeeming rewards.
- Name: RootsERC20Redeem.sol
- Contract ID: 0xBeC8619b770688446e097bB9e26C30E8c0ACF72e
- Token Interface: Roots Token (RTS)
- RBAC: Admin


## Adding the Custom RPC
After adding the following custom RPC, you may import the token using its contract address.
- Network Name: Avalanche FUJI C-Chain
- New RPC URL: https://api.avax-test.network/ext/bc/C/rpc
- ChainID: 43113
- Symbol: AVAX
- Block Explorer URL: https://cchain.explorer.avax-test.network
