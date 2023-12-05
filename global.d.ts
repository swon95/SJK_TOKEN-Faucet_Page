interface WindowWithEthereum extends Window {
    ethereum?: {
      request: (args: { method: string }) => Promise<string[]>;
      on: (event: string, callback: () => void) => void;
    };
  }