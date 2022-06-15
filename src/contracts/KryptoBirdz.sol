// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC721Connector.sol";

contract KryptoBirdz is ERC721Connector {
    constructor() ERC721Connector("KryptoBird", "KBIRDZ") {}
}
