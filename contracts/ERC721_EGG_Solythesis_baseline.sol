pragma solidity ^0.5.0;
library SafeMath256 {
function mul (uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
{
return 0;
}

}

uint256 c = a * b;
assert(c / a == b);
{
return c;
}

}

function div (uint256 a, uint256 b) internal pure returns (uint256) {
{
return a / b;
}

}

function sub (uint256 a, uint256 b) internal pure returns (uint256) {
assert(b <= a);
{
return a - b;
}

}

function add (uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
assert(c >= a);
{
return c;
}

}

function pow (uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
return 0;
}

if (b == 0) {
return 1;
}

uint256 c = a ** b;
assert(c / (a ** (b - 1)) == a);
{
return c;
}

}

}
contract Ownable {
address public owner;
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
function _validateAddress (address _addr) internal pure {
require(_addr != address(0), "invalid address");
}

constructor () public {
owner = msg.sender;
}

modifier onlyOwner() {
        require(msg.sender == owner, "not a contract owner");
        _;
    }
function transferOwnership (address newOwner) onlyOwner public {
_validateAddress(newOwner);
emit OwnershipTransferred(owner, newOwner);
owner = newOwner;
}

}
contract Controllable is Ownable {
mapping (address=>bool) controllers;
modifier onlyController {
        require(_isController(msg.sender), "no controller rights");
        _;
    }
function _isController (address _controller) internal view returns (bool) {
{
return controllers[_controller];
}

}

function _setControllers (address[] memory _controllers) internal {
for (uint256 i = 0; i < _controllers.length; i ++) {
_validateAddress(_controllers[i]);
controllers[_controllers[i]] = true;
}

}

}
contract Upgradable is Controllable {
address[] internalDependencies;
address[] externalDependencies;
function getInternalDependencies () public view returns(address[] memory) {
{
return internalDependencies;
}

}

function getExternalDependencies () public view returns(address[] memory) {
{
return externalDependencies;
}

}

function setInternalDependencies (address[] memory _newDependencies) onlyOwner public {
for (uint256 i = 0; i < _newDependencies.length; i ++) {
_validateAddress(_newDependencies[i]);
}

internalDependencies = _newDependencies;
}

function setExternalDependencies (address[] memory _newDependencies) onlyOwner public {
externalDependencies = _newDependencies;
_setControllers(_newDependencies);
}

}
contract ERC721Basic {
event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
uint256[] internal allTokens;
function balanceOf (address _owner) public view returns (uint256 _balance);
function ownerOf (uint256 _tokenId) public view returns (address _owner);
function exists (uint256 _tokenId) public view returns (bool _exists);
function approve (address _to, uint256 _tokenId) public;
function getApproved (uint256 _tokenId) public view returns (address _operator);
function setApprovalForAll (address _operator, bool _approved) public;
function isApprovedForAll (address _owner, address _operator) public view returns (bool);
function transferFrom (address _from, address _to, uint256 _tokenId) public;
function safeTransferFrom (address _from, address _to, uint256 _tokenId) public;
function safeTransferFrom (address _from, address _to, uint256 _tokenId, bytes memory _data) public;
function supportsInterface (bytes4 _interfaceID) external pure returns (bool);
}
contract ERC721Enumerable is ERC721Basic {
function totalSupply () public view returns (uint256);
function tokenOfOwnerByIndex (address _owner, uint256 _index) public view returns (uint256 _tokenId);
function tokenByIndex (uint256 _index) public view returns (uint256);
}
contract ERC721Metadata is ERC721Basic {
function name () public view returns (string memory _name);
function symbol () public view returns (string memory _symbol);
function tokenURI (uint256 _tokenId) public view returns (string memory);
}
contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
}
contract ERC721Receiver {
function onERC721Received (
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes memory _data
    ) public returns(bytes4);
}
contract ERC721BasicToken is ERC721Basic, Upgradable {
uint256 depth_0;
mapping (address=>bool) a_checker_3;
address[] a_store_4;
uint256 sum_tokenCount;
mapping (uint256=>bool) a_checker_7;
uint256[] a_store_8;
mapping (address=>bool) b_checker_5;
address[] b_store_6;
mapping (address=>uint256) sum_ownersToken;
mapping (address=>bool) a_checker_9;
address[] a_store_10;
using SafeMath256 for uint256;
bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
mapping (uint256=>address) internal tokenOwner;
mapping (uint256=>address) internal tokenApprovals;
mapping (address=>uint256) internal ownedTokensCount;
mapping (address=>mapping (address=>bool)) internal operatorApprovals;
function _checkRights (bool _has) internal pure {
require(_has, "no rights to manage");
}

function _validateAddress (address _addr) internal pure {
require(_addr != address(0), "invalid address");
}

function _checkOwner (uint256 _tokenId, address _owner) internal view {
require(ownerOf(_tokenId) == _owner, "not an owner");
}

function _checkThatUserHasTokens (bool _has) internal pure {
require(_has, "user has no tokens");
}

function balanceOf (address _owner) public view returns (uint256) {
_validateAddress(_owner);
{
return ownedTokensCount[_owner];
}

}

function ownerOf (uint256 _tokenId) public view returns (address) {
address owner = tokenOwner[_tokenId];
_validateAddress(owner);
{
return owner;
}

}

function exists (uint256 _tokenId) public view returns (bool) {
address owner = tokenOwner[_tokenId];
{
return owner != address(0);
}

}

function _approve (address _from, address _to, uint256 _tokenId) internal {
address owner = ownerOf(_tokenId);
require(_to != owner, "can't be approved to owner");
_checkRights(_from == owner || isApprovedForAll(owner, _from));
if (getApproved(_tokenId) != address(0) || _to != address(0)) {
tokenApprovals[_tokenId] = _to;
emit Approval(owner, _to, _tokenId);
}

}

function approve (address _to, uint256 _tokenId) public {
_approve(msg.sender, _to, _tokenId);
}

function remoteApprove (address _to, uint256 _tokenId) onlyController external {
_approve(tx.origin, _to, _tokenId);
}

function getApproved (uint256 _tokenId) public view returns (address) {
require(exists(_tokenId), "token doesn't exist");
{
return tokenApprovals[_tokenId];
}

}

function setApprovalForAll (address _to, bool _approved) public {
require(_to != msg.sender, "wrong sender");
operatorApprovals[msg.sender][_to] = _approved;
emit ApprovalForAll(msg.sender, _to, _approved);
}

function isApprovedForAll (address _owner, address _operator) public view returns (bool) {
{
return operatorApprovals[_owner][_operator];
}

}

function transferFrom (address _from, address _to, uint256 _tokenId) public {
depth_0 += 1;
_checkRights(isApprovedOrOwner(msg.sender, _tokenId));
_validateAddress(_from);
_validateAddress(_to);
clearApproval(_from, _tokenId);
removeTokenFrom(_from, _tokenId);
addTokenTo(_to, _tokenId);
emit Transfer(_from, _to, _tokenId);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_2 = 0; index_2 < a_store_4.length; index_2 += 1) {
sum_tokenCount += ownedTokensCount[a_store_4[index_2]];
assert(sum_tokenCount >= ownedTokensCount[a_store_4[index_2]]);
}

}

