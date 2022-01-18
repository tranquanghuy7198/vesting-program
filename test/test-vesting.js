require('@nomiclabs/hardhat-ethers');

const hre = require('hardhat');
const { expect } = require("chai");
const VESTING = "Vesting";
const VIK_TOKEN = "VIKToken";

before("Deploy VIK and Vesting contract", async () => {
  // Prepare parameters
  const [deployer, operator, participant, paymentWallet] = await hre.ethers.getSigners();
  this.deployer = deployer;
  this.operator = operator;
  this.participant = participant;
  this.paymentWallet = paymentWallet;

  // Deploy VIKToken contract
  this.vikFactory = await hre.ethers.getContractFactory(VIK_TOKEN);
  this.vikContract = await this.vikFactory.deploy();
  await this.vikContract.deployed();

  // Deploy Vesting contract
  this.vestingFactory = await hre.ethers.getContractFactory(VESTING);
  this.vestingContract = await this.vestingFactory.deploy(
    this.vikContract.address,
    this.paymentWallet.address
  );
  await this.vestingContract.deployed();
});

describe("Test Vesting contract", () => {
  it("Check initial values", async () => {
    let vikAddress = await this.vestingContract.VIK();
    let numPrograms = await this.vestingContract.getNumPrograms();
    expect(vikAddress).to.equal(this.vikContract.address);
    expect(numPrograms.toString()).to.equal("11");
  });

  it("Mint some VIK tokens to the payment wallet and approve", async () => {
    await this.vikFactory
      .connect(this.paymentWallet)
      .attach(this.vikContract.address)
      .faucet("680000000000000000000000000");
    await this.vikFactory
      .connect(this.paymentWallet)
      .attach(this.vikContract.address)
      .approve(this.vestingContract.address, "680000000000000000000000000");
    let balance = await this.vikContract.balanceOf(this.paymentWallet.address);
    let allowance = await this.vikContract.allowance(this.paymentWallet.address, this.vestingContract.address);
    expect(balance.toString()).to.equal("680000000000000000000000000");
    expect(allowance.toString()).to.equal("680000000000000000000000000");
  });

  it("Set operator's role", async () => {
    await this.vestingFactory
      .connect(this.deployer)
      .attach(this.vestingContract.address)
      .setOperator(this.operator.address, true);
  });

  it("Register a participant who purchases 1,000,000 VIKs at private sale", async () => {
    await this.vestingFactory
      .connect(this.operator)
      .attach(this.vestingContract.address)
      .registerParticipant(this.participant.address, 1, "1000000000000000000000000");
    let vestingAmount = await this.vestingContract.getVestingAmount(this.participant.address, 1);
    expect(vestingAmount.toString()).to.equal("1000000000000000000000000");
  });

  it("Start TGE", async () => {
    await this.vestingFactory
      .connect(this.operator)
      .attach(this.vestingContract.address)
      .startTGE();
    let TGE = await this.vestingContract.TGE();
    expect(TGE.toString()).to.not.equal("0");
  });

  it("Claim tokens", async () => {
    await sleep(16000);
    await this.vestingFactory
      .connect(this.participant)
      .attach(this.vestingContract.address)
      .claimTokens();
    let balance = await this.vikContract.balanceOf(this.participant.address);
    expect(balance.toString()).to.equal("140000000000000000000000");
  });

  it("Emergency withdraw", async () => {
    await this.vestingFactory
      .connect(this.deployer)
      .attach(this.vestingContract.address)
      .emergencyWithdraw(this.deployer.address);
    let balance = await this.vikContract.balanceOf(this.deployer.address);
    expect(balance.toString()).to.equal("860000000000000000000000");
  });
});

let sleep = ms => {
  return new Promise(resolve => setTimeout(resolve, ms));
};

// Run: npx hardhat test ./test/test-vesting.js