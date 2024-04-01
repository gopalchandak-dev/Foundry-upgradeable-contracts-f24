// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployBox;
    UpgradeBox public upgradeBox;
    address public OWNER = address(1);

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
    }

    function testBoxWorks() public {
        address proxyAddress = deployBox.deployBox();
        uint256 expectedValue = 1;
        assertEq(expectedValue, BoxV1(proxyAddress).version());
    }

    /* function testDeploymentIsv1() public {
        address proxyAddress = deployBox.deployBox();
        uint256 expectedValue = 7;
        vm.expectRevert();
        BoxV2(proxyAddress).setValue(expectedValue); ----> For this cheatsheet is to used...
    } */

    function testUpgradeWorks() public {
        address proxyAddress = deployBox.deployBox();

        BoxV2 box2 = new BoxV2();
        vm.prank(BoxV1(proxyAddress).owner());
        BoxV1(proxyAddress).transferOwnership(msg.sender);

        address proxy = upgradeBox.upgradeBox(proxyAddress, address(box2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        /* BoxV2(proxy).setValue(expectedValue);
            assertEq(expectedB+Value, BoxV2(proxy).getValue()); //---> For this cheatsheet is to be used
        */
    }
}
