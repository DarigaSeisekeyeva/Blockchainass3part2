const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("UniversityToken", function () {
    let UniversityToken, universityToken, owner, addr1, addr2;

    beforeEach(async function () {
        UniversityToken = await ethers.getContractFactory("UniversityToken");
        [owner, addr1, addr2] = await ethers.getSigners();
        universityToken = await UniversityToken.deploy(owner.address);
    });

    it("Should assign the initial supply of 2000 tokens to the owner", async function () {
        const ownerBalance = await universityToken.balanceOf(owner.address);
        expect(ownerBalance).to.equal(ethers.parseUnits("2000", 18));
    });

    it("Should allow transfer of tokens between accounts", async function () {
        await universityToken.transfer(addr1.address, ethers.parseUnits("100", 18));
        expect(await universityToken.balanceOf(addr1.address)).to.equal(ethers.parseUnits("100", 18));
    });

    it("Should correctly log transactions", async function () {
        await universityToken.transfer(addr1.address, ethers.parseUnits("50", 18));
        const txn = await universityToken.getTransaction(0);
        expect(txn.sender).to.equal(owner.address);
        expect(txn.receiver).to.equal(addr1.address);
        expect(txn.amount).to.equal(ethers.parseUnits("50", 18));
    });

    it("Should return the latest transaction timestamp", async function () {
        await universityToken.transfer(addr1.address, ethers.parseUnits("25", 18));
        const timestamp = await universityToken.getLatestTimestamp();
        expect(timestamp).to.be.a("string");
    });

    it("Should return sender and receiver of a transaction", async function () {
        await universityToken.transfer(addr1.address, ethers.parseUnits("40", 18));
        expect(await universityToken.getSender(0)).to.equal(owner.address);
        expect(await universityToken.getReceiver(0)).to.equal(addr1.address);
    });
});
