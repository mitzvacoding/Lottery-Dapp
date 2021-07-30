pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LotteryPlace is Ownable {
    event startedLottery();

    address[] public users;
    uint256 public usersAmount;
    uint256 signFee = 0.001 ether;

    struct Winning {
        address user;
        uint256 amount;
        uint256 winNumber;
    }

    Winning[] private winningBoard;

    function getUsers() public view returns (address[] memory) {
        return users;
    }

    function getUsersAmount() public view returns (uint256) {
        return usersAmount;
    }

    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }

    function sendReward(address payable _to) internal onlyOwner {
        //send and record the winning.
        uint256 amount = uint256(address(this).balance);
        address user = _to;
        uint256 winNumber = winningBoard.push(Winning(user, amount, 0)) - 1;
        winningBoard[winNumber].winNumber = winNumber;

        _to.transfer(address(this).balance);
    }

    function lotteryInit() internal onlyOwner {
        delete users;
    }

    function raffleWinnerNumber() internal view returns (uint256) {
        //returns index of winner
        uint256 sum = 0;
        for (uint256 i = 0; i < usersAmount; i++) {
            sum += uint256(users[i]);
        }

        return sum % usersAmount;
    }

    function startLottery() internal onlyOwner {
        //when amount of participents reached this function is called
        //steps:
        //1- generate random number.
        //2- sends reward
        //3- resets the lottery for next round
        address payable winningAddress = address(
            uint160(users[raffleWinnerNumber()])
        );
        sendReward(winningAddress);
        //emit lotteryFinished()
    }

    function buyTicket() external payable {
        require(msg.value == signFee);
        usersAmount = users.push(msg.sender);

        if (usersAmount == 3) {
            emit startedLottery();
            startLottery();
        }
    }
}
