// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tidalstorm is ERC20 {
    constructor(uint256 initialSupply) ERC20("Tidalstorm", "TDLS") {
    }
    function decimals() public view virtual override returns (uint8) {
        return 2;
    }
    function _mintMinerReward() internal {
        _mint(block.coinbase, 69);
    }
    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if (!(from == address(0) && to == block.coinbase)) {
          _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }
}