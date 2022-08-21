// SPDX-License_Identifier: minutes
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTContract is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private supply;

    string public uriPrefix = "";
    string public uriSuffix = ".json";
    string public hiddenMetadataUri;

    uint256 public cost = 0.01;
    uint256 public maxSupply = 100;
    uint256 public maxMintAmountPerTx = 5;

    bool public paused = true; //contract is paused


    constructor() ERC721("NFT Collection Name","NCN"){
        setHiddenMetadataUri("ipfs://__CID__/hiddenMetadata.json");
    }
}

modifier mintCompliance(uint256 _mintAmount){
    require(
        //TODO mint compliance
    )
}

function setUriPrefix(string memory _uriPrefix) public onlyOwner{
    uriPrefix = _uriPrefix;
}

function setUriSuffix(string memory _uriSuffix) public onlyOwner{
    uriSuffix = _uriSuffix;
}
function setHiddenMetadataUri(string memory _setHiddenMetadataUri) public onlyOwner{
    hiddenMetadataUri = _hiddenMetadataUri;
}

function setCost(uint256 _cost) public onlyOwner{
    cost = _cost;
}

function setMaxSupply(uint256 _maxSupply) public onlyOwner{
    maxSupply = _maxSupply;
}

function setMaxMintAmountPerTx( uint256 _maxMintAmountPerTx) public onlyOwner{
    maxMintAmountPerTx =_maxMintAmountPerTx;
}

function setPaused(bool _state) public onlyOwner{
    paused = _paused
}


function totalSupply() public view returns (uint256){
    return supply.current();
}

function _baseURI() internal view virtual override returns (string memory){
    return uriPrefix;
}

function tokenURI(uint256 _tokenId) public view vritual override returns (string memory){
    require(_exists(_tokenId),
    "ERC721Metadata: URI query for nonexistent token"
    );
    string memory currentBaseURI = _baseURI();
    return
        bytes(currentBaseURI).length > 0 && string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix));
}

function mintCompliance(uint256 _mintAmount){
    require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalind mint amount!");
    require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
    _;
}

function _mintLoop(address _receiver, uint256 _mintAmount) internal{
    for( uint256 i=0; i < _mintAmount; i++){
        supply.increment();
        _safeMint(_receiver, supply.current()); //we call function from openzeppelin, with receiver's address and current supply
    }
}

function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount){
    require(!paused, "The contract is paused!");
    require(msg.value >= cost * _mintAmount, "Insufficient funds!");

    _mintLoop(msg.sender, _mintAmount);
}

function withdraw() public onlyOwner{
    // This will transfer the remaining contract balance to the owner
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
}