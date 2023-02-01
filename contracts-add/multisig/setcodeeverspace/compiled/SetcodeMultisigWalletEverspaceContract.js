const SetcodeMultisigWalletEverspaceContract = {
    abi: {
        "ABI version": 2,
        "header": [
            "pubkey",
            "time",
            "expire"
        ],
        "functions": [
            {
                "name": "constructor",
                "inputs": [
                    {
                        "name": "owners",
                        "type": "uint256[]"
                    },
                    {
                        "name": "reqConfirms",
                        "type": "uint8"
                    }
                ],
                "outputs": []
            },
            {
                "name": "acceptTransfer",
                "inputs": [
                    {
                        "name": "payload",
                        "type": "bytes"
                    }
                ],
                "outputs": []
            },
            {
                "name": "sendTransaction",
                "inputs": [
                    {
                        "name": "dest",
                        "type": "address"
                    },
                    {
                        "name": "value",
                        "type": "uint128"
                    },
                    {
                        "name": "bounce",
                        "type": "bool"
                    },
                    {
                        "name": "flags",
                        "type": "uint8"
                    },
                    {
                        "name": "payload",
                        "type": "cell"
                    }
                ],
                "outputs": []
            },
            {
                "name": "submitTransaction",
                "inputs": [
                    {
                        "name": "dest",
                        "type": "address"
                    },
                    {
                        "name": "value",
                        "type": "uint128"
                    },
                    {
                        "name": "bounce",
                        "type": "bool"
                    },
                    {
                        "name": "allBalance",
                        "type": "bool"
                    },
                    {
                        "name": "payload",
                        "type": "cell"
                    }
                ],
                "outputs": [
                    {
                        "name": "transId",
                        "type": "uint64"
                    }
                ]
            },
            {
                "name": "confirmTransaction",
                "inputs": [
                    {
                        "name": "transactionId",
                        "type": "uint64"
                    }
                ],
                "outputs": []
            },
            {
                "name": "isConfirmed",
                "inputs": [
                    {
                        "name": "mask",
                        "type": "uint32"
                    },
                    {
                        "name": "index",
                        "type": "uint8"
                    }
                ],
                "outputs": [
                    {
                        "name": "confirmed",
                        "type": "bool"
                    }
                ]
            },
            {
                "name": "getParameters",
                "inputs": [],
                "outputs": [
                    {
                        "name": "maxQueuedTransactions",
                        "type": "uint8"
                    },
                    {
                        "name": "maxCustodianCount",
                        "type": "uint8"
                    },
                    {
                        "name": "expirationTime",
                        "type": "uint64"
                    },
                    {
                        "name": "minValue",
                        "type": "uint128"
                    },
                    {
                        "name": "requiredTxnConfirms",
                        "type": "uint8"
                    },
                    {
                        "name": "requiredUpdConfirms",
                        "type": "uint8"
                    }
                ]
            },
            {
                "name": "getTransaction",
                "inputs": [
                    {
                        "name": "transactionId",
                        "type": "uint64"
                    }
                ],
                "outputs": [
                    {
                        "components": [
                            {
                                "name": "id",
                                "type": "uint64"
                            },
                            {
                                "name": "confirmationsMask",
                                "type": "uint32"
                            },
                            {
                                "name": "signsRequired",
                                "type": "uint8"
                            },
                            {
                                "name": "signsReceived",
                                "type": "uint8"
                            },
                            {
                                "name": "creator",
                                "type": "uint256"
                            },
                            {
                                "name": "index",
                                "type": "uint8"
                            },
                            {
                                "name": "dest",
                                "type": "address"
                            },
                            {
                                "name": "value",
                                "type": "uint128"
                            },
                            {
                                "name": "sendFlags",
                                "type": "uint16"
                            },
                            {
                                "name": "payload",
                                "type": "cell"
                            },
                            {
                                "name": "bounce",
                                "type": "bool"
                            }
                        ],
                        "name": "trans",
                        "type": "tuple"
                    }
                ]
            },
            {
                "name": "getTransactions",
                "inputs": [],
                "outputs": [
                    {
                        "components": [
                            {
                                "name": "id",
                                "type": "uint64"
                            },
                            {
                                "name": "confirmationsMask",
                                "type": "uint32"
                            },
                            {
                                "name": "signsRequired",
                                "type": "uint8"
                            },
                            {
                                "name": "signsReceived",
                                "type": "uint8"
                            },
                            {
                                "name": "creator",
                                "type": "uint256"
                            },
                            {
                                "name": "index",
                                "type": "uint8"
                            },
                            {
                                "name": "dest",
                                "type": "address"
                            },
                            {
                                "name": "value",
                                "type": "uint128"
                            },
                            {
                                "name": "sendFlags",
                                "type": "uint16"
                            },
                            {
                                "name": "payload",
                                "type": "cell"
                            },
                            {
                                "name": "bounce",
                                "type": "bool"
                            }
                        ],
                        "name": "transactions",
                        "type": "tuple[]"
                    }
                ]
            },
            {
                "name": "getTransactionIds",
                "inputs": [],
                "outputs": [
                    {
                        "name": "ids",
                        "type": "uint64[]"
                    }
                ]
            },
            {
                "name": "getCustodians",
                "inputs": [],
                "outputs": [
                    {
                        "components": [
                            {
                                "name": "index",
                                "type": "uint8"
                            },
                            {
                                "name": "pubkey",
                                "type": "uint256"
                            }
                        ],
                        "name": "custodians",
                        "type": "tuple[]"
                    }
                ]
            },
            {
                "name": "submitUpdate",
                "inputs": [
                    {
                        "name": "codeHash",
                        "type": "uint256"
                    },
                    {
                        "name": "owners",
                        "type": "uint256[]"
                    },
                    {
                        "name": "reqConfirms",
                        "type": "uint8"
                    }
                ],
                "outputs": [
                    {
                        "name": "updateId",
                        "type": "uint64"
                    }
                ]
            },
            {
                "name": "confirmUpdate",
                "inputs": [
                    {
                        "name": "updateId",
                        "type": "uint64"
                    }
                ],
                "outputs": []
            },
            {
                "name": "executeUpdate",
                "inputs": [
                    {
                        "name": "updateId",
                        "type": "uint64"
                    },
                    {
                        "name": "code",
                        "type": "cell"
                    }
                ],
                "outputs": []
            },
            {
                "name": "getUpdateRequests",
                "inputs": [],
                "outputs": [
                    {
                        "components": [
                            {
                                "name": "id",
                                "type": "uint64"
                            },
                            {
                                "name": "index",
                                "type": "uint8"
                            },
                            {
                                "name": "signs",
                                "type": "uint8"
                            },
                            {
                                "name": "confirmationsMask",
                                "type": "uint32"
                            },
                            {
                                "name": "creator",
                                "type": "uint256"
                            },
                            {
                                "name": "codeHash",
                                "type": "uint256"
                            },
                            {
                                "name": "custodians",
                                "type": "uint256[]"
                            },
                            {
                                "name": "reqConfirms",
                                "type": "uint8"
                            }
                        ],
                        "name": "updates",
                        "type": "tuple[]"
                    }
                ]
            }
        ],
        "data": [],
        "events": [
            {
                "name": "TransferAccepted",
                "inputs": [
                    {
                        "name": "payload",
                        "type": "bytes"
                    }
                ],
                "outputs": []
            }
        ]
    },
    tvc: "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",
    code: "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",
    codeHash: "ccb7bf85cf9cfa41aa9c4ac55d32245efce510b6a634b34259a7315e83a54680",
};
module.exports = { SetcodeMultisigWalletEverspaceContract };