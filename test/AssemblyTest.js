const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  const { ethers } = require("hardhat");
  

describe("Lock", function () {
    // beforeEach
    let tokenContract;
    let stakingContract;
    let owner;
    let secondAccount;

    this.beforeEach(async () => {
      [owner, secondAccount] = await ethers.getSigners();
      const Proxy = await ethers.getContractFactory("Token");
      const Implementation = await ethers.getContractFactory("StakingAssembly");
      tokenContract = await Proxy.deploy();
      stakingContract = await Implementation.deploy(tokenContract.target);

    });  
  
   it("Stake" , async () => {
   const data = await stakingContract.token();
   await expect(stakingContract.connect(secondAccount).changeStatus(false)).to.be.reverted;
   stakingContract.changeStatus(true)
    expect(data).to.equal(tokenContract.target);
    await tokenContract.mint(owner.address, 100);
    await tokenContract.approve(stakingContract.target, 100);
    await stakingContract.stake(100);
    const data2 = await stakingContract.balance(owner.address);
    console.log(data2);
    expect( await tokenContract.balanceOf(owner.address)).to.equal(0);

    
    })

});