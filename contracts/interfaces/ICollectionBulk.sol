pragma ton-solidity =0.58.1;

interface ICollectionBulk {
	event BulkNftCreated(
		uint256 id,
		address nft,
		address owner,
		address manager,
		address creator,
		string json,
		uint128 editionId,
		uint32 editionSize,
		uint32 editionNumber
	);

	/// @return supply Amount of editions in collection
	function editionsSupply()
		external
		view
		responsible
		returns (uint128 supply);
}
