const tokenAddress = '0x25a5b89eDCA30932C833379E4ec482bD9523388c';
const tokenSymbol = 'RTS';
const tokenDecimals = 18;
const tokenImage = 'https://trinityroots.github.io/rts-token/roots-logo.ico';

async function addTokenFunction() {

    try {
    
        const wasAdded = await ethereum.request({
            method: 'wallet_watchAsset',
            params: {
                type: 'ERC20', 
                options: {
                        address: tokenAddress, 
                        symbol: tokenSymbol, 
                        decimals: tokenDecimals, 
                        image: tokenImage, 
                },
            },
        });

        if (wasAdded) {
            alert('Roots Token has been added');
        } else {
            alert('Roots Token has not been added');
        }
    } catch (error) {
        console.log(error);
    }
}