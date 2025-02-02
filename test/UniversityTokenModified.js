const { expect } = require("chai");

describe("UniversityToken Modified", function () {
    let UniversityToken, universityToken, owner, addr1, addr2;

    beforeEach(async function () {
        UniversityToken = await ethers.getContractFactory("UniversityToken");
        [owner, addr1, addr2] = await ethers.getSigners();
        universityToken = await UniversityToken.deploy(owner.address);
    });

    it("Should set the correct owner in constructor", async function () {
        expect(await universityToken.owner()).to.equal(owner.address);
    });

    it("Should mint tokens to the specified owner", async function () {
        const ownerBalance = await universityToken.balanceOf(owner.address);
        expect(ownerBalance).to.equal(ethers.parseUnits("2000", 18));
    });
});
