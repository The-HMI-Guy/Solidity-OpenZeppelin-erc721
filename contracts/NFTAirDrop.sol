// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

contract NFTAirdrop {
  struct Airdrop {
    address nft;
    uint id;
  }
  // Used in the airdrops mapping.
  uint public nextAirdropId;
  // Restrict to the deployer on the functions listed below.
  address public admin;

  
  mapping(uint => Airdrop) public airdrops;
  // Address = recipient. Bool = approved or not. 
  mapping(address => bool) public recipients;
721
  constructor() {
    // Deployer
    admin = msg.sender;
  }

  function addAirdrops(Airdrop[] memory _airdrops) external {
    // X check if caller is the only, if not, revert back.
    require(msg.sender == admin, 'only admin');
    uint _nextAirdropId = nextAirdropId;
    for(uint i = 0; i < _airdrops.length; i++) {
      airdrops[_nextAirdropId] = _airdrops[i];
      IERC721(_airdrops[i].nft).transferFrom(
        msg.sender, 
        address(this), 
        _airdrops[i].id
      );
      _nextAirdropId++;
    }
  }

  function addRecipients(address[] memory _recipients) external {
    // X check if caller is the only, if not, revert back.
    require(msg.sender == admin, 'only admin');
    for(uint i = 0; i < _recipients.length; i++) {
      recipients[_recipients[i]] = true;
    }
  }

  function removeRecipients(address[] memory _recipients) external {
    // X check if caller is the only, if not, revert back.
    require(msg.sender == admin, 'only admin');
    for(uint i = 0; i < _recipients.length; i++) {
      recipients[_recipients[i]] = false;
    }
  }

  function claim() external {
    // X check if caller is approved to claim an airdrop.
    require(recipients[msg.sender] == true, 'recipient not registered');
    recipients[msg.sender] = false;
    Airdrop storage airdrop = airdrops[nextAirdropId];
    IERC721(airdrop.nft).transferFrom(address(this), msg.sender, airdrop.id);
    nextAirdropId++;
  }
}