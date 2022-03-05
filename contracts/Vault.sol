// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vault{

  mapping(address => uint256) public balanceToken;
  mapping(address => mapping(address => uint256)) public balanceAddress;

  /*  
    NOTE: If the depositor is calling this function, then we don't
    the _account and the transferFrom.
  */
  function deposit_token(address _account, address _token, uint256 _amount) public {

    ERC20 token = ERC20(_token);  // Set token object

    require(token.balanceOf(_account) >= _amount);  // Verify depositor has funds

    // Transfer tokens
    // NOTE: Make sure to approve this address for transfer
    token.transferFrom(_account, address(this), _amount);
    

    // Update records
    balanceAddress[_account][_token] += _amount;
    balanceToken[_token] += _amount;
  }

  /*
    NOTE: Same as deposit_token
  */
  function withdrawal_token(address _account, address _token, uint256 _amount) public {
    ERC20 token = ERC20(_token);  // Set token object

    require(balanceAddress[_account][_token] >= _amount);  // Verify depositor balance has funds

    token.transfer(_account, _amount); // Transfer tokens to customer
    
    // Update records
    balanceAddress[_account][_token] -= _amount;
    balanceToken[_token] -= _amount;
  }

  function vault_token_balance(address _token) public view returns(uint256){
    return balanceToken[_token];
  }

  function person_token_balance(address _token) public view returns(uint256){
    return balanceAddress[msg.sender][_token];
  }

}