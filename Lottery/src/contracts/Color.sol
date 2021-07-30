pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

contract Color is ERC721Full {
    string[] public colors;
    mapping(string => bool) _colorExists;

    //'Color' - name of contract, 'COLOR'- symbol
    constructor() public ERC721Full("Color", "COLOR") {}

    // E.G. color = "#FFFFFF"
    //creates new token
    //should be strickted only to admin
    function mint(string memory _color) public {
        require(!_colorExists[_color]); //require the input to be true
        //'.push' return the array index
        uint256 _id = colors.push(_color);
        //implimented by openzeppelin
        _mint(msg.sender, _id);
        _colorExists[_color] = true;
    }
}
