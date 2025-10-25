pragma solidity ^0.8.28

contract Bank {

    event Deposited(address indexed sender, uint256 indexed amount);

    mapping(address => uint256) balances;
    error TooLowBalance();

    function deposit() external payable {
        //update balances tracking
        balances[msg.sender] += msg.value;

        //emit event log
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        //update balances tracking
        if (balances[msg.sender] < amount) {
            revert TooLowBalance();
        }
        // require(balances[msg.sender] >= amount, TooLowBalance());
        balances[msg.sender] -= amount; //specifikuje, kolik ten uzivatel chce vybrat

        //send ether to user
        payable(msg.sender).transfer(amount); //odeberou se ethery z adresy kontraktu


        //emit event log
        emit Withdrawn(msg.sender, amount);
    }
}