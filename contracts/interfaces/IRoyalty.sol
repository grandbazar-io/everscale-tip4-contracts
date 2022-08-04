pragma ton-solidity = 0.58.1;

interface IRoyalty {
    /// @return royalty Contains mapping address => percent
    function royaltyInfo() external view responsible returns(mapping (address => uint8) royalty);
}