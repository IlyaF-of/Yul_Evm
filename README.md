# 🧪 YulEVMPlayground

[![Solidity](https://img.shields.io/badge/Solidity-0.8.26-blue?logo=solidity)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Foundry-Forge-orange?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9ImN1cnJlbnRDb2xvciIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0xMiAydjIwTTIgMTJoMjAiLz48L3N2Zz4=)](https://book.getfoundry.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen)]()
[![Gas Optimized](https://img.shields.io/badge/Gas-Optimized-success)]()

> **Five low-level EVM modules written in pure Yul.**  
> *No `abi.encode`. No hidden `SSTORE`. Just you, the stack, and the opcodes.*

---

## 📌 Overview

**YulEVMPlayground** is a deep-dive educational repository that deconstructs core EVM concepts through inline assembly (Yul). Each module is a **self-contained, heavily-tested contract** demonstrating a specific low-level pattern used in production DeFi protocols.

### 🎯 Target Audience
- Solidity developers preparing for **security audits**
- Engineers tackling **gas optimization challenges**
- Candidates interviewing for **protocol engineering roles** (Senior/Lead)
- Developers who want to understand **what happens under the hood**

### 💡 Why This Repo?

Most Solidity developers never write raw Yul. But when you need to:
- Optimize hot paths in DeFi protocols
- Implement custom proxy patterns
- Debug storage collisions
- Pass technical interviews at top protocols (Uniswap, Aave, Compound)

...you need to understand the EVM at the opcode level.

This repo bridges that gap.

---

## 📦 Modules

| # | Module | What You'll Learn | Production Use Case |
|---|--------|-------------------|---------------------|
| 01 | **YulProxy** | `delegatecall`, EIP-1967 slots, bubble-up revert | OpenZeppelin UUPS, Transparent Proxy |
| 02 | **MemoryInspector** | Memory layout, scratch space, free memory pointer | ABI encoding, dynamic arrays |
| 03 | **CallDataDecoder** | Manual ABI parsing, `calldataload`, offset math | Custom routers, meta-transactions |
| 04 | **Create2Factory** | Deterministic deployment, `CREATE2` opcode | Uniswap V3 pools, Gnosis Safe |
| 05 | **TransientStorage** | `TSTORE`/`TLOAD` (EIP-1153), reentrancy guards | Aave V3, flash loan callbacks |

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/IlyaF-of/Yul_Evm.git
cd Yul_Evm

# Install dependencies
forge install

# Run all tests with verbose output
forge test -vvv

# Run specific module tests
forge test --match-contract ProxyYulTest -vvvv
