pragma ton-solidity =0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./Nft.sol";
import "./interfaces/IEdition.sol";
import "./interfaces/INftCreated.sol";

contract NftBulk is Nft, IEdition {
	uint128 _editionId;
	uint32 _editionSupply;
	uint32 _editionNumber;

	constructor(
		address owner,
		address author,
		address sendGasTo,
		uint128 remainOnNft,
		string json,
		mapping(address => uint8) royalty,
		uint128 indexDeployValue,
		uint128 indexDestroyValue,
		TvmCell codeIndex,
		uint128 burnFee,
		uint128 editionId,
		uint32 editionSupply,
		uint32 editionNumber,
		address manager,
		mapping(address => CallbackParams) callbacks
	)
		public
		Nft(
			owner,
			author,
			sendGasTo,
			remainOnNft,
			json,
			royalty,
			indexDeployValue,
			indexDestroyValue,
			codeIndex,
			burnFee
		)
	{
		tvm.accept();

		_editionSupply = editionSupply;
		_editionId = editionId;
		_editionNumber = editionNumber;

		_supportedInterfaces[
			bytes4(tvm.functionId(IEdition.editionInfo))
		] = true;

		if (manager != owner) {
			_changeManager(manager);
		}

		for ((address dest, CallbackParams p): callbacks) {
			INftCreated(dest).onNftCreated{
				value: p.value,
				flag: 0 + 1,
				bounce: false
			}(
				_id,
				_owner,
				_manager,
				_collection,
				sendGasTo,
				p.payload
			);
		}
	}

	function editionInfo()
		external
		view
		virtual
		responsible
		override
		returns (
			uint128 editionId,
			uint32 editionSupply,
			uint32 editionNumber
		)
	{
		return
			{value: 0, flag: 64, bounce: false} (
				_editionId,
				_editionSupply,
				_editionNumber
			);
	}
}
