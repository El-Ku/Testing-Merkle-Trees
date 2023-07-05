# Testing Merkle Trees

- [Testing Merkle Trees](#testing-merkle-trees)
- [Intro](#intro)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
  - [Estimate gas](#estimate-gas)
- [Formatting](#formatting)
- [Thank you!](#thank-you)



# Intro

This contract was created mainly to understand how I can use Merkle proofs in Solidity and write tests for it using Foundry.

I have inherited a ERC20 template from Openzepplin contracts and created mint and burn functionality which restricts the functions to a certain whitelist of addresses. 

The test was written in Forge and for generating root of the Merkle tree and testing its validity I have used [Murky repo](https://github.com/dmfxyz/murky/). I have also used fuzzing approach in the test.

Note that this is not for production and have many vulnerabilities. I just created it for learning purposes.

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`


Install any missing libraries by running:
```bash
forge install https://github.com/OpenZeppelin/openzeppelin-contracts.git --no-commit
forge install https://github.com/dmfxyz/murky.git --no-commit
```

## Quickstart

```
git clone https://github.com/El-Ku/Testing-Merkle-Trees
cd Testing-Merkle-Trees
forge build
```

## Testing

Note that I didnt write any tests for the `burn` function. As the repo was created only to learn about Merkle trees.

```bash
# Test everything without any log messages
forge test

# Test everything with emitted events and console messages
forge test -vv

# Test everything with information printed out on each individual transaction
forge test -vvvv
```

or 

```bash
# Only run test functions matching the specified regex pattern.
forge test --match-test testFunctionName
(OR)
forge test --mt testFunctionName
```

### Test Coverage

```
forge coverage
```

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see and output file called `.gas-snapshot`


# Formatting


To run code formatting:
```
forge fmt
```


# Thank you!

[My Twitter - ElKu](https://twitter.com/ElKu_crypto)
