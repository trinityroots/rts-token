# Roots Token (RTS)

## Token Contract
- Name: RootsERC20.sol
- Contract ID: 0x25a5b89eDCA30932C833379E4ec482bD9523388c
- Location: Avalanche FUJI C-Chain
- Explorer: [Snowtrace](https://testnet.snowtrace.io/address/0x25a5b89eDCA30932C833379E4ec482bD9523388c)

This token contract uses [Open Zeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts) for standard implementations of ERC.

## Additional Contracts


| Contract | Address | RBAC | Description
| --- | --- | --- | --- |
| RootsERC20BatchOperation | 0x910AA8d9f4164ff882f462afE27487Df08e64666 | Yes | Adds Batch Operations to RTS |
| RootsERC20RBACTransparent |  | Yes | Allows execution of revoke and grant access Operations |
| RootsERC20Redeem |  | Yes | Redeem feature for RTS |
| RootsERC20Claim |  | Yes | Claim feature for RTS |

## Tokenomics
### Features
- Name: Roots Token
- Symbol: RTS
- Decimals: 18
- Max Supply: None
- Expiration: None
- Transferable
- Mintable
- Burnable
- RBAC: Admin, Minter, Burner


### Token Earn and Usage
Roots Token (RTS) is used solely a utility token on the Roots ecosystem. Due to the following behaviors, the total supply is expected to fluctuate in accordance to rate of earn and usage.
- Tokens are earned through activities that contribute to the health of the Roots ecosystem. Through claiming, new tokens are minted into existence.
- Used tokens are removed from circulation through token burn, thus reducing total supply.


## Adding the Custom RPC
After adding the following custom RPC, you may import the token using its contract address.
- Network Name: Avalanche FUJI C-Chain
- New RPC URL: https://api.avax-test.network/ext/bc/C/rpc
- ChainID: 43113
- Symbol: AVAX
- Block Explorer URL: https://cchain.explorer.avax-test.network


## Getting Started (with Remix)
1. Visit [Remix IDE](https://remix.ethereum.org/)
2. Go to the plugin manager and install DGIT.
3. Configure DGIT by going to Github Settings and add your personal github token, name, and email
4. Clone the dev branch of this repository
5. Open the contracts folder and in token you must compile RootsERC20.sol
6. Deploy the contract