assert(sum_tokenCount == allTokens.length);
{
for (uint256 index_3 = 0; index_3 < b_store_6.length; index_3 += 1) {
sum_ownersToken[b_store_6[index_3]] = 0;
}

for (uint256 index_4 = 0; index_4 < a_store_8.length; index_4 += 1) {
sum_ownersToken[tokenOwner[a_store_8[index_4]]] += 1;
assert(sum_ownersToken[tokenOwner[a_store_8[index_4]]] >= 1);
}

}

for (uint256 index_7 = 0; index_7 < a_store_10.length; index_7 += 1) {
assert(ownedTokensCount[a_store_10[index_7]] == sum_ownersToken[a_store_10[index_7]]);
}

}

}

function safeTransferFrom (
        address _from,
        address _to,
        uint256 _tokenId
    ) public {
depth_0 += 1;
safeTransferFrom(_from, _to, _tokenId, "");
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_8 = 0; index_8 < a_store_4.length; index_8 += 1) {
sum_tokenCount += ownedTokensCount[a_store_4[index_8]];
assert(sum_tokenCount >= ownedTokensCount[a_store_4[index_8]]);
}

}

assert(sum_tokenCount == allTokens.length);
{
for (uint256 index_9 = 0; index_9 < b_store_6.length; index_9 += 1) {
sum_ownersToken[b_store_6[index_9]] = 0;
}

for (uint256 index_10 = 0; index_10 < a_store_8.length; index_10 += 1) {
sum_ownersToken[tokenOwner[a_store_8[index_10]]] += 1;
assert(sum_ownersToken[tokenOwner[a_store_8[index_10]]] >= 1);
}

}

