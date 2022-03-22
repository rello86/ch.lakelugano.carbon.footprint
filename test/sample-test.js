const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("CarbonFootPrintYearTest", function () {
    it("CarbonFootPrint validate init year array", async function () {
        const CarbonFootPrint = await ethers.getContractFactory("CarbonFootPrint");
        const carbonfootprint = await CarbonFootPrint.deploy();
        await carbonfootprint.deployed();

        expect(await carbonfootprint.getYearsCount()).to.equal(1);
        expect(await carbonfootprint.existsYear('2022')).to.equal(true);

    });

    it("CarbonFootPrint add SNL org", async function () {
        const CarbonFootPrint = await ethers.getContractFactory("CarbonFootPrint");
        const carbonfootprint = await CarbonFootPrint.deploy();
        await carbonfootprint.deployed();

        const setOrg = await carbonfootprint.addOrganization(
            'SNL', 'SOCIETA NAVIGAZIONE LAGO LUGANO', []);
        //wait until the transaction is mined
        await setOrg.wait();
        expect(await carbonfootprint.getOrgCount()).to.equal(1);

    });

    it("CarbonFootPrint add MN CERESIO ship", async function () {
        const CarbonFootPrint = await ethers.getContractFactory("CarbonFootPrint");
        const carbonfootprint = await CarbonFootPrint.deploy();
        await carbonfootprint.deployed();

        const setOrg = await carbonfootprint.addOrganization(
            'SNL', 'SOCIETA NAVIGAZIONE LAGO LUGANO', []);
        //wait until the transaction is mined
        await setOrg.wait();
        expect(await carbonfootprint.getOrgCount()).to.equal(1);

        const addShip = await carbonfootprint.addShip('MN CERESIO', 1, []);
        //wait until the transaction is mined
        await addShip.wait();
        expect(await carbonfootprint.getShipsCount()).to.equal(1);
    });

    it("CarbonFootPrint add FootPrint for MN CERESIO ship", async function () {
        const CarbonFootPrint = await ethers.getContractFactory("CarbonFootPrint");
        const carbonfootprint = await CarbonFootPrint.deploy();
        await carbonfootprint.deployed();

        const setOrg = await carbonfootprint.addOrganization(
            'SNL', 'SOCIETA NAVIGAZIONE LAGO LUGANO', []);
        //wait until the transaction is mined
        await setOrg.wait();
        expect(await carbonfootprint.getOrgCount()).to.equal(1);

        const addShip = await carbonfootprint.addShip('MN CERESIO', 1, []);
        //wait until the transaction is mined
        await addShip.wait();
        expect(await carbonfootprint.getShipsCount()).to.equal(1);

        const addFootPrintShip = await carbonfootprint.addFootPrintShip(907185, 1, 2022, 3, 22, 3);
        //wait until the transaction is mined
        await addFootPrintShip.wait();
        expect(await carbonfootprint.sfootPrintCount()).to.equal(1);
    });
});
