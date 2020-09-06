pragma solidity ^0.5.1;

import "./AufluxRoot.sol";

contract AufluxBase is AufluxRoot {

    event CreateToken(address owner, uint256 tokenId, uint256 name, uint256 id);
    event Transfer(address from, address to, uint256 tokenId);

    struct Auflux {
        uint256 brand;
        uint256 name;
        uint256 id;
        uint256 purchaseTime;
        uint256 last;
        //应该还要加上主人列表类似的东西
    }

    /*** CONSTANTS ***/

    Auflux[] Aufluxes;

    
    mapping (uint256 => address) public tokenIndexToOwner;

    mapping (address => uint256) public ownershipTokenCount;

    mapping (uint256 => address) public tokenIndexToApproved;

    //拍卖合约暂时不管

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        tokenIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            // 一旦token转移，停止一切的授权
            // once the kitten is transferred also clear sire allowances
            // delete sireAllowedToAddress[_tokenId];
            // clear any previously approved ownership exchange
            // delete kittyIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
        emit Transfer(_from, _to, _tokenId);
    }

    function createToken(
            uint256 _brand,
            uint256 _name,
            uint256 _id,
            uint256 _purchaseTime,
            address _owner
    )
    external
    returns (uint)
    {

        Auflux memory _token = Auflux({
            brand:_brand,
            name:_name,
            id:_id,
            purchaseTime:_purchaseTime,
            last:uint64(now)
            });
        uint256 newTokenId = Aufluxes.push(_token) - 1;

        // It's probably never going to happen, 4 billion cats is A LOT, but
        // let's just be 100% sure we never let this happen.
        require(newTokenId == uint256(uint32(newTokenId)));

        // emit the birth event
        emit CreateToken(
            _owner,
            newTokenId,
            _name,
            _id
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(address(0), _owner, newTokenId);

        return newTokenId;
    }
}