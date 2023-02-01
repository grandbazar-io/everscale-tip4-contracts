pragma ton-solidity =0.58.1;

interface IWithdrawalAddress {
	function withdrawalAddress()
		external
		view
		responsible
		returns (address addr);
}
