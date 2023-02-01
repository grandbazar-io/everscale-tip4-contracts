const {
  CollectionSampleContract,
} = require("../samples/compiled/CollectionSampleContract");
const {
  CollectionBulkContract,
} = require("../compiled/CollectionBulkContract");
const {
  CollectionsFactoryContract,
} = require("../compiled/CollectionsFactoryContract");
const { NftContract } = require("../compiled/NftContract");
const { NftBulkContract } = require("../compiled/NftBulkContract");
const { IndexContract } = require("../compiled/IndexContract");
const { IndexBasisContract } = require("../compiled/IndexBasisContract");
const {
  SafeMultisigWalletContract,
} = require("../contracts-add/multisig/SafeMultisigWalletContract");
const { GiverV2Contract } = require("../contracts-add/giver/GiverV2Contract");
const { GiverV3Contract } = require("../contracts-add/giver/GiverV3Contract");
const {
  SetcodeMultisigWalletEverspaceContract,
} = require("../contracts-add/multisig/setcodeeverspace/compiled/SetcodeMultisigWalletEverspaceContract");

const config = {
  endpoint: process.env.TON_NETWORK ?? "http://localhost",
  isLocal:
    !process.env.TON_NETWORK ||
    process.env.TON_NETWORK == "http://localhost" ||
    process.env.TON_NETWORK == "http://127.0.0.1",
  contracts: {
    CollectionsFactoryContract,
    CollectionSampleContract,
    CollectionBulkContract,
    NftContract,
    NftBulkContract,
    IndexContract,
    IndexBasisContract,
    SafeMultisigWalletContract,
    SetcodeMultisigWalletEverspaceContract,
    GiverV2Contract,
    GiverV3Contract,
  },
  zeroAddress:
    "0:0000000000000000000000000000000000000000000000000000000000000000",
};

module.exports = { config };
