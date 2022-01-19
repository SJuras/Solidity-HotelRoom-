/ SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;


contract HotelRoom {

    // STATUS of hotel room (avaliable or occupied)
    enum Statuses {
        Vacant,
        Occupied
    }

    Statuses currentStatus;

    // event
    event Occupy(address _occupant, uint _value);

    // creator of contract, who receives payments
    address payable public owner;

    constructor(){
        owner = payable(msg.sender);
        // default room status is: avaliable
        currentStatus = Statuses.Vacant;
    }

    // MODIFIERS
    // check if room is Vacant
    modifier onlyWhileVacant {
        require(currentStatus == Statuses.Vacant, "Currently Occupied");
        _;
    }

    // check if the price is payed
    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not enough Ether");
        _;
    }



    receive() external payable onlyWhileVacant costs(0.1 ether) {
        require(msg.value >= 0.1 ether, "Not enouth Ether");
        // change the room status to - Occupied
        currentStatus = Statuses.Occupied;
        // calling this function pays to the owner
        owner.transfer(msg.value);
        // emit the event that a room is now occupied
        emit Occupy(msg.sender, msg.value);
    }


}
