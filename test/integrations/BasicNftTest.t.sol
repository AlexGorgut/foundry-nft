// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {StdCheats} from "lib/forge-std/src/StdCheats.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {Script, console} from "lib/forge-std/src/Script.sol";

contract BasicNftTest is StdCheats, Test, Script {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address USER = makeAddr("user");
    string public constant LDN = "https://ipfs.io/ipfs/QmYJbC7uC4141Xyw7eGUKpHjFMAg6emPN8Trjtx8vDKfWB?filename=LDN.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "London";
        string memory actualName = basicNft.name();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(LDN);

        console.log("hui1");

        assert(basicNft.balanceOf(USER) == 1);

        console.log("hui");

        assert(keccak256(abi.encodePacked(LDN)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
