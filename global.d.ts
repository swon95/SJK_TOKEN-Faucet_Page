// interface WindowWithEthereum extends Window {
//     ethereum?: {
//       request: (args: { method: string }) => Promise<string[]>;
//       on: (event: string, callback: () => void) => void;
//     };
//   }

interface Ethereum {
    request: (args: { method: string }) => Promise<string[]>;
    on: (event: string, callback: () => void) => void;
  }
  
  interface Web3 {
    // Define Web3 properties and methods as needed
  }
  
  interface Window {
    ethereum?: Ethereum;
    web3?: Web3;
  }
  