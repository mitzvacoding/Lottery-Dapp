pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

contract MissileFactory is ERC721Full {
    struct Missile {
        string area;
    }

    Missile[] public missiles;

    mapping(uint256 => address) public missleToOwner;
    mapping(address => uint256) ownerMissleCount;
    mapping(address => uint256) totalEarn;
    /*
    function _createMissile(uint256 _id, string memory _area) internal {
        uint256 id = missiles.push(Missile(_area)) - 1;
        missleToOwner[id] = msg.sender;
        ownerMissleCount[id]++;
    }
    */
}
