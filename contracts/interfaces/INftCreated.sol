pragma ton-solidity >=0.58.1;

interface INftCreated {
	/// @notice change owner callback processing
	/// @param id Unique NFT id
	/// @param owner Address of nft owner
	/// @param manager Address of nft manager
	/// @param collection Address of collection smart contract that mint the NFT
	/// @param sendGasTo - Address to send remaining gas
	//  @param payload - Custom payload
	function onNftCreated(
		uint256 id,
		address owner,
		address manager,
		address collection,
		address sendGasTo,
		TvmCell payload
	) external internalMsg;
}
