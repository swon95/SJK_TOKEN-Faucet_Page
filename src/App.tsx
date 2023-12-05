import { useState, useEffect } from "react";

const App = () => {
  const [isConnecting, setIsConnecting] = useState(false);
  const [walletAddress, setWalletAddress] = useState<string | null>(null);

  const walletConnect = async () => {
    if ((window as WindowWithEthereum).ethereum) {
      try {
        const accounts = await (window as WindowWithEthereum).ethereum?.request(
          {
            method: "eth_requestAccounts",
          }
        );
        if (accounts && accounts.length > 0) {
          console.log("Connected to", accounts[0]);
          setWalletAddress(accounts[0]);

          setIsConnecting(true);
        }
      } catch (error) {
        console.log(error);
      }
    } else {
      alert("Please installed MetaMask");
    }
  };

  useEffect(() => {
    if (isConnecting) {
      // added task
    }
  }, [isConnecting]);

  return (
    <div>
      {!isConnecting && <p>Please Installed MetaMask !</p>}

      {!isConnecting && (
        <button
          className="flex items-center gap-2 border border-gray-600 rounded p-2 text-gray-700 hover:bg-gray-100"
          onClick={walletConnect}
        >
          <img
            className="w-8 h-8"
            src={
              "https://upload.wikimedia.org/wikipedia/commons/3/36/MetaMask_Fox.svg"
            }
            alt="MetaMask Logo"
          />
          <p className="text-lg">Connect MetaMask</p>
        </button>
      )}

      {isConnecting && (
        <>
          <div>Wallet Accounts: {walletAddress}</div>
        </>
      )}
    </div>
  );
};

export default App;
