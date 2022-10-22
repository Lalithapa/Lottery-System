// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender; ///address of the sender
    }

    receive() external payable {
        //this can be used only once- used to send ether at only once
        require(msg.value == 2 ether); //it is like ifElse condition
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() private view returns (uint256) {
        //for getting random numbers
        return
            uint256(
                keccak256( // it is a hashing algorithm in which it choose 
                //the random number of byte 32
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        participants.length
                    )
                )
            );
    }
   
    function selectWinner() public{
        require(msg.sender == manager);
        require(participants.length >= 3);

        uint256 r = random();
        uint256 index = r % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
    }
}
