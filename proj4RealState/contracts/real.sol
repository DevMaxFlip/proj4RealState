// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./oracleRealstate.sol";
import "./interfaceReal.sol";
import ".deps/npm/@openzeppelin/contracts/utils/math/Math.sol";

contract RealStateCorporate is interfaceReal {
    using Math for uint256;

    oracleRealstate[] public oraclesRealstates;
    mapping(address => bool) approved;

    event RealStateAddr(address indexed _idAddress);
    event PaySuccess(uint256 _value, uint256 time);

    function createNewOracle(
        address _owner,
        string memory _model,
        uint256 _valueRealEstate,
        address _broker,
        uint256 _commission,
        uint256 _timepay
    )
        external
    {
        oracleRealstate realstate = new oracleRealstate(_owner, _model, _valueRealEstate, _broker, _commission, _timepay);
        oraclesRealstates.push(realstate);   
    }

    function getReal(uint256 _index) public view returns (
        address owner,
        string memory model,
        uint256 valueRealEstate,
        address broker,
        uint256 commission,
        address RealestateAddr,
        uint256 balance
    )
    {
        oracleRealstate realstate = oraclesRealstates[_index];

        return (
            realstate.owner(),
            realstate.model(),
            realstate.valueRealEstate(),
            realstate.broker(),
            realstate.commission(),
            realstate.RealestateAddr(),
            address(realstate).balance
        );
    }

    function getTime(uint256 _index) public view returns (uint256) {
        oracleRealstate realstate = oraclesRealstates[_index];
        return realstate.timepay();
    }

    function payTransfer(
        address user,
        uint256 _index
    )
        external 
        payable 
    {
        oracleRealstate realstate = oraclesRealstates[_index];
        require(
            msg.value == realstate.valueRealEstate() && approved[msg.sender] && approved[user],
            "value is not correct or client not approved"
        );

        if (getTime(_index) <= block.timestamp) {
            address brokerAddr = realstate.broker();
            uint256 commission = msg.value * realstate.commission() / 100;
            uint256 commissionDouble = commission * 2;
            uint256 payment = msg.value - commissionDouble;
            payable(user).transfer(payment);
            payable(brokerAddr).transfer(commissionDouble);
        } else {
            address brokerAddr = realstate.broker();
            uint256 commission = msg.value * realstate.commission() / 100;
            uint256 payment = msg.value - commission;
            payable(user).transfer(payment);
            payable(brokerAddr).transfer(commission);
        }
        emit PaySuccess(msg.value, block.timestamp);
    }    

    function approveClient(uint256 _index, address client, bool _approved) external {
        oracleRealstate realstate = oraclesRealstates[_index];
        require(msg.sender == realstate.broker(), "only broker can approve");
        approved[client] = _approved;
    }
}
