    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {EuropeNft} from "src/EuropeNft.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract DeployEuropeNft is Script {
    function run() external returns (EuropeNft) {
        string memory kievSvg = vm.readFile("./img/kiev.svg");
        string memory londonSvg = vm.readFile("./img/london.svg");

        vm.startBroadcast();
        EuropeNft europeNft = new EuropeNft(
            svgToImageURI(kievSvg),
            svgToImageURI(londonSvg)
            );
        vm.stopBroadcast();
        return europeNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        // example:
        // '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
        // would return ""
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