for (uint256 index_13 = 0; index_13 < a_store_10.length; index_13 += 1) {
assert(ownedTokensCount[a_store_10[index_13]] == sum_ownersToken[a_store_10[index_13]]);
}

}

}

function safeTransferFrom (
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) public {
depth_0 += 1;
transferFrom(_from, _to, _tokenId);
require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data), "can't make safe transfer");
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_14 = 0; index_14 < a_store_4.length; index_14 += 1) {
sum_tokenCount += ownedTokensCount[a_store_4[index_14]];
assert(sum_tokenCount >= ownedTokensCount[a_store_4[index_14]]);
}

}

assert(sum_tokenCount == allTokens.length);
{
for (uint256 index_15 = 0; index_15 < b_store_6.length; index_15 += 1) {
sum_ownersToken[b_store_6[index_15]] = 0;
}

for (uint256 index_16 = 0; index_16 < a_store_8.length; index_16 += 1) {
sum_ownersToken[tokenOwner[a_store_8[index_16]]] += 1;
assert(sum_ownersToken[tokenOwner[a_store_8[index_16]]] >= 1);
}

}

for (uint256 index_19 = 0; index_19 < a_store_10.length; index_19 += 1) {
assert(ownedTokensCount[a_store_10[index_19]] == sum_ownersToken[a_store_10[index_19]]);
}

}

}

function isApprovedOrOwner (address _spender, uint256 _tokenId) public view returns (bool) {
address owner = ownerOf(_tokenId);
{
return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
}

}

function _mint (address _to, uint256 _tokenId) internal {
_validateAddress(_to);
addTokenTo(_to, _tokenId);
emit Transfer(address(0), _to, _tokenId);
}

function _burn (address _owner, uint256 _tokenId) internal {
clearApproval(_owner, _tokenId);
removeTokenFrom(_owner, _tokenId);
emit Transfer(_owner, address(0), _tokenId);
}

function clearApproval (address _owner, uint256 _tokenId) internal {
_checkOwner(_tokenId, _owner);
if (tokenApprovals[_tokenId] != address(0)) {
tokenApprovals[_tokenId] = address(0);
emit Approval(_owner, address(0), _tokenId);
}

}

function addTokenTo (address _to, uint256 _tokenId) internal {
require(tokenOwner[_tokenId] == address(0), "token already has an owner");
tokenOwner[_tokenId] = _to;if (! a_checker_7[_tokenId]) {
a_store_8.push(_tokenId);
a_checker_7[_tokenId] = true;
}
if (! b_checker_5[tokenOwner[_tokenId]]) {
b_store_6.push(tokenOwner[_tokenId]);
b_checker_5[tokenOwner[_tokenId]] = true;
}

ownedTokensCount[_to] = ownedTokensCount[_to].add(1);if (! a_checker_3[_to]) {
a_store_4.push(_to);
a_checker_3[_to] = true;
}
if (! a_checker_9[_to]) {
a_store_10.push(_to);
a_checker_9[_to] = true;
}

}

function removeTokenFrom (address _from, uint256 _tokenId) internal {
_checkOwner(_tokenId, _from);
_checkThatUserHasTokens(ownedTokensCount[_from] > 0);
ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);if (! a_checker_3[_from]) {
a_store_4.push(_from);
a_checker_3[_from] = true;
}
if (! a_checker_9[_from]) {
a_store_10.push(_from);
a_checker_9[_from] = true;
}

