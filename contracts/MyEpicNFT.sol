// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Cristiano",
        "Lionel",
        "Robert",
        "Kevin",
        "Killian",
        "Erling"
    ];
    string[] secondWords = [
        "the Champ",
        "the King",
        "the Best",
        "the Golden Boot",
        "the Golden Boy",
        "the Finisher"
    ];
    string[] thirdWords = [
        "Ronaldo",
        "Messi",
        "Lewandowski",
        "De Bruyne",
        "Mbappe",
        "Haaland"
    ];

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("WAGMI!");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomWord(uint256 tokenId, uint256 collectionNum)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "RANDOM_WORD",
                    Strings.toString(collectionNum),
                    Strings.toString(tokenId)
                )
            )
        );

        string[] memory collection = (
            collectionNum == 1 ? firstWords : collectionNum == 2
                ? secondWords
                : thirdWords
        );

        rand = rand % collection.length;
        return collection[rand];
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomWord(newItemId, 1);
        string memory second = pickRandomWord(newItemId, 2);
        string memory third = pickRandomWord(newItemId, 3);
        string memory combinedWord = string(
            abi.encodePacked(first, " ", second, " ", third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "He shoot, he sprint, but most importantly, he score", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
    }
}
