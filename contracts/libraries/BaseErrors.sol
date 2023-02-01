pragma ton-solidity =0.58.1;

library BaseErrors {
	uint8 constant message_sender_is_not_my_owner = 200;
	uint8 constant not_enough_value = 201;
	uint8 constant not_enough_balance_to_withdraw = 202;
	uint8 constant message_sender_is_not_my_data = 203;
	uint8 constant message_sender_is_not_my_collection = 204;
	uint8 constant total_supply_is_more_than_zero = 205;
}
