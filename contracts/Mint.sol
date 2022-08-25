// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Mint is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";

  uint256 public cost = 0.0099 ether;
  uint256 public itemSize = 3333;
  uint256 public maxMintPerPerson = 5;
  bool public paused = false;

  uint256 public freeMintItemSize = 1000;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintPerPerson, "max mint amount per session exceeded");
    require(supply + _mintAmount <= itemSize, "max NFT limit exceeded");

    uint256 paidMintItmes = 0;
    if (supply + _mintAmount > freeMintItemSize) paidMintItmes = supply + _mintAmount - freeMintItemSize;

    if (msg.sender != owner()) {
      uint256 ownerMintedCount = balanceOf(msg.sender);
      require(ownerMintedCount + _mintAmount <= maxMintPerPerson, "max NFT per address exceeded");
      require(msg.value >= cost * paidMintItmes, "insufficient funds");
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
    maxMintPerPerson = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintPerPerson = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  
}