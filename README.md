# everscale-tip4-contracts

## Interfaces
The NFT contract must implement the interface that it uses. 
All function identifiers of such interfaces must be stored in the contract according to 
[TIP-6 standart](https://docs.nftalliance.org/standard/TIP-6.1 "TIP-6")

### IRoyalty
Royalty is ```mapping(address => uint8)``` where ```uint8``` is a number with zero decimal places.
