pragma ton-solidity =0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "../contracts/CollectionBase.sol";

contract CollectionSample is CollectionBase {
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
		tvm.accept();
	}

	function mint(string json, mapping(address => uint8) royalty)
		external
		virtual
	{
		require(
			msg.value >= _totalCreationPrice(),
			BaseErrors.not_enough_value
		);
		/// reserve original_balance + _mintingFee
		tvm.rawReserve(_mintingFee, 4);

		uint256 id = _lastTokenId;
		_totalSupply++;
		_lastTokenId++;

		TvmCell codeNft = _buildNftCode(address(this));
		TvmCell stateNft = _buildNftState(codeNft, id);
		address nftAddr = new Nft{stateInit: stateNft, value: 0, flag: 128}(
			msg.sender,
			msg.sender,
			msg.sender,
			_remainOnNft,
			json,
			royalty,
			_indexDeployValue,
			_indexDestroyValue,
			_codeIndex,
			_nftBurnFee
		);

		emit NftCreated(id, nftAddr, msg.sender, msg.sender, msg.sender);
	}
}
