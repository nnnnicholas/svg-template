// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Base64} from "base64-sol/base64.sol"; // Facilitates encoding SVG as base64
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract SVGDelegate {
    using Strings for uint256; // This lets you invoke the Strings library on uints. Useful for converting uints to strings for display in SVGs. 
    
    // Note: this function is marked `pure` because it does not mutate chain state. The ERC721 standard uses `view` instead (source: https://eips.ethereum.org/EIPS/eip-721).
    function tokenUri(uint256 tokenId) external pure returns (string memory) {
        uint256 id = tokenId;
        string[] memory parts = new string[](4);
        parts[0] = string("data:application/json;base64,");
        parts[1] = string(
            abi.encodePacked(
                '{"name":"XYZ",',
                '"description":"Description Text",',
                '"image":"data:image/svg+xml;base64,'
            )
        );
        parts[2] = Base64.encode(
            abi.encodePacked(
                '<svg width="1000" height="1000" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">'
                ,'<rect width="1000" height="1000" fill="beige"/>'
                ,'<circle r="50" cx="450" cy="450" fill="blue" />'
                ,'<text x="40" y="35" font-size="28px">'
                ,'token ID ', id.toString()
                ,'</text>'
                ,'</svg>'
            )
        );
        parts[3] = string('"}');

        string memory uri = string.concat(
            parts[0],
            Base64.encode(abi.encodePacked(parts[1], parts[2], parts[3]))
        );
        
        return uri;
    }
}
