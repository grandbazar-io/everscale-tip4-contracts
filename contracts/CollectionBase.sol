pragma ton-solidity =0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "@itgold/everscale-tip/contracts/TIP4_2/TIP4_2Collection.sol";
import "@itgold/everscale-tip/contracts/TIP4_3/TIP4_3Collection.sol";
import "@itgold/everscale-tip/contracts/access/OwnableExternal.sol";
import "./interfaces/ITokenBurned.sol";
import "./interfaces/ICollectionBase.sol";
import "./interfaces/IWithdrawalAddress.sol";
import "./libraries/BaseErrors.sol";
import "./Nft.sol";

contract CollectionBase is
	TIP4_2Collection,
	TIP4_3Collection,
	ITokenBurned,
	OwnableExternal,
	ICollectionBase,
	IWithdrawalAddress
{
	/// _remainOnNft - the number of evers that will remain after the entire mint
	/// process is completed on the Nft contract
	uint128 _remainOnNft = 0.3 ever;
	/// Value to be sent with some methods calls (like call of CollectionRoot contract during collection deploy)
	uint128 _methodsCallsFee = 0.1 ever;
	uint128 _nftBurnFee = 0.4 ever;
	uint128 _minimalGasAmount = 0.2 ever;
	uint128 _mintingFee;

	address _withdrawalAddress;

	uint256 _lastTokenId;

	/// @param codeNft NFT contract code
	/// @param codeIndex NFT Index contract code
	/// @param codeIndexBasis Collection IndexBasis contract code
	/// @param ownerPubkey Collection owner key
	/// @param json Collection json corresponding to TIP-4.2 standart
	/// @param mintingFee Value that Collection contract takes itself for every mint
	/// @param withdrawalAddress Receiver of evers that withdraw method sends
	constructor(
		TvmCell codeNft,
		TvmCell codeIndex,
		TvmCell codeIndexBasis,
		uint256 ownerPubkey,
		string json,
		uint128 mintingFee,
		address withdrawalAddress
	)
		public
		TIP4_1Collection(codeNft)
		TIP4_2Collection(json)
		TIP4_3Collection(codeIndex, codeIndexBasis)
		OwnableExternal(ownerPubkey)
	{
		tvm.accept();

		_mintingFee = mintingFee;
		_withdrawalAddress = withdrawalAddress;

		_supportedInterfaces[
			bytes4(tvm.functionId(ICollectionBase.getFeesInfo))
		] = true;
		_supportedInterfaces[
			bytes4(tvm.functionId(ITokenBurned.onTokenBurned))
		] = true;
		_supportedInterfaces[
			bytes4(tvm.functionId(IWithdrawalAddress.withdrawalAddress))
		] = true;
	}

	/// @notice transfers funds to _withdrawalAddress
	/// @param value Evers amount to be sent
	function withdraw(uint128 value) external view virtual onlyOwner {
		require(
			address(this).balance - value >= 2 ever,
			BaseErrors.not_enough_balance_to_withdraw
		);
		tvm.accept();
		_withdrawalAddress.transfer(value, true);
	}

	/// @notice Method that NFT can call on its burn
	/// @param id Unique NFT ID
	/// @param owner NFT owner
	/// @param manager NFT manager
	/// @param sendGasTo Change recipient address
	function onTokenBurned(
		uint256 id,
		address owner,
		address manager,
		address sendGasTo
	) external virtual override {
		require(
			msg.sender == _resolveNft(id),
			BaseErrors.message_sender_is_not_my_data
		);
		tvm.rawReserve(0, 4);
		emit NftBurned(id, msg.sender, owner, manager);
		_totalSupply--;
		sendGasTo.transfer({value: 0, flag: 128});
	}

	/// @notice Sets the number of evers that will remain after the entire mint
	/// process is completed on the Nft contract
	/// @param value Amount of evers to remain
	function setRemainOnNft(uint128 value) external virtual onlyOwner {
		_remainOnNft = value;
	}

	/// @notice Sets value that Collection contract takes itself for every mint
	/// @param value Amount of evers
	function setMintingFee(uint128 value) external virtual onlyOwner {
		_mintingFee = value;
	}

	/// @notice Sets value to be sent with some methods calls
	/// @param value Amount of evers
	function setMethodCallsFee(uint128 value) external virtual onlyOwner {
		_methodsCallsFee = value;
	}

	/// @notice Sets value for processing mint method itself
	/// @param value Amount of evers
	function setMinimalGasAmout(uint128 value) external virtual onlyOwner {
		_minimalGasAmount = value;
	}

	/// @notice Sets value for NFT index deployment
	/// @param value Amount of evers
	function setIndexDeployValue(uint128 value) external virtual onlyOwner {
		_indexDeployValue = value;
	}

	/// @notice Sets value for NFT index destruction
	/// @param value Amount of evers
	function setIndexDestroyValue(uint128 value) external virtual onlyOwner {
		_indexDestroyValue = value;
	}

	/// @notice Sets value for Collection index deployment
	/// @param value Amount of evers
	function setDeployIndexBasisValue(uint128 value)
		external
		virtual
		onlyOwner
	{
		_deployIndexBasisValue = value;
	}

	/// @notice Value that is needed to burn NFT
	/// @param value Amount of evers
	function setNftBurnFee(uint128 value) external virtual onlyOwner {
		_nftBurnFee = value;
	}

	/// @notice Sets address for funds withdrawal. Only current _withdrawalAddress should be able to do this
	/// @param addr New withdrawal address
	function setWithdrawalAddress(address addr) external virtual {
		require(
			msg.sender == _withdrawalAddress,
			BaseErrors.message_sender_is_not_my_owner
		);
		tvm.rawReserve(0, 4);

		_withdrawalAddress = addr;
		msg.sender.transfer({value: 0, flag: 128, bounce: false});
	}

	/// @notice Owner can destroy collection if there are not minted NFT
	/// @param sendGasTo Change recipient address
	function destroy(address sendGasTo) external virtual onlyOwner {
		require(_totalSupply == 0, BaseErrors.total_supply_is_more_than_zero);
		selfdestruct(sendGasTo);
	}

	/// @notice returns current withdrawal address
	/// @return addr Current withdrawal address
	function withdrawalAddress()
		external
		view
		virtual
		responsible
		override
		returns (address addr)
	{
		return {value: 0, flag: 64, bounce: false} (_withdrawalAddress);
	}

	/// @notice All fees values getter
	/// @return totalCreationPrice - Sum of all values used in mint method
	/// @return mintingFee - Value that Collection contract takes itself for every mint
	/// @return methodsCallsFee - Value to be sent with some methods calls (like call of CollectionRoot contract during collection deployment)
	/// @return minimalGasAmount - Value for processing mint method
	/// @return remainOnNft - Value that will be left on NFT after the entire mint process is completed
	/// @return indexDeployValue - Value for NFT index deployment
	/// @return indexDestroyValue - Value for NFT index destruction
	/// @return deployIndexBasisValue - Value for Collection index deployment
	/// @return nftBurnFee - Value that is needed for burn
	function getFeesInfo()
		external
		view
		virtual
		responsible
		override
		returns (
			uint128 totalCreationPrice,
			uint128 mintingFee,
			uint128 methodsCallsFee,
			uint128 minimalGasAmount,
			uint128 remainOnNft,
			uint128 indexDeployValue,
			uint128 indexDestroyValue,
			uint128 deployIndexBasisValue,
			uint128 nftBurnFee
		)
	{
		return
			{value: 0, flag: 64, bounce: false} (
				_totalCreationPrice(),
				_mintingFee,
				_methodsCallsFee,
				_minimalGasAmount,
				_remainOnNft,
				_indexDeployValue,
				_indexDestroyValue,
				_deployIndexBasisValue,
				_nftBurnFee
			);
	}

	/// @notice Returns current NFT total creation price. It is used to avoid storing another variable and rewriting it on every fee change
	/// @return NFT total creation price
	function _totalCreationPrice() internal view virtual returns (uint128) {
		return
			_remainOnNft +
			_mintingFee +
			(2 * _indexDeployValue) +
			_methodsCallsFee +
			_minimalGasAmount;
	}

	/// @notice Generates a StateInit from code and data
	/// @param code TvmCell code - generated via the _buildNftCode method
	/// @param id Unique nft number
	/// @return TvmCell object - stateInit
	/// about tvm.buildStateInit read more here (https://github.com/tonlabs/TON-Solidity-Compiler/blob/master/API.md#tvmbuildstateinit)
	function _buildNftState(TvmCell code, uint256 id)
		internal
		pure
		virtual
		override(TIP4_2Collection, TIP4_3Collection)
		returns (TvmCell)
	{
		return tvm.buildStateInit({contr: Nft, varInit: {_id: id}, code: code});
	}
}
