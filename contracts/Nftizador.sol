// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./Base64.sol";

contract Nftizador is ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;
    using Strings for uint256;


    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => string) public tokenIMG;
    constructor() ERC721("NFTizado","NFTr"){}

    function mint(string memory B64Image) public{
        uint256 current = _tokenIdCounter.current();
        _safeMint(msg.sender, current);
        tokenIMG[current] = B64Image; 
        _tokenIdCounter.increment();        
        console.log("current: ",current);
    }

    function tokenURI(uint256 tokenId, string memory B64Image)
        public
        view
        returns (string memory)
    {
        require(_exists(tokenId), "no existe el toquen, gege");
        string memory image = imageBy64(B64Image);
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{' 
                '"name": "PlatziPunks #', tokenId.toString(),'",'
                '"description": "NFT created by NFTizador por TAVI0",'
                '"image":"', image,'"'
                '}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    function imageBy64(string memory B64Image) public view returns (string memory) {
        return string(abi.encodePacked("data:image/png;base64,",B64Image));
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}