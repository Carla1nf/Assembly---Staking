const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("Lock", function () {
  // beforeEach
  let proxyContract;
  let implementationContract;
  this.beforeEach(async () => {
    const Proxy = await ethers.getContractFactory("ProxyContract");
    const Implementation = await ethers.getContractFactory("ImplementationContract");
    implementationContract = await Implementation.deploy();
    proxyContract = await Proxy.deploy(implementationContract.target);
  });  

 it("Proxy it" , async () => { 

  await proxyContract.callImplementation(2);
  expect(await proxyContract.unlockTime()).to.equal(2);
  expect(await implementationContract.storage1()).to.equal(0);
  expect(await ethers.provider.getStorage(proxyContract.target, '0x00')).to.equal("0x0000000000000000000000000000000000000000000000000000000000000002")
   

 }),

 it("Proxy Array", async () => {
  await proxyContract.callImplementation2([10,2,3]);
  expect(await proxyContract.allNumbers(0)).to.equal(10);
  expect(await ethers.provider.getStorage(proxyContract.target, '0x01')).to.equal("0x0000000000000000000000000000000000000000000000000000000000000003");
  // keccack256 the number 1
  const hashedStorageSlot0 = await ethers.keccak256('0x0000000000000000000000000000000000000000000000000000000000000001');
  
  expect(await ethers.provider.getStorage(proxyContract.target, hashedStorageSlot0)).to.equal("0x000000000000000000000000000000000000000000000000000000000000000a");
   
   // hashedStorageSlot0 + 1
    const hashedStorageSlot1 = '0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf7'
    
    expect(await ethers.provider.getStorage(proxyContract.target, hashedStorageSlot1)).to.equal("0x0000000000000000000000000000000000000000000000000000000000000002");


}),

it("Proxy Mapping", async () => {
  await proxyContract.callImplementation3(0, 3);
  const hashedMappingSlot0 = await proxyContract.getMappingSlot(0,2);
  expect(await ethers.provider.getStorage(proxyContract.target, hashedMappingSlot0)).to.equal("0x0000000000000000000000000000000000000000000000000000000000000003");
})
});
