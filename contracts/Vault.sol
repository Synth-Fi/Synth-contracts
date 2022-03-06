// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
// import '@uniswap/v3-core/contracts/libraries/TickMath.sol';
// import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
// import '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';
// import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
// import '@uniswap/v3-periphery/contracts/base/LiquidityManagement.sol';

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';

contract Vault{

  uint256 accountId;

  struct account {
    uint256 id;
    address depositor;
    mapping(address => uint256) balance;
  }

  uint256 interest = 5000000000000000;  // 5% guaranteed interest

  uint256 currId = 1;

  // ids -> account
  mapping(uint256 => account) public accounts;

  // depositor address -> accountIds
  mapping(address => uint256) public ids;

  /*
    Note: It might not be a good idea to keep track of the vaults balance. 
    Since that would be assuming that we are actually gaining the interest. 
    We should just be checking the actual balance of each token that the
    vault contract contains. That will only give us the balance currently in 
    the vault, which doesn't include the money we have in farms. 
  */
  // Token address -> total vault supply
  // mapping(address => uint256) public vaultBalance;

  address[] tokensInVault;

  function deposit_token(address _token, uint256 _amount) public {

    ERC20 token = ERC20(_token);  // Set token object

    require(token.balanceOf(msg.sender) >= _amount, "Insufficent funds");  // Verify depositor has funds

    // Transfer tokens
    // NOTE: Make sure to approve this address for transfer
    token.transferFrom(msg.sender, address(this), _amount);
    
    // Update records
    accounts[ids[msg.sender]].balance[_token] += _amount;         // Add to account balance
    // balanceToken[_token] += _amount;                           // Add to vault balance
    if(!token_in_vault(_token)) tokensInVault.push(_token);  // Add token address if it is a new token
  } 

  function withdraw_token(address _token, uint256 _amount) public {
    ERC20 token = ERC20(_token);  // Set token object

    require(accounts[ids[msg.sender]].balance[_token] >= _amount);  // Verify depositor balance has funds

    token.transfer(msg.sender, _amount); // Transfer tokens to customer
    
    // Update records
    accounts[ids[msg.sender]].balance[_token] -= _amount; // Add to account balance
    // balanceToken[_token] -= _amount;
  }

  function _distribute_interest(address _token) internal {
    uint256 i;
    for(i = 1; i < currId; i++){
      accounts[i].balance[_token] += accounts[i].balance[_token] * interest;
      // vaultBalance[_token] += accounts[i].balance(_token) * interest;
    }
  }

  function _distribute_interest_all_tokens() internal {
    uint256 i;
    for(i = 0; i < tokensInVault.length; i++){
      _distribute_interest(tokensInVault[i]);
    }
  }

  // function vault_token_balance(address _token) public view returns(uint256){
  //   return balanceToken[_token];
  // }

  function person_token_balance(address _token) public view returns(uint256){
    return accounts[ids[msg.sender]].balance[_token];
  }

  function _blockTimestamp() internal view virtual returns (uint32) {
        return uint32(block.timestamp); // truncation is desired
    }

  function token_in_vault(address _token) internal view returns(bool){
    uint256 i;
    for(i = 0; i < tokensInVault.length; i++){
      if(tokensInVault[i] == _token){
        return true;
      }
    }
    return false;
  }

}