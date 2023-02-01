pragma ton-solidity =0.58.1;

interface ICollectionsFactory {
	/// @notice Emits when Collection is deployed
	/// @param id Unique Collection ID
	/// @param collection Address of new Collection
	/// @param author Collection author (creator) address
	/// @param json Collection json corresponding to TIP-4.2 standart
	/// @param isProtected If only author can mint to collection or not
	event CollectionCreated(
		uint256 id,
		address collection,
		address author,
		string json,
		bool isProtected
	);

	/// @notice Emits when NFT is created (Collection must call CollectioRoot method)
	/// @param id Unique NFT ID
	/// @param nft Nft address
	/// @param collection Collection address
	/// @param owner NFT owner address
	/// @param manager NFT manager address
	/// @param creator NFT creator address
	event NftCreated(
		uint256 id,
		address nft,
		address collection,
		address owner,
		address manager,
		address creator
	);

	/// @notice Method that Collections can call to emit CollectionsRoot's NftCreated event
	/// @param id Collection ID that is used to proove that collection is the child of the current CollectionsRoot
	/// @param nftId ID of created NFT
	/// @param nft NFT address
	/// @param owner NFT owner address
	/// @param manager NFT manager address
	/// @param creator NFT creator address
	/// @param sendGasTo Change recipient address
	function onNftCreated(
		uint256 id,
		uint256 nftId,
		address nft,
		address owner,
		address manager,
		address creator,
		address sendGasTo
	) external view;

	/// @notice Returns pubkey that is used in Collection as an owner pubkey
	/// @param ownerPubkey Public key in uint256
	function getCollectionsOwner()
		external
		view
		responsible
		returns (uint256 ownerPubkey);

	/// @notice Total amount of deployed collections
	function totalSupply() external view responsible returns (uint128 count);

	/// @notice All fees values getter
	/// @return totalCreationPrice - Sum of all values used in collections deploy method
	/// @return leftOnCollection - Value that will be left on Collection after the entire deploy process is completed
	/// @return creationPrice - Value that will be reserved and left on CollectionsRoot contract
	/// @return deployIndexBasisValue - Value Value for Collection index deploy
	/// @return nftMintingFee - Value that will be reserved and left on Collection contract after mint is completed
	/// @return methodsCallsFee - Value to be sent with some methods calls (like call of SellRoot and AuctionRoot methods duriing collection deployment)
	/// @return minimalGasAmount - Value for processing collection deploy method
	function getFeesInfo()
		external
		view
		responsible
		returns (
			uint128 totalCreationPrice,
			uint128 leftOnCollection,
			uint128 creationPrice,
			uint128 deployIndexBasisValue,
			uint128 nftMintingFee,
			uint128 methodsCallsFee,
			uint128 minimalGasAmount,
			uint128 collectionsMinimalGasAmount
		);

	/// @notice Returns addresses of offers roots. CollectionRoot calls their methods during collection deployment to add new collection to white list
	function offersRoots()
		external
		view
		responsible
		returns (address sellRoot, address auctionRoot);

	/// @notice If isActive is false, then require() must not allow users to deploy collections
	function deploymentIsActive()
		external
		view
		responsible
		returns (bool isActive);

	/// @notice Returns collection code
	function collectionCode() external view responsible returns (TvmCell code);

	/// @notice Returns collection codeHash
	function collectionCodeHash()
		external
		view
		responsible
		returns (uint256 codeHash);

	/// @notice Returns collection address by its ID
	function collectionAddress(uint256 id)
		external
		view
		responsible
		returns (address collection);
}
