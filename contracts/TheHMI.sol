// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TheHMI is ERC721, ERC721Enumerable, Pausable, Ownable {
    // ******* 1. Property Variables ******* //
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public MINT_PRICE = 0.05 ether;
    uint256 public MAX_SUPPLY = 100;

/*     address[] public WhitelistAddresses = [
        0x53aE57a6cf0C9Bcb53a8932C97cDaD0a57Ef391d //Manually setting the WL array
    ]; */

    // ******* 2. Lifecycle Methods ******* //
    constructor() ERC721("TheHMI", "TH") {
        // Start token ID at 1. By default it starts at 0.
        _tokenIdCounter.increment();
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Balance is zero.");
        payable(owner()).transfer(address(this).balance);
    }

    // ******* 3. Pauseable Functions ******* //

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // ******* 4. Minting Functions ******* //

    function safeMint(address to) public payable {
        // X check that totalSupply is less than MAX_SUPPLY
        require(totalSupply() < MAX_SUPPLY, "Can't mint anymore tokens.");

        // X check if ether value is correct
        require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // ******* 5. Other Functions ******* //

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmWBPophECw4QxtNkFZGXzevGVRKQ5LZXTnpyTXTnqXFRg/";
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

/* NOTES:
    contract address: 0xd9145CCE52D386f254917e481eB44e9943F39138
    
    // Users

    owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        - deployed contract
        - can only call the 'onlyOwner' modifier functions

    address 2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
        - mint 1 NFT
    
    address 3: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
        - address 2 will transfer NFT #1 to address 3 (recipient)





*/
