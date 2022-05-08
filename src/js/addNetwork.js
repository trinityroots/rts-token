async function addNetwork() {         

    if (typeof window.ethereum !== "undefined") {
        params = [{
            chainId: '0xA869',
            chainName: 'Avalanche FUJI C-Chain',
            nativeCurrency: {
                name: 'AVAX',
                symbol: 'AVAX',
                decimals: 18
            },
            rpcUrls: ['https://api.avax-test.network/ext/bc/C/rpc'],
            blockExplorerUrls: ['https://testnet.snowtrace.io']
        }]
    
        window.ethereum.request({ method: 'wallet_addEthereumChain', params })
            .then(() => alert('Chain has been added!'))
            .catch((error) => alert(error.message));
    } else {
        alert("You must install Metamask!")
    }
}
    