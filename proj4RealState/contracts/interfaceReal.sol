// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;    

interface interfaceReal {
    function getTime(uint256 _index) external returns (uint256);
    function payTransfer(address user, uint256 _index) external payable;
    function approveClient(uint256 _index, address client, bool approved) external;
    function getReal(uint256 _index) external view returns (
        address owner,
        string memory model,
        uint256 valueRealEstate,
        address broker,
        uint256 commission,
        address RealestateAddr,
        uint256 balance
    );

    event RealestateAddr(address _idAddress);
    event paySucess(uint256 _value, uint256 time);
    
}
