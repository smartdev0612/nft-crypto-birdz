// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

contract ERC721 is ERC165, IERC721 {
    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "owner query for non-existent token");
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "owner query for non-existent token");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        // return truthness the address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't zero
        require(to != address(0), "ERC721: minting to the zero address!");
        // requires that the token doesn't already exist
        require(!_exists(tokenId), "ERC721: token already minted!");
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "Error - Transfer to the zero address");
        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token the address does not own!"
        );
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(owner != _to, "Error - approval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of the token"
        );
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return _tokenApprovals[tokenId];
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(tokenId), "token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender);
    }
}