tokenOwner[_tokenId] = address(0);if (! a_checker_7[_tokenId]) {
a_store_8.push(_tokenId);
a_checker_7[_tokenId] = true;
}
if (! b_checker_5[tokenOwner[_tokenId]]) {
b_store_6.push(tokenOwner[_tokenId]);
b_checker_5[tokenOwner[_tokenId]] = true;
}

}

function _isContract (address addr) internal view returns (bool) {
uint256 size;
assembly {
size := extcodesize(addr)
}

{
return size > 0;
}

}

function checkAndCallSafeTransfer (
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) internal returns (bool) {
if (! _isContract(_to)) {
{
return true;
}

}

bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
{
return (retval == _ERC721_RECEIVED);
}

}

}
contract ERC721Token is ERC721, ERC721BasicToken {
bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = 0x80ac58cd;
bytes4 internal constant INTERFACE_SIGNATURE_ERC721TokenReceiver = 0xf0b9e5ba;
bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = 0x5b5e139f;
bytes4 internal constant INTERFACE_SIGNATURE_ERC721Enumerable = 0x780e9d63;
string internal name_;
string internal symbol_;
mapping (address=>uint256[]) internal ownedTokens;
mapping (uint256=>uint256) internal ownedTokensIndex;
mapping (uint256=>uint256) internal allTokensIndex;
mapping (uint256=>string) internal tokenURIs;
string public url;
constructor (string memory _name, string memory _symbol) public {
name_ = _name;
symbol_ = _symbol;
}

function name () public view returns (string memory) {
{
return name_;
}

}

function symbol () public view returns (string memory) {
{
return symbol_;
}

}

function _validateIndex (bool _isValid) internal pure {
require(_isValid, "wrong index");
}

function tokenOfOwnerByIndex (address _owner, uint256 _index) public view returns (uint256) {
_validateIndex(_index < balanceOf(_owner));
{
return ownedTokens[_owner][_index];
}

}

function tokensOfOwner (address _owner) external view returns (uint256[] memory) {
{
return ownedTokens[_owner];
}

}

function getAllTokens () external view returns (uint256[] memory) {
{
return allTokens;
}

}

function totalSupply () public view returns (uint256) {
{
return allTokens.length;
}

}

function tokenByIndex (uint256 _index) public view returns (uint256) {
_validateIndex(_index < totalSupply());
{
return allTokens[_index];
}

}

function addTokenTo (address _to, uint256 _tokenId) internal {
super.addTokenTo(_to, _tokenId);
uint256 length = ownedTokens[_to].length;
ownedTokens[_to].push(_tokenId);
ownedTokensIndex[_tokenId] = length;
}

function removeTokenFrom (address _from, uint256 _tokenId) internal {
_checkThatUserHasTokens(ownedTokens[_from].length > 0);
super.removeTokenFrom(_from, _tokenId);
uint256 tokenIndex = ownedTokensIndex[_tokenId];
uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
uint256 lastToken = ownedTokens[_from][lastTokenIndex];
ownedTokens[_from][tokenIndex] = lastToken;
ownedTokens[_from][lastTokenIndex] = 0;
ownedTokens[_from].length --;
ownedTokensIndex[_tokenId] = 0;
ownedTokensIndex[lastToken] = tokenIndex;
}

function _mint (address _to, uint256 _tokenId) internal {
super._mint(_to, _tokenId);
allTokensIndex[_tokenId] = allTokens.length;
allTokens.push(_tokenId);
}

function _burn (address _owner, uint256 _tokenId) internal {
require(allTokens.length > 0, "no tokens");
super._burn(_owner, _tokenId);
uint256 tokenIndex = allTokensIndex[_tokenId];
uint256 lastTokenIndex = allTokens.length.sub(1);
uint256 lastToken = allTokens[lastTokenIndex];
allTokens[tokenIndex] = lastToken;
allTokens[lastTokenIndex] = 0;
allTokens.length --;
allTokensIndex[_tokenId] = 0;
allTokensIndex[lastToken] = tokenIndex;
}

function supportsInterface (bytes4 _interfaceID) external pure returns (bool) {
{
return (
            _interfaceID == INTERFACE_SIGNATURE_ERC165 ||
            _interfaceID == INTERFACE_SIGNATURE_ERC721 ||
            _interfaceID == INTERFACE_SIGNATURE_ERC721TokenReceiver ||
            _interfaceID == INTERFACE_SIGNATURE_ERC721Metadata ||
            _interfaceID == INTERFACE_SIGNATURE_ERC721Enumerable
        );
}

}

function tokenURI (uint256 _tokenId) public view returns (string memory) {
require(exists(_tokenId), "token doesn't exist");
{
return string(abi.encodePacked(url, _uint2str(_tokenId)));
}

}

function setUrl (string calldata _url) onlyOwner external {
url = _url;
}

function _uint2str (uint _i) internal pure returns (string memory) {
uint i = _i;
uint j = _i;
uint length;
while (j != 0){
            length++;
            j /= 10;
        }
bytes memory bstr = new bytes(length);
uint k = length - 1;
while (i != 0){
            //bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
{
return string(bstr);
}

}

}
contract EggStorage is ERC721Token {
struct Egg {
        uint256[2] parents;
        uint8 dragonType; // used for genesis only
    }
Egg[] eggs;
constructor (string memory _name, string memory _symbol) ERC721Token(_name, _symbol) public {
eggs.length = 1;
}

function push (address _sender, uint256[2] memory _parents, uint8 _dragonType) onlyController public returns (uint256 id) {
depth_0 += 1;
Egg memory _egg = Egg(_parents, _dragonType);
id = eggs.push(_egg).sub(1);
_mint(_sender, id);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_20 = 0; index_20 < a_store_4.length; index_20 += 1) {
sum_tokenCount += ownedTokensCount[a_store_4[index_20]];
assert(sum_tokenCount >= ownedTokensCount[a_store_4[index_20]]);
}

}

assert(sum_tokenCount == allTokens.length);
{
for (uint256 index_21 = 0; index_21 < b_store_6.length; index_21 += 1) {
sum_ownersToken[b_store_6[index_21]] = 0;
}

for (uint256 index_22 = 0; index_22 < a_store_8.length; index_22 += 1) {
sum_ownersToken[tokenOwner[a_store_8[index_22]]] += 1;
assert(sum_ownersToken[tokenOwner[a_store_8[index_22]]] >= 1);
}

}

for (uint256 index_25 = 0; index_25 < a_store_10.length; index_25 += 1) {
assert(ownedTokensCount[a_store_10[index_25]] == sum_ownersToken[a_store_10[index_25]]);
}

}

}

