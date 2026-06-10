<!-- ═══════════════════════════════════════════════════════════════ -->
<!--                        BADGE ZONE                             -->
<!-- ═══════════════════════════════════════════════════════════════ -->
<p align="center">
  <a href="https://soliditylang.org/">
    <img src="https://img.shields.io/badge/Solidity-^0.8.26-363636?style=for-the-badge&logo=solidity&logoColor=white&labelColor=1a1a1a" alt="Solidity">
  </a>
  <a href="https://book.getfoundry.sh/">
    <img src="https://img.shields.io/badge/Built%20with-Foundry-FFDB1C?style=for-the-badge&logo=ethereum&logoColor=black&labelColor=1a1a1a" alt="Foundry">
  </a>
  <a href="https://eips.ethereum.org/EIPS/eip-1153">
    <img src="https://img.shields.io/badge/EVM-Cancun-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white&labelColor=1a1a1a" alt="EVM Cancun">
  </a>
  <a href="https://github.com/your-username/YulEVMPlayground/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/your-username/YulEVMPlayground/test.yml?style=for-the-badge&logo=githubactions&logoColor=white&label=CI&labelColor=1a1a1a&color=4CAF50" alt="CI">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-4CAF50?style=for-the-badge&logo=open-source-initiative&logoColor=white&labelColor=1a1a1a" alt="License">
  </a>
</p>

<!-- ═══════════════════════════════════════════════════════════════ -->
<!--                        TITLE ZONE                             -->
<!-- ═══════════════════════════════════════════════════════════════ -->
<h1 align="center">
    YulEVMPlayground
</h1>

<p align="center">
  <b>Five low-level EVM modules written in pure Yul.</b><br>
  <i>No <code>abi.encode</code>. No hidden <code>SSTORE</code>. Just you, the stack, and the opcodes.</i>
</p>

<p align="center">
  <a href="#-quick-start">🚀 Quick Start</a> •
  <a href="#-modules">📦 Modules</a> •
  <a href="#-architecture">🏗️ Architecture</a> •
  <a href="#-deep-dive">🔬 Deep Dive</a> •
  <a href="#-gas-comparison">⛽ Gas</a>
</p>

---

## 📌 Overview

**YulEVMPlayground** is an educational repository that deconstructs core EVM concepts through inline assembly (Yul). Each module is a self-contained, heavily-tested contract demonstrating a specific low-level pattern used in production DeFi protocols.

> **Target audience:** Solidity developers preparing for security audits, gas optimization challenges, or protocol engineering roles.

---

## 📋 Содержание

- [Архитектура](#-архитектура)
- [Модули](#-модули)
- [Deep Dive](#-deep-dive)
- [Gas & Сравнение](#-gas--сравнение)
- [Быстрый старт](#-быстрый-старт)
- [Тестирование](#-тестирование)
- [Лицензия](#-лицензия)

---

# YulEVMPlayground

Интерактивный учебный репозиторий по inline assembly (Yul) в Solidity.  
Каждый модуль — это изолированная EVM-концепция, реализованная на чистом Yul с fuzz-тестами.

## Модули

| № | Название | Чему учит |
|---|----------|-----------|
| 01 | **YulProxy** | Delegatecall, EIP-1967, bubble-up revert |
| 02 | **MemoryInspector** | Layout памяти в Solidity, alignment |
| 03 | **CallDataDecoder** | Ручной парсинг ABI calldata |
| 04 | **Create2Factory** | Детерминированный деплой, CREATE2 |
| 05 | **TransientStorage** | TSTORE/TLOAD (EIP-1153), reentrancy guard |

## Установка

```bash
git clone &lt;repo&gt;
cd YulEVMPlayground
forge install
forge test -vvv
