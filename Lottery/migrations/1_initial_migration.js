const Migrations = artifacts.require("Migrations");

//migration files used to deploy contracts on the blockchain

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
