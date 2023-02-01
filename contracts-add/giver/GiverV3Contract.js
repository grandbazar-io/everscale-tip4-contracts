const GiverV3Contract = {
    abi: {
        "ABI version": 2,
        "version": "2.2",
        "header": [
            "time",
            "expire"
        ],
        "functions": [
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
                    }
                ],
                "outputs": []
            },
            {
                "name": "getMessages",
                "inputs": [],
                "outputs": [
                    {
                        "components": [
                            {
                                "name": "hash",
                                "type": "uint256"
                            },
                            {
                                "name": "expireAt",
                                "type": "uint64"
                            }
                        ],
                        "name": "messages",
                        "type": "tuple[]"
                    }
                ]
            },
            {
                "name": "upgrade",
                "inputs": [
                    {
                        "name": "newcode",
                        "type": "cell"
                    }
                ],
                "outputs": []
            },
            {
                "name": "constructor",
                "inputs": [],
                "outputs": []
            }
        ],
        "data": [],
        "events": [],
        "fields": [
            {
                "name": "_pubkey",
                "type": "uint256"
            },
            {
                "name": "_constructorFlag",
                "type": "bool"
            },
            {
                "name": "m_messages",
                "type": "map(uint256,uint64)"
            }
        ]
    },
    tvc: "te6ccgECGQEAAwIAAgE0AwEBAcACAEPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBCSK7VMg4wMgwP/jAiDA/uMC8gsVBgUEAAAC1u1E0NdJwwH4ZiHbPNMAAY4SgQIA1xgg+QFY+EIg+GX5EPKo3iP4RSBukjBw3vhCuvLgZSHTP9MfNDEg+CO88rkh+QAg+EqBAQD0Dm+hMfLQZvgAIPhKI8jLP1mBAQD0Q/hqXwPTHwHbPPI8DQcDSu1E0NdJwwH4ZiLQ1wsDqTgA3CHHAOMCIdcNH/K8IeMDAds88jwUFAcEUCCCEBcjDDq64wIgghAxXvk1uuMCIIIQaLVfP7rjAiCCEHdEx+K64wIQDgwIA3Qw+Eby4Ez4Qm7jANHbPCGOIiPQ0wH6QDAxyM+HIM6CEPdEx+LPC4EBbyICyx/0AMlw+wCRMOLjAPIAEwkYAUBwbW8C+EoggQEA9IaVIFjXCz+TbV8g4pMibrOOgOhfBAoBUlR0EG8C2zwBbyIhpFUggCD0Q28CNVMjgQEA9HyVIFjXCz+TbV8g4mwzCwAQbyIByMv/yz8CIjD4Qm7jAPhG8nPR+ADbPPIADRgBRO1E0NdJwgGOF3DtRND0BW34aoBA9A7yvdcL//hicPhj4w0TAz4w+Eby4Ez4Qm7jACGT1NHQ3vpA03/SANHbPDDbPPIAEw8YAMRUcSDIz4WAygDPhEDOAfoCgGvPQMlz+wBw+EoggQEA9IaVIFjXCz+TbV8g4pMibrOOLCTCHeMIJKQ1+CO7myD4SoEBAPRbMPhq3lMSgQEA9HyVIFjXCz+TbV8g4mwj4xhfCAMoMPhG8uBM+EJu4wDU0ds8MNs88gATERgCXPhFIG6SMHDe+EK68uBl+ADbPPgPIPsE0CCLOK2zWMcFk9dN0N7XTNDtHu1T2zwYEgAE8AIAHu1E0NP/0wAx9ATR+Gr4YgAK+Eby4EwCCvSkIPShFxYAFHNvbCAwLjU5LjQBFqAAAAAC2zz4D/IAGAAc+Er4QsjL/8+D9ADJ7VQ=",
    code: "te6ccgECFgEAAtUABCSK7VMg4wMgwP/jAiDA/uMC8gsSAwIBAAAC1u1E0NdJwwH4ZiHbPNMAAY4SgQIA1xgg+QFY+EIg+GX5EPKo3iP4RSBukjBw3vhCuvLgZSHTP9MfNDEg+CO88rkh+QAg+EqBAQD0Dm+hMfLQZvgAIPhKI8jLP1mBAQD0Q/hqXwPTHwHbPPI8CgQDSu1E0NdJwwH4ZiLQ1wsDqTgA3CHHAOMCIdcNH/K8IeMDAds88jwREQQEUCCCEBcjDDq64wIgghAxXvk1uuMCIIIQaLVfP7rjAiCCEHdEx+K64wINCwkFA3Qw+Eby4Ez4Qm7jANHbPCGOIiPQ0wH6QDAxyM+HIM6CEPdEx+LPC4EBbyICyx/0AMlw+wCRMOLjAPIAEAYVAUBwbW8C+EoggQEA9IaVIFjXCz+TbV8g4pMibrOOgOhfBAcBUlR0EG8C2zwBbyIhpFUggCD0Q28CNVMjgQEA9HyVIFjXCz+TbV8g4mwzCAAQbyIByMv/yz8CIjD4Qm7jAPhG8nPR+ADbPPIAChUBRO1E0NdJwgGOF3DtRND0BW34aoBA9A7yvdcL//hicPhj4w0QAz4w+Eby4Ez4Qm7jACGT1NHQ3vpA03/SANHbPDDbPPIAEAwVAMRUcSDIz4WAygDPhEDOAfoCgGvPQMlz+wBw+EoggQEA9IaVIFjXCz+TbV8g4pMibrOOLCTCHeMIJKQ1+CO7myD4SoEBAPRbMPhq3lMSgQEA9HyVIFjXCz+TbV8g4mwj4xhfCAMoMPhG8uBM+EJu4wDU0ds8MNs88gAQDhUCXPhFIG6SMHDe+EK68uBl+ADbPPgPIPsE0CCLOK2zWMcFk9dN0N7XTNDtHu1T2zwVDwAE8AIAHu1E0NP/0wAx9ATR+Gr4YgAK+Eby4EwCCvSkIPShFBMAFHNvbCAwLjU5LjQBFqAAAAAC2zz4D/IAFQAc+Er4QsjL/8+D9ADJ7VQ=",
    codeHash: "726aec999006a2e036af36c46024237acb946c13b4d4b3e1ad3b4ad486d564b1",
};
module.exports = { GiverV3Contract };