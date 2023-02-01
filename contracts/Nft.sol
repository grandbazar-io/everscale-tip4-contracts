pragma ton-solidity =0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "@itgold/everscale-tip/contracts/TIP4_1/TIP4_1Nft.sol";
import "@itgold/everscale-tip/contracts/TIP4_2/TIP4_2Nft.sol";
import "@itgold/everscale-tip/contracts/TIP4_3/TIP4_3Nft.sol";
import "./interfaces/IAuthor.sol";
import "./interfaces/ITokenBurned.sol";
import "./interfaces/IRoyalty.sol";
import "./libraries/BaseErrors.sol";

contract Nft is TIP4_1Nft, TIP4_2Nft, TIP4_3Nft, IRoyalty, IAuthor {
	/// @notice Event emits after NFT transfer
	/// @param to New owner
	event NftTransferred(address to);

	/// @notice List of royalties contains mapping address => percent
	mapping(address => uint8) _royalty;
	/// @notice Author (creator) of NFT
	address _author;

	uint128 _burnFee;

	/// @param owner Current owner of NFT
	/// @param author Author (creator) of NFT. It can be equal to author or not
	/// @param sendGasTo Change recipient address
	/// @param remainOnNft Value that will be left on NFT after the entire mint process is completed
	/// @param json NFT json corresponding to TIP-4.2 standart
	/// @param royalty List of royalties contains mapping address => percent
	/// @param indexDeployValue Value for NFT index deployment
	/// @param indexDestroyValue Value for NFT index destruction
	/// @param codeIndex NFT Index contract code
	/// @param burnFee Value required for burn method call
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
		uint128 burnFee
	)
		public
		TIP4_1Nft(owner, sendGasTo, remainOnNft)
		TIP4_2Nft(json)
		TIP4_3Nft(indexDeployValue, indexDestroyValue, codeIndex)
	{
		tvm.accept();

		_royalty = royalty;
		_author = author;
		_burnFee = burnFee;

		_supportedInterfaces[
			bytes4(tvm.functionId(IRoyalty.royaltyInfo))
		] = true;
		_supportedInterfaces[bytes4(tvm.functionId(IAuthor.author))] = true;
	}

	/// @notice Burn method completely destructs NFT contract, sends all remaining balance to sendGasTo
	/// @param sendGasTo Remaining balance recipient address
	function burn(address sendGasTo) external virtual onlyManager {
		require(
			msg.value >= _indexDestroyValue * 2 + _burnFee,
			BaseErrors.not_enough_value
		);

		_destructIndex(sendGasTo);
		ITokenBurned(_collection).onTokenBurned{
			value: _burnFee / 2,
			flag: 0 + 1,
			bounce: false
		}(_id, _owner, _manager, sendGasTo);
		selfdestruct(sendGasTo);
	}

	/// @return royalty Contains mapping address => percent
	function royaltyInfo()
		external
		view
		virtual
		responsible
		override
		returns (mapping(address => uint8) royalty)
	{
		return {value: 0, flag: 64, bounce: false} (_royalty);
	}

	/// @notice NFT author (creator) getter
	/// @return addr Address of author
	function author()
		external
		view
		virtual
		responsible
		override
		returns (address addr)
	{
		return {value: 0, flag: 64, bounce: false} (_author);
	}

	function _beforeChangeOwner(
		address oldOwner,
		address newOwner,
		address sendGasTo,
		mapping(address => CallbackParams) callbacks
	) internal virtual override(TIP4_1Nft, TIP4_3Nft) {
		TIP4_3Nft._beforeChangeOwner(oldOwner, newOwner, sendGasTo, callbacks);
	}

	function _afterChangeOwner(
		address oldOwner,
		address newOwner,
		address sendGasTo,
		mapping(address => CallbackParams) callbacks
	) internal virtual override(TIP4_1Nft, TIP4_3Nft) {
		TIP4_3Nft._afterChangeOwner(oldOwner, newOwner, sendGasTo, callbacks);
	}

	function _beforeTransfer(
		address to,
		address sendGasTo,
		mapping(address => CallbackParams) callbacks
	) internal virtual override(TIP4_1Nft, TIP4_3Nft) {
		TIP4_3Nft._beforeTransfer(to, sendGasTo, callbacks);
	}

	function _afterTransfer(
		address to,
		address sendGasTo,
		mapping(address => CallbackParams) callbacks
	) internal virtual override(TIP4_1Nft, TIP4_3Nft) {
		TIP4_3Nft._afterTransfer(to, sendGasTo, callbacks);
		emit NftTransferred(to);
	}
}
