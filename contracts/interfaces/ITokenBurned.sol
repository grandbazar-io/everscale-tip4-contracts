pragma ton-solidity =0.58.1;

interface ITokenBurned {
	/// @notice Collection method that NFT can call on its burn
	/// @param id Unique NFT ID
	/// @param owner NFT owner
	/// @param manager NFT manager
	/// @param sendGasTo Change recipient address
	function onTokenBurned(
		uint256 id,
		address owner,
		address manager,
		address sendGasTo
	) external;
}
