// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract EuropeNft is ERC721 {
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error EuropeNft__CantFlipMoodIfNotOwner();

    enum NFTState {
        LONDON,
        KIEV
    }

    uint256 private s_tokenCounter;
    string private s_kievSvgUri;
    string private s_londonSvgUri;

    mapping(uint256 => NFTState) private s_tokenIdToState;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(string memory kievSvgUri, string memory londonSvgUri) ERC721("EuropeNft", "EU") {
        s_tokenCounter = 0;
        s_kievSvgUri = kievSvgUri;
        s_londonSvgUri = londonSvgUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedNFT(s_tokenCounter);
    }

    function changeCity(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert EuropeNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == NFTState.LONDON) {
            s_tokenIdToState[tokenId] = NFTState.KIEV;
        } else {
            s_tokenIdToState[tokenId] = NFTState.LONDON;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        string memory imageURI = s_londonSvgUri;

        if (s_tokenIdToState[tokenId] == NFTState.KIEV) {
            imageURI = s_kievSvgUri;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An NFT that reflects the city where owner currently lives:)", ',
                            '"attributes": [{"type": "city", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
