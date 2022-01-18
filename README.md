# Vikingdom token vesting report

## Project structure

The submitted files include the token contract (`VIKToken.sol`), the vesting contract (`Vesting.sol`), the unit-test file (`test-vesting.js`) and the report (this document).

## Token contract
The file `VIKToken.sol` is the simplest implementation of an ERC20 token whose symbol and name are **VIK** and **Vikingdom token**, respectively. This contract is used for testing only and should not be used in the production version. This is because the initial total supply is zero and the contract has a faucet function to get free VIK token for testing.

To use this contract in the production version, remove the faucet function and add some necessary information such as total supply, initial minted address, etc. The information varies based on the specific demand of each project.

## Vesting contract

### "Program" struct

There are 11 vesting programs in the whole project and this struct contains the basic information to describe a specific program.

* `id`: The IDs of the programs increase from 0 to 10.
* `name`: The names of the programs (e.g: Private Sale).
* `totalAllocation`: The total amount of VIK token allocated to this program.
* `availableAmount`: The remaining amount of VIK tokens allocated this program after some participants have purchased some tokens. At the first time, `availableAmount` is equal to `totalAllocation`.

### "VestingInfo" struct

This struct contains the information of a participant:

* `claimedAmount`: The amount of VIK tokens he has claimed so far.
* `atProgram`: His vesting amount at a specific program.

### Variables

* `TGE`: The TGE moment.
* `VIK`: The address of the `VIKToken` contract, which had been deployed before the Vesting contract was deployed.
* `allPrograms`: The array of 11 vesting programs.
* `_MONTH`: The length of a month. In unit-tests, it is set to 5s. In the testnet environment, it is set to 10min. In the production version, it is set to 30day.
* `_paymentWallet`: The money storage, where VIK tokens used for vesting program are stored. This should be as safe as possible.
* `_operators`: Only the operators can perform specific actions.
* `_vestingInfoOf`: The vesting information of participants.

### Functions

At any time, one of the operators can use the `registerParticipant()` function to register the vesting information of a participant to the contract, the registered information includes the address of the participant, the ID of the vesting program (from 0 to 10) and the vesting amount of that participant.

When the `startTGE()` function is called, the whole vesting program is active and participants are allowed to claim their vesting tokens. Note that the `startTGE()` function can be called only once during the entire vesting program due to the `require()` statement at the first line of this function.

After TGE is started, participants can use the `claimTokens()` function to claim their vesting tokens at any time. The claimable amount is calculated by the `getClaimableAmount()` function. It is recommended that participants should claim their tokens only when the `getClaimableAmount()` function returns positive values. Otherwise, if `getClaimableAmount()` returns 0, participants will lose a small amount of gas to execute `claimTokens()` without receiving anything.

## Installation

Hardhat is used to run the unit-test file and to deploy these contracts to the Testnet. The current compiler version used in this example is Solidity 0.8.6.

## Run unit-tests

As mentioned above, the duration of a month should be set to 5 seconds when running the unit-tests. This is because the normal duration of running Hardhat unit-tests is limited to 20 seconds. For this reason, before running the uni-tests, the line 44 in the `Vesting.sol` file should be fixed as:

> _MONTH = 5;

The command to run unit-tests is:

> npx hardhat run ./test/test-vesting.js

(The `test-vesting.js` file is expected to be placed in the `test` folder)

## Deployment

The `VIKToken.sol` contract was deployed to BSC Testnet at [0x724582899A60f176D3323494A9f1f785E8CCD0A2](https://testnet.bscscan.com/address/0x724582899A60f176D3323494A9f1f785E8CCD0A2#code).

The `Vesting.sol` contract was deployed to BSC Testnet at [0xb3935c4977Ad5B4B706b89cd0A7a5D87F815818A](https://testnet.bscscan.com/address/0xb3935c4977Ad5B4B706b89cd0A7a5D87F815818A#code).

These 2 contracts have been verified already so it is easier to read their information and to interact with them.