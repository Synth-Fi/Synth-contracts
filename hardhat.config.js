require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

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
  solidity: {
    compilers: [
      // {
      //   version: "0.8.0",
      // },
      {
        version: "0.7.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    ],
    overrides: {
      // "contracts/Vault.sol": {
      //   version: "0.8.0",
      //   settings: { }
      // },
      "contracts/wEth.sol": {
        version: "0.8.0",
        settings: { }
      },
      "@openzeppelin/contracts4/token/ERC20/IERC20.sol": {
        version: "0.8.0",
        settings: { }
      },
      "@openzeppelin/contracts4/token/ERC20/ERC20.sol": {
        version: "0.8.0",
        settings: { }
      },
      "@openzeppelin/contracts4/utils/Context.sol": {
        version: "0.8.0",
        settings: { }
      },
      "@openzeppelin/contracts4/token/ERC20/extensions/IERC20Metadata.sol": {
        version: "0.8.0",
        settings: { }
      },
    },
  },
};
