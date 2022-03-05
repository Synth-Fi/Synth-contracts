// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vault{

  mapping(address => uint256) public balanceToken;
  mapping(address => mapping(address => uint256)) public balanceAddress;

  function deposit_token(address _token, uint256 _amount) public {

    ERC20 token = ERC20(_token);  // Set token object

    require(token.balanceOf(msg.sender) >= _amount, "Insufficent funds");  // Verify depositor has funds

    // Transfer tokens
    // NOTE: Make sure to approve this address for transfer
    token.transferFrom(msg.sender, address(this), _amount);
    

    // Update records
    balanceAddress[msg.sender][_token] += _amount;
    balanceToken[_token] += _amount;
  }

  function withdrawal_token(address _token, uint256 _amount) public {
    ERC20 token = ERC20(_token);  // Set token object

    require(balanceAddress[msg.sender][_token] >= _amount);  // Verify depositor balance has funds

    token.transfer(msg.sender, _amount); // Transfer tokens to customer
    
    // Update records
    balanceAddress[msg.sender][_token] -= _amount;
    balanceToken[_token] -= _amount;
  }

  function vault_token_balance(address _token) public view returns(uint256){
    return balanceToken[_token];
  }

  function person_token_balance(address _token) public view returns(uint256){
    return balanceAddress[msg.sender][_token];
  }

}