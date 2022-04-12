const { ethers } = require("hardhat");

const deploy = async()=>{
    const [deployer] = await ethers.getSigners();

    console.log("deploying contract with the account: ", deployer.address);

    const Nftizador = await ethers.getContractFactory("Nftizador");
    const deployed  = await Nftizador.deploy();

    console.log("Nftizador a sigo desplegado en la siguiente direccion: ", deployed.address);
};

deploy()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
});