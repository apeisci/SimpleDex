// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleDEX {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;
    address public owner;

    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);
    event TokenSwapped(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Transfer of TokenA failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Transfer of TokenB failed");
        reserveA += amountA;
        reserveB += amountB;
        emit LiquidityAdded(amountA, amountB);
    }

    function swapAforB(uint256 amountAIn) external {
        uint256 amountBOut = getAmountOut(amountAIn, reserveA, reserveB);
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Transfer of TokenA failed");
        require(tokenB.transfer(msg.sender, amountBOut), "Transfer of TokenB failed");
        reserveA += amountAIn;
        reserveB -= amountBOut;
        emit TokenSwapped(msg.sender, address(tokenA), amountAIn, address(tokenB), amountBOut);
    }

    function swapBforA(uint256 amountBIn) external {
        uint256 amountAOut = getAmountOut(amountBIn, reserveB, reserveA);
        require(tokenB.transferFrom(msg.sender, address(this), amountBIn), "Transfer of TokenB failed");
        require(tokenA.transfer(msg.sender, amountAOut), "Transfer of TokenA failed");
        reserveB += amountBIn;
        reserveA -= amountAOut;
        emit TokenSwapped(msg.sender, address(tokenB), amountBIn, address(tokenA), amountAOut);
    }

    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(amountA <= reserveA, "Not enough TokenA in reserve");
        require(amountB <= reserveB, "Not enough TokenB in reserve");
        reserveA -= amountA;
        reserveB -= amountB;
        require(tokenA.transfer(msg.sender, amountA), "Transfer of TokenA failed");
        require(tokenB.transfer(msg.sender, amountB), "Transfer of TokenB failed");
        emit LiquidityRemoved(amountA, amountB);
    }

    function getPrice(address _token) external view returns (uint256) {
        if (_token == address(tokenA)) {
            return reserveB / reserveA;
        } else if (_token == address(tokenB)) {
            return reserveA / reserveB;
        } else {
            revert("Invalid token address");
        }
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256) {
        uint256 amountInWithFee = amountIn * 997;
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 1000) + amountInWithFee;
        return numerator / denominator;
    }
}