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

&lt;!-- Banner --&gt;
&lt;p align="center"&gt;
  &lt;img src="https://img.shields.io/badge/Solidity-^0.8.26-363636?logo=solidity&logoColor=white" /&gt;
  &lt;img src="https://img.shields.io/badge/Yul-Inline%20Assembly-2b4c7e" /&gt;
  &lt;img src="https://img.shields.io/badge/Foundry-Test%20Suite-ffcfcf?logo=ethereum&logoColor=black" /&gt;
  &lt;img src="https://img.shields.io/badge/EVM-Cancun-3c3c3c" /&gt;
  &lt;img src="https://img.shields.io/badge/License-MIT-green.svg" /&gt;
&lt;/p&gt;

&lt;h1 align="center"&gt;YulEVMPlayground&lt;/h1&gt;
&lt;p align="center"&gt;
  &lt;b&gt;Пять низкоуровневых модулей EVM, написанных на чистом Yul.&lt;/b&gt;&lt;br&gt;
  &lt;i&gt;Без &lt;code&gt;abi.encode&lt;/code&gt;. Без скрытых &lt;code&gt;SSTORE&lt;/code&gt;. Только ты, стек и опкоды.&lt;/i&gt;
&lt;/p&gt;

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

## 🗺️ Архитектура

Каждый модуль — это изолированный срез EVM: от `calldata` до `transient storage`.

```mermaid
mindmap
  root((YulEVMPlayground))
    CallData
      CallDataDecoder[04_CallDataDecoder&lt;br/&gt;Ручной парсинг ABI]
    Memory
      MemoryInspector[03_MemoryInspector&lt;br/&gt;Layout & Alignment]
    Storage
      ProxyYul[02_ProxyYul&lt;br/&gt;EIP-1967 DELEGATECALL]
    Transient
      TransientStorage[06_TransientStorage&lt;br/&gt;EIP-1153 TSTORE/TLOAD]
    Deployment
      Create2Factory[05_Create2Factory&lt;br/&gt;Deterministic CREATE2]
