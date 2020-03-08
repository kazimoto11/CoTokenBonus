const CoShoe = artifacts.require("./CoShoe.sol");

module.exports = function(deployer) {
  deployer.deploy(CoShoe);
};
