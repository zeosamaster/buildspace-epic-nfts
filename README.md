# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/run.js
node scripts/deploy.js
npx hardhat help
```

## Usage

1. Rename `hardhat.config.example.js` to `hardhat.config.js`
1. Replace example values:
   1. `networks.rinkeby.url`: get from [Alchemy](https://dashboard.alchemyapi.io/apps/)
   1. `networks.rinkeby.accounts[0]`: get from Metamask -> Account Details -> Export private key (WARNING! DO NOT PUSH YOUR PRIVATE KEY TO ANY PUBLIC REPO)
