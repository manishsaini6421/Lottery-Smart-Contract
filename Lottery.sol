// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery{
    address payable public manager;
    address payable[] players;

    constructor(){
        manager = payable(msg.sender);
    }
    
    function alreadyEntred() private view returns(bool){
           for(uint i=0; i<players.length; i++){
               if(players[i]==msg.sender){
                   return true;
               }
           }
           return false;
    }

    function Enter() public payable{
        require(msg.sender != manager,"Manager cannot enter");
        require(!alreadyEntred(),"You cannot enter again");
        require(msg.value==5 ether, "You have to pay minimum amount");

        players.push(payable(msg.sender));
    }


    function random() private view returns(uint){
       return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    }

    function pickWinner()  public returns(address payable){
        require(msg.sender==manager,"Only manager can pick the winner");
        uint index=random()%players.length;
         address payable winner = players[index];
         winner.transfer(address(this).balance - 2 ether);
         manager.transfer(2 ether);//manager charge for hosting this
         players =new address payable[](0);
         return winner;
    }

    function Players() view public returns(address payable[] memory){
         return players;
    }
}