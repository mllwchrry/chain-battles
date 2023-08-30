// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// 0xA87FCAef206e2d039c6Ca985E735eCc09f7BDaDc
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct characteristics {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    mapping (uint256 => characteristics) public tokenIdToCharacteristics;

    constructor() ERC721 ("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="#245236" />',
            '<text x="50%" y="25%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '</svg>'
        );

        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        return tokenIdToCharacteristics[tokenId].level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        return tokenIdToCharacteristics[tokenId].speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        return tokenIdToCharacteristics[tokenId].strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        return tokenIdToCharacteristics[tokenId].life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToCharacteristics[newItemId].level = 0;
        tokenIdToCharacteristics[newItemId].speed = randomNumber(100);
        tokenIdToCharacteristics[newItemId].strength = randomNumber(50);
        tokenIdToCharacteristics[newItemId].life = randomNumber(9);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "This token doesn't exist");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
        tokenIdToCharacteristics[tokenId].level += 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function randomNumber(uint number) public view returns(uint){
        return uint(blockhash(block.number-1)) % number;
    }
}