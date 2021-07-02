// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract HelloWorld {
    
    address rece = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function withDraw() public {
        payable(rece).transfer(getBalance());
    }
}

contract Test is HelloWorld {
    uint public x;
    fallback() external {
        
    }
}

contract TestPayable is HelloWorld {
    uint public y;
    uint public z;
    
    fallback() external payable {
        y = 1;
        z = msg.value;
    }
    
    receive() external payable {
        y = 2;
        z = msg.value;
    }
}

contract Caller is HelloWorld {
    function callTest(Test test) public {
        (bool success,) = address(test).call(abi.encodeWithSignature("NotExitFun"));
        require(success);
        // 没有 payable 回退函数 error
        // address payable testaddrest = payable(address(test));
        // testaddrest.transfer(5 ether);
    }
    
    function callTestPay(TestPayable test) public {
        (bool success,) = address(test).call(abi.encodeWithSignature("NotExitFun()"));
        require(success);
        (success,) = address(test).call{value: 1}(abi.encodeWithSignature("NotExitFun()"));
        require(success);
    }
    
    // deposit to this contract
    function deposit() public payable {
        payable(address(this)).transfer(5 ether);
    }
    
    // this function must need;
    receive() external payable{
        
    }
}


