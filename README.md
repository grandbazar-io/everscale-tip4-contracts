# everscale-tip4-contracts

Customizable grandbazar.io NFT contracts. Based on [Itgold](https://github.com/itgoldio/everscale-tip) standard. You can customize all contracts by extending them.

# What is needed for development?

- Install [Everdev](https://github.com/tonlabs/everdev)
- Install [Locklift](https://github.com/broxus/locklift)

# Installation 

```npm i @grandbazar-io/everscale-tip4-contracts```

# Build project

1. Copy ```locklift.config.template.ts``` into ```config.template.ts``` and configure it 
2. Run ```npx locklift build```

## Interfaces
The NFT contract must implement the interface that it uses. 
All function identifiers of such interfaces must be stored in the contract according to 
[TIP-6 standart](https://docs.nftalliance.org/standard/TIP-6.1 "TIP-6")

### IRoyalty
Royalty is ```mapping(address => uint8)``` where ```uint8``` is a number with zero decimal places.
