pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol"; //knihovna na restrikce funkci ownera
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) Ownable(msg.sender) { //msg.sender - owner toho kontraktu
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() external payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, tokenAmount); //pointer na kontrakt, od ktereho ocekavame, ze bude implementovat nejaky interface
        // payable(address(msg.sender)) - odesilani ETH
        emit BuyTokens(msg.sender, msg.value, tokenAmount);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance); //nativni funkce jazyka
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) external {
        // if (yourToken.allowance(msg.sender, address(this)) < amount) {
        //     revert("no allowance");
        // }

        yourToken.transferFrom(msg.sender, address(this), _amount);//implementace tokenu dela tu kontrolu a domluvi to - je to odpovednost opensource, ze ktereho to implementujeme. vychazi to uz ze erc20 standardu
        //nemusi to nechat cele revertnout jako na hornim priklade
        uint256 ethAmount = _amount / tokensPerEth;
        payable(msg.sender).transfer(ethAmount); //nativni funkce solidity
    }
}
