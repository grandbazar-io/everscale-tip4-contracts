pragma ton-solidity =0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./CollectionBase.sol";
import "./interfaces/ICollection.sol";

contract Collection is CollectionBase, ICollection {
	/// @notice Emits in Collection constructor
	/// @param id Unique Collection ID
	/// @param collectionRoot CollectionsRoot address
	/// @param author Collection author (creator) address
	/// @param json Collection json corresponding to TIP-4.2 standart
	/// @param isProtected If only author can mint to collection or not
	event CollectionCreated(
		uint256 id,
		address collectionRoot,
		address author,
		string json,
		bool isProtected
	);

	uint256 static _id;

	address _collectionRoot;
	address _author;

	bool _isProtected;

	/// @param codeNft NFT contract code
	/// @param codeIndex NFT Index contract code
	/// @param codeIndexBasis Collection IndexBasis contract code
	/// @param ownerPubkey Collection owner key
	/// @param json Collection json corresponding to TIP-4.2 standart
	/// @param mintingFee Value that Collection contract takes itself for every mint
	/// @param withdrawalAddress Receiver of evers that withdraw method sends
	/// @param methodsCallsFee - Value to be sent with some methods calls (like call of CollectionsFactory contract during collection deployment)
	/// @param minimalGasAmount Value for processing mint method itself (this value doesn't include any other fees)
	/// @param leftOnCollection Amount of evers that will be left on Collection after deployment
	/// @param author The only address that can mint NFT if the collection is protected
	/// @param sendGasTo Address that will get all the change
	/// @param isProtected If set to true, then only author can mint NFT
	constructor(
		TvmCell codeNft,
		TvmCell codeIndex,
		TvmCell codeIndexBasis,
		uint256 ownerPubkey,
		string json,
		uint128 mintingFee,
		address withdrawalAddress,
		uint128 methodsCallsFee,
		uint128 minimalGasAmount,
		uint128 leftOnCollection,
		address author,
		address sendGasTo,
		bool isProtected
	)
		public
		CollectionBase(
			codeNft,
			codeIndex,
			codeIndexBasis,
			ownerPubkey,
			json,
			mintingFee,
			withdrawalAddress
		)
	{
		optional(TvmCell) optSalt = tvm.codeSalt(tvm.code());
		require(optSalt.hasValue(), value_is_empty);
		address collectionRoot = optSalt.get().toSlice().decode(address);
		require(
			msg.sender == collectionRoot,
			BaseErrors.message_sender_is_not_my_owner
		);
		tvm.rawReserve(leftOnCollection, 0);

		_collectionRoot = collectionRoot;
		_author = author;
		_isProtected = isProtected;
		_methodsCallsFee = methodsCallsFee;
		_minimalGasAmount = minimalGasAmount;

		_supportedInterfaces[
			bytes4(tvm.functionId(ICollection.collectionAuthorshipInfo)) ^
				bytes4(tvm.functionId(ICollection.collectionRootAddress))
		] = true;

		emit CollectionCreated(_id, collectionRoot, author, json, isProtected);

		sendGasTo.transfer({value: 0, flag: 128 + 2});
	}

	/// @notice Returns info about rooted collection
	/// @return author Creator address
	/// @return isProtected Is there only author can mint to collection or not
	function collectionAuthorshipInfo()
		external
		view
		virtual
		responsible
		override
		returns (address author, bool isProtected)
	{
		return {value: 0, flag: 64, bounce: false} (_author, _isProtected);
	}

	/// @notice Returns address of root that created this collection
	/// @return collectionRoot Root address
	function collectionRootAddress()
		external
		view
		virtual
		responsible
		override
		returns (address collectionRoot)
	{
		return {value: 0, flag: 64, bounce: false} (_collectionRoot);
	}

	/// @notice Owner can destroy collection if there are not minted NFT
	/// @param sendGasTo Change recipient address
	function destroy(address sendGasTo) external virtual override {
		require(_totalSupply == 0, BaseErrors.total_supply_is_more_than_zero);
		require(
			msg.sender == _author,
			BaseErrors.message_sender_is_not_my_owner
		);
		selfdestruct(sendGasTo);
	}
}