function mint (address to, uint tokenId) public {
depth_0 += 1;
uint256 p1 = 1;
uint256[2] memory _parents = [p1, p1];
uint8 _dragonType = 1;
Egg memory _egg = Egg(_parents, _dragonType);
_mint(to, tokenId);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_26 = 0; index_26 < a_store_4.length; index_26 += 1) {
sum_tokenCount += ownedTokensCount[a_store_4[index_26]];
assert(sum_tokenCount >= ownedTokensCount[a_store_4[index_26]]);
}

}

assert(sum_tokenCount == allTokens.length);
{
for (uint256 index_27 = 0; index_27 < b_store_6.length; index_27 += 1) {
sum_ownersToken[b_store_6[index_27]] = 0;
}

for (uint256 index_28 = 0; index_28 < a_store_8.length; index_28 += 1) {
sum_ownersToken[tokenOwner[a_store_8[index_28]]] += 1;
assert(sum_ownersToken[tokenOwner[a_store_8[index_28]]] >= 1);
}

}

for (uint256 index_31 = 0; index_31 < a_store_10.length; index_31 += 1) {
assert(ownedTokensCount[a_store_10[index_31]] == sum_ownersToken[a_store_10[index_31]]);
}

}

}

function get (uint256 _id) external view returns (uint256[2] memory, uint8) {
{
return (eggs[_id].parents, eggs[_id].dragonType);
}

}

function remove (address _owner, uint256 _id) onlyController external {
delete eggs[_id];
_burn(_owner, _id);
}

}
