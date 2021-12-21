pragma solidity ^0.8.0;

contract Multisig {

    mapping(address => uint) balances;
    mapping(address => bool) isOwner;

    struct Transaction {
        uint amount;
        uint8 approvals;
        address sender;
        address receiver;
        bool isApproved;
    }

    Transaction [] public transactions;

    constructor() public {
        isOwner[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = true;
        isOwner[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = true;
        isOwner[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = true;
    }

    function deposit() public payable {
        balances[msg.sender] = msg.value;
    }

    function transfer(uint _amount, address _to) public returns(uint){
        transactions.push(Transaction(_amount, 0, msg.sender, _to, false));
        return transactions.length-1;
    }

    function approve(uint _index) public {
        require(isOwner[msg.sender] == true);
        transactions[_index].approvals +=1;
        if(transactions[_index].approvals >= 2){
            transactions[_index].isApproved = true;
        }
    }

    function transact(uint _index) public {
        Transaction memory toSend = transactions[_index];
        require(toSend.isApproved == true, "Transaction not approved!");
        balances[msg.sender] -= toSend.amount;
        balances[toSend.receiver] += toSend.amount;
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }


}
