pragma ton-solidity =0.58.1;

pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

contract RandomGenerator {
	uint8 constant generator_is_not_active = 110;
	uint8 constant generator_is_already_active = 111;
	uint8 constant no_numbers_available = 112;

	uint16 constant STEP_SIZE = 100;

	uint16[] _numbers;
	uint16 _numbersAmount;

	uint128 _minBalance;
	uint256 _ownerPubkey;

	bool _active;

	event RandomNumberWasGenerated(address recipient, uint256 number);

	constructor(
		uint256 ownerPubkey,
		uint128 minBalance,
		uint16 numbersAmount
	) public {
		tvm.accept();

		_minBalance = minBalance;
		_ownerPubkey = ownerPubkey;
		_numbersAmount = numbersAmount;
		_active = false;
	}

	function fillNumbersArray() public virtual onlyOwner checkBalance {
		require(!_active, generator_is_already_active);
		tvm.accept();

		uint16 limit;
		uint16 numbersLength = uint16(_numbers.length);
		if (numbersLength + STEP_SIZE < _numbersAmount) {
			limit = uint16(_numbers.length) + STEP_SIZE;
		} else {
			limit = _numbersAmount;
			_active = true;
		}

		for (uint16 i = numbersLength + 1; i <= limit; i++) {
			_numbers.push(i);
		}
	}

	function _getRandomNumber() internal virtual returns (uint256 number) {
		uint16 random = uint16(_genNumber(_numbers.length));
		number = _numbers[random];

		delete _numbers[random];
		_numbers[random] = _numbers[_numbers.length - 1];
		_numbers.pop();
	}

	function _genNumber(uint256 limit)
		internal
		pure
		virtual
		returns (uint64 number)
	{
		rnd.shuffle();
		number = uint64(rnd.next(limit));
	}

	function getFreeNumbers() public view virtual returns (uint16[] numbers) {
		return _numbers;
	}

	function getMinBalance() public view virtual returns (uint128 minBalance) {
		return _minBalance;
	}

	function withdraw(address dest, uint128 value) external virtual onlyOwner {
		tvm.accept();

		dest.transfer(value, true, 1);
	}
	function destruct(address dest) public virtual onlyOwner {
		selfdestruct(dest);
	}

	modifier onlyOwner() {
		require(msg.pubkey() == _ownerPubkey, 101);
		_;
	}

	modifier checkBalance() {
		require(address(this).balance > _minBalance, 102);
		_;
	}

	modifier isActive() {
		require(_active, generator_is_not_active);
		_;
	}
}
