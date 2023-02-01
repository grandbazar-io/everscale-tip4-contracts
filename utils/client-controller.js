const { Account } = require("@tonclient/appkit");
const { signerNone, abiContract, signerKeys } = require("@tonclient/core");

const {
  SafeMultisigWalletContract,
} = require("../contracts-add/multisig/SafeMultisigWalletContract");
const { IndexContract } = require("../compiled/IndexContract");
const giverKeys = require("../keys/giverv2.local.keys.json");
const { config } = require("./config");

class ClientController {
  constructor({ client, nftRoot }) {
    this.client = client;
    this.nftRoot = nftRoot;
    this.giver = new Account(config.contracts.GiverV2Contract, {
      address:
        "0:b5e9240fc2d2f1ff8cbb1d1dee7fb7cae155e5f6320e585fcc685698994a19a5",
      signer: signerKeys(giverKeys),
      client,
    });
  }

  async deployRootContract({ initInput, account, name, useGiver }) {
    const { acc_type } = await account.getAccount();
    if (acc_type !== 1) {
      await account.deploy({
        initFunctionName: "constructor",
        initInput,
        useGiver,
      });
    }

    const address = await account.getAddress();

    console.log(`${name || ""} was deployed at address ${address}`);

    return address;
  }

  async deployMultisig({ signer, signerPublic }) {
    const multisig = new Account(SafeMultisigWalletContract, {
      signer,
      client: this.client,
    });

    const { acc_type } = await multisig.getAccount();

    if (acc_type !== 1) {
      await multisig.deploy({
        initInput: {
          owners: [signerPublic],
          reqConfirms: 0,
        },
        useGiver: true,
      });
    }

    const multisigAddress = await multisig.getAddress();
    console.log(`Multisig address: ${multisigAddress}`);

    return multisig;
  }

  // TODO: change to TIP-4
  async getMyNfts({ rootAcc, addrOwner }) {
    const { codeHashIndex } = (
      await rootAcc.runLocal("resolveCodeHashIndex", {
        addrRoot: await rootAcc.getAddress(),
        addrOwner,
      })
    ).decoded.output;

    let nfts = [];
    let counter = 0;

    while (nfts.length === 0 && counter <= 10) {
      const qwe = await this.client.net.query_collection({
        collection: "accounts",
        filter: {
          code_hash: { eq: codeHashIndex.slice(2) },
        },
        result: "id",
      });
      counter++;
      nfts = qwe.result;
    }

    const promises = nfts.map((el) => {
      const nftIndex = new Account(IndexContract, {
        client: this.client,
        address: el.id,
        signer: signerNone(),
      });

      return nftIndex.runLocal("getInfo");
    });

    return Promise.all(promises);
  }

  async sendTransactionWithPayload({
    abi,
    function_name,
    input,
    multisigAcc,
    dest,
    value,
  }) {
    const transferOwnershipPayload = (
      await this.client.abi.encode_message_body({
        abi: abiContract(abi),
        call_set: {
          function_name: function_name,
          input: input || {},
        },
        is_internal: true,
        signer: multisigAcc.signer,
      })
    ).body;

    await multisigAcc.run("sendTransaction", {
      dest,
      value,
      bounce: true,
      flags: 1,
      payload: transferOwnershipPayload,
    });
  }

  async waitForEvent({ src, notIn }) {
    return (
      await this.client.net.wait_for_collection({
        collection: "messages",
        filter: {
          src: { in: src },
          msg_type: { eq: 2 },
          id: {
            notIn,
          },
        },
        result: "boc id src",
      })
    ).result;
  }

  async checkAccountStatus(address) {
    return (
      await this.client.net.query_collection({
        collection: "accounts",
        filter: {
          id: { eq: address },
        },
        result: "acc_type",
      })
    ).result[0];
  }

  sleep(ms) {
    return new Promise((resolve) => {
      setTimeout(resolve, ms);
    });
  }
}

module.exports = { ClientController };
