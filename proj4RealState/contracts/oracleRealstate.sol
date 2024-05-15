// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;    

contract oracleRealstate {
    address public owner;
    string public model;
    uint256 public valueRealEstate;
    address public broker;
    uint256 public immutable commission;
    uint256 public timepay;

    address public RealestateAddr;

    constructor(
        address _owner,
        string memory _model,
        uint256 _valueRealEstate,
        address _broker,
        uint256 _commission,
        uint256 _timepay
    )
        payable 
    {
        owner = _owner;
        model = _model;
        broker = _broker;
        valueRealEstate = _valueRealEstate;
        timepay = _timepay;
        commission = _commission;

        RealestateAddr = address(this);
    }

    function newTimepay(uint256 _newtimepay) external onlyOwner {
        timepay = _newtimepay;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
}