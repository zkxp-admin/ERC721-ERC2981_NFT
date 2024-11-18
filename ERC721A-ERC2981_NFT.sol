// SPDX-License-Identifier: MIT
// Developed by ZKXP Innovation // Contact: info@zkxp.xyz
pragma solidity ^0.8.24;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DotRAVE is ERC721A, ERC2981, AccessControl, Ownable {
    uint96 public constant MAX_SUPPLY = 8888;
    bytes32 public constant SUPPORT_ROLE = keccak256("SUPPORT_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    string private _baseURIExtended;
    string private _contractURI;
    mapping(uint256 => string) private _tokenURIs;

    uint256 public mintPrice;
    address public treasuryAddress;

    constructor(address initialOwner, address initialTreasury) ERC721A(".rave", "RAVE") Ownable(initialOwner) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialOwner);
        _grantRole(ADMIN_ROLE, initialOwner);
        treasuryAddress = initialTreasury;
        mintPrice = 0.01 ether; 
    }

    // Set mint price
    function setMintPrice(uint256 newPrice) external onlyRole(ADMIN_ROLE) {
        mintPrice = newPrice;
    }

    // Set treasury address
    function setTreasuryAddress(address newTreasury) external onlyRole(ADMIN_ROLE) {
        treasuryAddress = newTreasury;
    }

    // Reserve mint
    function reserveMint(address to, uint256 quantity, string[] memory uris) external onlyRole(ADMIN_ROLE) {
        require(quantity > 0 && quantity <= 10, "Quantity must be between 1 and 10");
        require(quantity == uris.length, "URI count must match quantity");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds max supply");

        uint256 startTokenId = _nextTokenId();
        _safeMint(to, quantity);

        for (uint256 i = 0; i < quantity; i++) {
            _tokenURIs[startTokenId + i] = uris[i];
        }
    }

    // Public minting
    function publicMint(string memory uri) external payable {
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");
        require(msg.value >= mintPrice, "Insufficient payment");

        uint256 tokenId = _nextTokenId();
        _safeMint(msg.sender, 1);
        _tokenURIs[tokenId] = uri;
    }

    // Public batch minting
    function publicBatchMint(uint256 quantity, string[] memory uris) external payable {
        require(quantity > 0 && quantity <= 10, "Quantity must be between 1 and 10");
        require(quantity == uris.length, "URI count must match quantity");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= mintPrice * quantity, "Insufficient payment");

        uint256 startTokenId = _nextTokenId();
        _safeMint(msg.sender, quantity);

        for (uint256 i = 0; i < quantity; i++) {
            _tokenURIs[startTokenId + i] = uris[i];
        }
    }

    // Withdraw funds
    function withdrawFunds() external onlyRole(ADMIN_ROLE) {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool sent, ) = payable(treasuryAddress).call{value: balance}("");
        require(sent, "Failed to send Ether");
    }

    // Set base URI
    function setBaseURI(string memory baseURI_) external {
        require(hasRole(ADMIN_ROLE, msg.sender) || hasRole(SUPPORT_ROLE, msg.sender), "Caller is not admin or support");
        _baseURIExtended = baseURI_;
    }

    // Set contract URI
    function setContractURI(string memory newURI) external {
        require(hasRole(ADMIN_ROLE, msg.sender) || hasRole(SUPPORT_ROLE, msg.sender), "Caller is not admin or support");
        _contractURI = newURI;
    }

    // Get contract URI
    function contractURI() external view returns (string memory) {
        return _contractURI;
    }

    // Get token URI
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory base = _baseURI();
        return bytes(base).length > 0 ? string(abi.encodePacked(base, _tokenURIs[tokenId])) : _tokenURIs[tokenId];
    }

    // Update token URI
    function updateTokenURI(uint256 tokenId, string memory uri) external {
        require(hasRole(ADMIN_ROLE, msg.sender) || hasRole(SUPPORT_ROLE, msg.sender), "Caller is not admin or support");
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    // Burn token
    function burn(uint256 tokenId) external {
        _burn(tokenId, true);
        _resetTokenRoyalty(tokenId);
    }

    // Set default royalty
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyRole(ADMIN_ROLE) {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    // Modify token royalty
    function modifyTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external onlyRole(ADMIN_ROLE) {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    // Get base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIExtended;
    }

    // Interface support
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721A, ERC2981, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}