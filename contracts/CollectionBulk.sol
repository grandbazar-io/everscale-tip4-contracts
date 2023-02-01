pragma ton-solidity =0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./Collection.sol";
import "./interfaces/ICollection.sol";
import "./interfaces/ICollectionBulk.sol";
import "./NftBulk.sol";

contract CollectionBulk is Collection, ICollectionBulk {
	uint8 amount_is_zero = 230;

	uint128 _editionsSupply;

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
		Collection(
			codeNft,
			codeIndex,
			codeIndexBasis,
			ownerPubkey,
			json,
			mintingFee,
			withdrawalAddress,
			methodsCallsFee,
			minimalGasAmount,
			leftOnCollection,
			author,
			sendGasTo,
			isProtected
		)
	{
		tvm.accept();

		_supportedInterfaces[
			bytes4(tvm.functionId(ICollectionBulk.editionsSupply))
		] = true;
	}

	/// @param amount Amount of NFTs to mint
	/// @param royalty mapping address => percent
	/// @param json Nft json string
	/// @param sellProxyAddr Address of sell proxy for bulk offer creation
	/// @param price Price for every NFT for bulk offer creation
	/// @notice If user wants to put all NFT on sale he has to send _totalCreationPrice() * amount + offer deployment price * amount.
	/// Offer deployment price should be requested from SellRoot contract
	function bulkMint(
		uint32 amount,
		mapping(address => uint8) royalty,
		string json,
		address sellProxyAddr,
		uint128 price
	) external virtual internalMsg {
		require(amount > 0, amount_is_zero);
		require(
			msg.value >= _totalCreationPrice() * amount,
			BaseErrors.not_enough_value
		);
		tvm.rawReserve(_mintingFee * amount, 4);

		ITIP4_1NFT.CallbackParams callbackParams;

		if (price != 0 && sellProxyAddr != address(0)) {
			uint128 deployPrice = msg.value /
				amount -
				_totalCreationPrice() +
				(2 * _methodsCallsFee);
			TvmBuilder payloadBuilder;
			payloadBuilder.store(price, deployPrice - (2 * _methodsCallsFee));

			callbackParams = ITIP4_1NFT.CallbackParams(
				deployPrice,
				payloadBuilder.toCell()
			);
			// Send some evers to proxy contract to pay for cancellation and management returning
			sellProxyAddr.transfer({
				value: 2 * _methodsCallsFee * amount,
				bounce: true,
				flag: 1
			});
		}

		_editionsSupply++;
		uint128 editionId = _editionsSupply;

		_invokeMint(
			msg.sender,
			royalty,
			json,
			callbackParams,
			sellProxyAddr,
			editionId,
			amount,
			0
		);
	}

	function _invokeMint(
		address owner,
		mapping(address => uint8) royalty,
		string json,
		ITIP4_1NFT.CallbackParams callbackParams,
		address sellProxy,
		uint128 editionId,
		uint32 amount,
		uint32 currentIteration
	) internal pure virtual {
		if (currentIteration < amount) {
			CollectionBulk(address(this)).mint{value: 0, flag: 128}(
				owner,
				royalty,
				json,
				callbackParams,
				sellProxy,
				editionId,
				amount,
				currentIteration
			);
		} else {
			owner.transfer({value: 0, flag: 128, bounce: false});
		}
	}

	function mint(
		address owner,
		mapping(address => uint8) royalty,
		string json,
		ITIP4_1NFT.CallbackParams callbackParams,
		address sellProxy,
		uint128 editionId,
		uint32 amount,
		uint32 currentIteration
	) external virtual internalMsg {
		require(
			msg.sender == address(this),
			BaseErrors.message_sender_is_not_my_owner
		);
		tvm.rawReserve(0, 4);

		address manager = callbackParams.value != 0 && sellProxy != address(0)
			? sellProxy
			: owner;
		mapping(address => ITIP4_1NFT.CallbackParams) callbacks;
		uint128 sendToNftValue;

		if (manager == sellProxy) {
			callbacks[sellProxy] = callbackParams;
			sendToNftValue = _sendToNftValue() + callbackParams.value;
		} else {
			callbacks = emptyMap;
			sendToNftValue = _sendToNftValue();
		}

		_totalSupply++;
		_lastTokenId++;
		uint256 id = _lastTokenId;
		/// @notice Start editionNumber with 1 instead of 0
		uint32 editionNumber = currentIteration + 1;

		TvmCell codeNft = _buildNftCode(address(this));
		TvmCell stateNft = _buildNftState(codeNft, id);

		address nftAddr = new NftBulk{
			stateInit: stateNft,
			value: sendToNftValue,
			flag: 0
		}(
			owner,
			owner,
			owner,
			_remainOnNft,
			json,
			royalty,
			_indexDeployValue,
			_indexDestroyValue,
			_codeIndex,
			_nftBurnFee,
			editionId,
			editionNumber,
			amount,
			manager,
			callbacks
		);

		emit NftCreated(id, nftAddr, owner, manager, owner);
		emit BulkNftCreated(
			id,
			nftAddr,
			owner,
			manager,
			owner,
			json,
			editionId,
			amount,
			editionNumber
		);

		currentIteration++;
		_invokeMint(
			owner,
			royalty,
			json,
			callbackParams,
			sellProxy,
			editionId,
			amount,
			currentIteration
		);
	}

	/// @return supply Amount of editions in collection
	function editionsSupply()
		external
		view
		virtual
		responsible
		override
		returns (uint128 supply)
	{
		return {value: 0, flag: 64, bounce: false} (_editionsSupply);
	}

	function _sendToNftValue() internal view virtual returns (uint128) {
		return _remainOnNft + (2 * _indexDeployValue) + (2 * _methodsCallsFee);
	}

	function _totalCreationPrice()
		internal
		view
		virtual
		override
		returns (uint128)
	{
		return
			_remainOnNft +
			_mintingFee +
			(2 * _indexDeployValue) +
			(6 * _methodsCallsFee) +
			_minimalGasAmount;
	}
}
