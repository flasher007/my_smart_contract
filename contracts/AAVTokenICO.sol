pragma solidity ^0.4.11;
import "../zeppelin-solidity/contracts/math/SafeMath.sol";
interface AAVTokenInterface {
    function transfer(address _receiver, uint256 _amount);
}

contract AAVICOContract {
    using SafeMath for uint256;
    uint public buyPrice;

    AAVTokenInterface public token;

    function AAVICOContract(AAVTokenInterface _token){
        token = _token;
        buyPrice = 1000000;
    }

    function () payable {
        _buy(msg.sender, msg.value);
    }

    function buy() payable returns (uint) {
        uint tokens = _buy(msg.sender, msg.value);
        return tokens;
    }

    function _buy(address _sender, uint256 _amount) internal returns (uint){
        uint tokens = div(_amount, buyPrice);
        token.transfer(_sender, tokens);
        return tokens;
    }
}
