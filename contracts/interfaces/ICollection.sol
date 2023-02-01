pragma ton-solidity =0.58.1;

interface ICollection {
	/// @notice Returns info about rooted collection
	/// @return author Creator address
	/// @return isProtected Is there only author can mint to collection or not
	function collectionAuthorshipInfo()
		external
		view
		responsible
		returns (address author, bool isProtected);

	/// @notice Returns address of root that created this collection
	/// @return collectionRoot Root address
	function collectionRootAddress()
		external
		view
		responsible
		returns (address collectionRoot);
}
