const Color = artifacts.require("Color");
const LotteryPlace = artifacts.require("LotteryPlace")


module.exports = function(deployer) {
  deployer.deploy(LotteryPlace);
};
