pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
import "./searchAddress.sol";

interface AAVTokenInterface {
    function transfer(address _receiver, uint256 _amount) public;
}

contract AAVICOContract is usingOraclize, Ownable {
    using SafeMath for uint;
    using SearchAddress for address[];

    address[] public investorWhiteList;

    uint public constant usdRate = 100; //in cents
    uint public buyPrice;
    uint public ETHUSDPrice;
    uint public updateInterval = 43200; //12 hours by default
    string public url = "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.[0]";

    event newOraclizeQuery(string description);
    event newPriceTicker(uint price);

    AAVTokenInterface public token;

    function AAVICOContract(AAVTokenInterface _token) public {
        token = _token;
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        update();
    }

    function () public payable {
        _buy(msg.sender, msg.value);
    }

    function buy() payable public returns (uint) {
        uint tokens = _buy(msg.sender, msg.value);
        return tokens;
    }

    function _buy(address _sender, uint256 _amount) internal returns (uint){
        require(investorWhiteList.searchFor(_sender) != false);
        uint tokens = _amount.mul(ETHUSDPrice).div(usdRate);
        token.transfer(_sender, tokens);
        return tokens;
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) throw;
        ETHUSDPrice = parseInt(result, 2);
        newPriceTicker(ETHUSDPrice);
        update();
    }

    function update() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query(updateInterval, "URL", url);
        }
    }

    function setUpdateInterval(uint newInterval) external onlyOwner {
        require(newInterval > 0);
        updateInterval = newInterval;
    }

    function setNewWhiteList(address newWhiteList) external onlyOwner {
        require(newWhiteList != 0x0);
        investorWhiteList.push(newWhiteList);
    }

}
