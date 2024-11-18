# NFT Smart Contract

## Overview

This smart contract is an ERC721A-based NFT contract designed for the creation and management of `.rave` NFTs. It includes features for minting, batch minting, setting royalties, and managing token metadata.
The contract is built with access control to ensure secure operations.

## Features

- **Minting**: Supports both public and reserved minting of NFTs.
- **Batch Minting**: Allows batch minting of up to 10 NFTs at a time.
- **Access Control**: Utilizes roles (`ADMIN_ROLE`, `SUPPORT_ROLE`) for secure management.
- **Royalty Management**: Supports setting default and per-token royalties.
- **Metadata Management**: Allows updating of base URI, contract URI, and individual token URIs.
- **Funds Management**: Enables withdrawal of contract funds to a specified treasury address.
- **Token Burning**: Supports burning of tokens with royalty reset.

## Contract Roles

- **ADMIN_ROLE**: Full administrative privileges, including minting, setting prices, and managing royalties.
- **SUPPORT_ROLE**: Limited privileges, primarily for updating URIs.

## Deployment

1. **Prerequisites**: Ensure you have a compatible EVM development environment set up (e.g., Hardhat).

## Usage

### Minting

- **Public Minting**: Users can mint a single NFT by sending the required `mintPrice` in Ether.
- **Batch Minting**: Users can mint multiple NFTs (up to 10) by sending the required Ether (`mintPrice * quantity`).

### Administrative Functions

- **Set Mint Price**: Adjust the price for minting NFTs.
- **Set Treasury Address**: Update the address where funds will be withdrawn.
- **Set Base URI**: Update the base URI for token metadata.
- **Set Contract URI**: Update the contract-level metadata URI.
- **Withdraw Funds**: Transfer the contract's Ether balance to the treasury address.
- **Set Default Royalty**: Define a default royalty for all tokens.
- **Modify Token Royalty**: Set a specific royalty for an individual token.

### Security

- Ensure only authorized addresses have `ADMIN_ROLE` or `SUPPORT_ROLE` to prevent unauthorized access.
- Regularly audit the contract and its interactions to maintain security.

## Contact

For any inquiries or support, please contact the development team at [info@zkxp.xyz](mailto:info@zkxp.xyz).

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
