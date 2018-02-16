pragma solidity ^0.4.16;

library SearchAddress {

    function searchFor(address[] storage self, address _investor) returns (bool){
        for (uint i = 0; i < self.length; i++){
            if (self[i] == _investor) return true;
        }
        return false;
    }
}
