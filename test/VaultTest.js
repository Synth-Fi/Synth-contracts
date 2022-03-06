const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Vault tests", function () {

  var vault;
  var wEth;

  beforeEach(async function(){

    const [owner] = await ethers.getSigners();
    
    // Deploy wEth contract
    const WEth = await ethers.getContractFactory("wEth");
    wEth = await WEth.deploy(0);
    await wEth.deployed();

    // Deploy Vault contract
    const Vault = await ethers.getContractFactory("Vault");
    vault = await Vault.deploy();
    await vault.deployed();

  });

  it("Deposit some wEth into vault", async function() {

    const [owner] = await ethers.getSigners();
  
    // Check owner balance
    let ownerBalance = await wEth.balanceOf(owner.address);
    expect(ownerBalance).to.equal(ethers.utils.parseUnits("0", 18));

    // Check vault balance
    let vaultBalance = await wEth.balanceOf(vault.address);
    expect(vaultBalance).to.equal(ethers.utils.parseUnits("0", 18));

    // Give depositor some wEth
    await wEth.give(ethers.utils.parseUnits("1000", 18));  
    ownerBalance = await wEth.balanceOf(owner.address);
    expect(ownerBalance).to.equal(ethers.utils.parseUnits("1000", 18));

    await wEth.approve(vault.address, ethers.utils.parseUnits("45", 18)); // Give vault allowance

    await vault.deposit_token(wEth.address, ethers.utils.parseUnits("45", 18)); // Deposit 45 wEth

    // Check Vault balance of wEth
    vaultBalance = await wEth.balanceOf(vault.address);
    expect(vaultBalance).to.equal(ethers.utils.parseUnits("45", 18));

    // Check depositor's vault balance
    let depositorVaultBalance = await vault.account_token_balance(wEth.address);
    expect(depositorVaultBalance).to.equal(ethers.utils.parseUnits("45", 18));

    // Check depositors wEth balance
    ownerBalance = await wEth.balanceOf(owner.address);
    expect(ownerBalance).to.equal(ethers.utils.parseUnits("955", 18));
  });

  it("Withdraw some wEth out of vault", async function() {
    const [owner] = await ethers.getSigners();

    await wEth.give(ethers.utils.parseUnits("1000", 18));                         // Give depositor some wEth
    await wEth.approve(vault.address, ethers.utils.parseUnits("45", 18));         // Give vault allowance
    await vault.deposit_token(wEth.address, ethers.utils.parseUnits("45", 18));   // Deposit 45 wEth

    await vault.withdraw_token(wEth.address, ethers.utils.parseUnits("20", 18));  // Withdraw 20 wEth

    expect(await vault.account_token_balance(wEth.address)).to.equal(ethers.utils.parseUnits("25", 18));  // Check account balance

    expect(await wEth.balanceOf(owner.address)).to.equal(ethers.utils.parseUnits("975", 18));   // Check depositor wEth balance

    expect(await wEth.balanceOf(vault.address)).to.equal(ethers.utils.parseUnits("25", 18));  // check vault wEth balance

  });
});