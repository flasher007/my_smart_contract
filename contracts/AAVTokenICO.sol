pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/math/SafeMath.sol";

interface AAVTokenInterface {
    function transfer(address _receiver, uint256 _amount) public;
}

contract AAVICOContract {
    using SafeMath for uint256;
    uint256 public buyPrice;

    AAVTokenInterface public token;

    function AAVICOContract(AAVTokenInterface _token) public {
        token = _token;
        buyPrice = 1000000;
    }

    function () public payable {
        _buy(msg.sender, msg.value);
    }

    function buy() payable public returns (uint) {
        uint tokens = _buy(msg.sender, msg.value);
        return tokens;
    }

    function _buy(address _sender, uint256 _amount) internal returns (uint){
        uint tokens = div(_amount, buyPrice);
        token.transfer(_sender, tokens);
        return tokens;
    }
}
