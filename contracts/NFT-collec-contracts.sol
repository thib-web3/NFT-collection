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

    bool public paused = true;


    constructor() ERC721("NFT Collection Name","NCN"){
        setHiddenMetadataUri("ipfs://__CID__/hiddenMetadata.json");
    }
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