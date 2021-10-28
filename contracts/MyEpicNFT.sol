// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 maxMintedNFTs = 50;

    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] colors = [
        "#cc0033",
        "#98c5e9",
        "#d3171e",
        "#0a4595",
        "#a40047",
        "#1a2b4c",
        "#00519e",
        "#272727",
        "#d20222",
        "#eb1a47",
        "#c9282d",
        "#a71d36",
        "#0f204b",
        "#ff0000",
        "#0099dd",
        "#202124",
        "#c5031b",
        "#f45b1a",
        "#bc0505",
        "#fd0000",
        "#005FAB",
        "#011F68",
        "#011F68",
        "#011F68",
        "#011F68",
        "#c00001",
        "#cc0000",
        "#60B8E2",
        "#005039",
        "#3375B3"
    ];

    string[] clubs = [
        "FC Bayern Munchen",
        "Manchester City FC",
        "Liverpool FC",
        "Chelsea FC",
        "FC Barcelona",
        "Paris Saint-Germain",
        "Real Madrid CF",
        "Juventus",
        "Manchester United",
        "Club Atletico de Madrid",
        "Sevilla FC",
        "AS Roma",
        "Tottenham Hotspur",
        "Arsenal FC",
        "FC Porto",
        "Borussia Dortmund",
        "AFC Ajax",
        "FC Shakhtar Donetsk",
        "RB Leipzig",
        "FC Salzburg",
        "Villarreal CF",
        "Olympique Lyonnais",
        "SSC Napoli",
        "Atalanta BC",
        "FC Internazionale Milano",
        "SL Benfica",
        "FC Basel 1893",
        "SS Lazio",
        "Sporting Clube de Portugal",
        "FC Zenit"
    ];

    event NewEpicNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 totalNFTsMintedSoFar
    );

    constructor() ERC721("ClubsNFT", "CLUBS") {}

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomClub(uint256 tokenId)
        public
        view
        returns (string memory club, string memory color)
    {
        uint256 rand = random(
            string(abi.encodePacked("RANDOM_WORD", Strings.toString(tokenId)))
        );

        rand = rand % clubs.length;
        return (clubs[rand], colors[rand]);
    }

    function getNFTsStats() public view returns (uint256 current, uint256 max) {
        return (_tokenIds.current(), maxMintedNFTs);
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        require(newItemId < maxMintedNFTs);

        (string memory club, string memory color) = pickRandomClub(newItemId);

        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                color,
                svgPartTwo,
                club,
                "</text></svg>"
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        club,
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

        emit NewEpicNFTMinted(msg.sender, newItemId, _tokenIds.current());

        console.log(
            "An NFT w/ ID %s has been minted to %s. Total minted: %s",
            newItemId,
            msg.sender,
            _tokenIds.current()
        );
    }
}
