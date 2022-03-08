// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

/* 
  Idea: I don't know if this contract needs to be separate. It could
  maybe be in the vault contract
*/
contract Swapper{

  ISwapRouter public immutable swapRouter;

  address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
  address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

  // For this example, we will set the pool fee to 0.3%.
  uint24 public constant poolFee = 3000;

  constructor(ISwapRouter _swapRouter) {
    swapRouter = _swapRouter;
  }

  function swapExactInputSingle(address _token0, address _token1, uint256 _amountIn) external returns (uint256 amountOut) {
    //msg.sender must approve this contract

    // Transfer the specified amount of token0 to this contract 
    TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), _amountIn);

    TransferHelper.safeApprove(DAI, address(swapRouter), _amountIn);

    ISwapRouter.ExactInputSingleParams memory params = 
      ISwapRouter.ExactInputSingleParams({
        tokenIn: _token0,
        tokenOut: _token1,
        fee: poolFee,
        recipient: msg.sender,
        deadline: block.timestamp,
        amountIn: _amountIn,
        amountOutMinimum: 0,
        sqrtPriceLimitX96: 0
      });

      amountOut = swapRouter.exactInputSingle(params);

  }

  function swapExactOutputsingle(address _token0, address _token1, uint256 _amountOut, uint256 _amountInMaximum) external returns (uint256 amountIn){

    // Transfer the specified amount of DIA to this contract
    TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), _amountInMaximum);

    TransferHelper.safeApprove(DAI, address(swapRouter), _amountInMaximum);

    ISwapRouter.ExactOutputSingleParams memory params = 
      ISwapRouter.ExactOutputSingleParams({
        tokenIn: _token0,
        tokenOut: _token1,
        fee: poolFee,
        recipient: msg.sender,
        deadline: block.timestamp,
        amountOut: _amountOut,
        amountInMaximum: _amountInMaximum,
        sqrtPriceLimitX96: 0
      });

    amountIn = swapRouter.exactOutputSingle(params);

    if(amountIn < _amountInMaximum){
      TransferHelper.safeApprove(_token0, address(swapRouter), 0);
      TransferHelper.safeTransfer(_token0, msg.sender, _amountInMaximum - amountIn);
    }
  }


}