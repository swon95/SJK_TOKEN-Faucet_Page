import { useState } from "react";
import { providers } from 'ethers';

const App = () => {
    const [isConnecting, setIsConnecting] = useState(false);
    const [walletAddress, setWalletAddress] = useState<null | string>(null)
  
    let provider: providers.Web3Provider;
    
    // MetaMask 연결
    const walletConnect = async () => {
      if (typeof window.ethereum !== 'undefined') {
          // 메타마스크가 있을 시 지갑연결 요청
          provider = await new providers.Web3Provider(window.ethereum);
          const accounts = await provider.send('eth_requestAccounts', []);
          console.log('connected to ', accounts[0]);
          setWalletAddress(accounts[0]);
          
          setIsConnecting(true);
        } else {
          alert('please install MetaMask');
        }
      };
    


  return (
    <div>
      {!isConnecting && <p>Please Install MetaMask!</p>}

      {!isConnecting && (
        <button
          className="flex items-center gap-2 border border-gray-600 rounded p-2 text-gray-700 hover:bg-gray-100"
          onClick={walletConnect}
        >
          <img
            className="w-8 h-8"
            src="https://upload.wikimedia.org/wikipedia/commons/3/36/MetaMask_Fox.svg"
            alt="MetaMask Logo"
          />
          <p className="text-lg">Connect MetaMask</p>
        </button>
      )}

      {isConnecting && (
        <>
          <div>
            <h1>Connected to MetaMask</h1>
            <div>
              <div>Accounts: {walletAddress}</div>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default App;
