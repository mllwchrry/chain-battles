const main = async () => {
    try {
      const nftContract = await hre.ethers.deployContract('ChainBattles');
      await nftContract.waitForDeployment();
  
      console.log("Contract deployed to:", await nftContract.getAddress());
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
    
  main();