pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract AAVToken is MintableToken {

    string public constant name = "Aleksandr Volkov Token Test";
    string public constant symbol = "AAVT";
    uint8 public constant decimals = 18;

    uint public totalSupply = 31000000 * (10 ** decimals);

    function AAVToken() public {
        balances[msg.sender] = totalSupply;
    }
}

