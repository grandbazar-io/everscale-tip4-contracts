pragma ton-solidity = 0.58.1;

interface IAuthor {
    /// @notice NFT author (creator) getter
    /// @return addr Address of author
    function author() external view responsible returns(address addr);
}