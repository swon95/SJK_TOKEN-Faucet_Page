import React, { useEffect, useState } from "react";
import Web3 from "web3";

const App: React.FC = () => {
  const [web3, setWeb3] = useState<Web3 | null>(null);
  const [accounts, setAccounts] = useState<string[]>([]);
  const [isConnecting, setIsConnecting] = useState(false);

  const walletConnect = async () => {
    // MetaMask 연결
    if (window.ethereum) {
      const web3Instance = new Web3(window.ethereum);
      try {
        // 계정 접근을 사용자에게 요청
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        setAccounts(accounts);
        setWeb3(web3Instance);
        setIsConnecting(true);
      } catch (error) {
        console.error("User denied account access");
      }
    }
    // Legacy dapp browsers
    else if (window.web3) {
      const web3Instance = new Web3(window.web3.currentProvider);
      setWeb3(web3Instance);
    }
    // Non-dapp browsers
    else {
      console.log(
        "Non-Ethereum browser detected. You should consider trying MetaMask!"
      );
    }
  };

  useEffect(() => {
    if (web3) {
      // You can perform additional tasks when web3 is available
    }
  }, [web3]);

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
              <strong>Accounts:</strong>
              {accounts.map((account, i) => (
                <div key={i}>{account}</div>
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default App;
