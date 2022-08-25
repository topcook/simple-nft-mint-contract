require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();
const { MNEMONIC, ETHERSCAN_API_KEY, BSCSCAN_API_KEY } = process.env;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "rinkeby",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161", //for rinkeby
      chainId: 4, //for rinkeby
      // gasPrice: 20000000000,
      accounts: {mnemonic: MNEMONIC}
    },
    ropsten: {
      url: "https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161", //for rinkeby
      chainId: 3, //for ropsten
      // gasPrice: 20000000000,
      accounts: {mnemonic: MNEMONIC}
    },
    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",// for bsc test net
      chainId: 97, //for bsc test net
      // gasPrice: 20000000000,
      accounts: {mnemonic: MNEMONIC}
    },
    mainnet: {
      url: "https://bsc-dataseed.binance.org/", //for bsc main net
      chainId: 56, //for bsc main net
      // gasPrice: 20000000000,
      accounts: {mnemonic: MNEMONIC}
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY //for rinkeby
  },
  bscscan: {
    apiKey: BSCSCAN_API_KEY //for bsc
  },
  solidity: {
  version: "0.8.12",
  settings: {
    optimizer: {
      enabled: true
    }
   }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  }
};