<!-- ═══════════════════════════════════════════════════════════════ -->
<!--                        BANNER ZONE                            -->
<!-- ═══════════════════════════════════════════════════════════════ -->
<p align="center">
  <img src="https://raw.githubusercontent.com/your-username/YulEVMPlayground/main/assets/banner.png" width="100%" alt="YulEVMPlayground Banner">
</p>

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

<p align="center">
  <a href="https://github.com/your-username/YulEVMPlayground/stargazers">
    <img src="https://img.shields.io/github/stars/your-username/YulEVMPlayground?style=social&logo=github" alt="Stars">
  </a>
  <a href="https://twitter.com/your-handle">
    <img src="https://img.shields.io/twitter/follow/your-handle?style=social&logo=x" alt="Twitter">
  </a>
</p>

<!-- ═══════════════════════════════════════════════════════════════ -->
<!--                        TITLE ZONE                             -->
<!-- ═══════════════════════════════════════════════════════════════ -->
<h1 align="center">
  <img src="https://raw.githubusercontent.com/your-username/YulEVMPlayground/main/assets/logo.png" width="48" alt="logo" style="vertical-align: middle;">
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

<!-- ═══════════════════════════════════════════════════════════════ -->
<!--                        OVERVIEW                               -->
<!-- ═══════════════════════════════════════════════════════════════ -->
## 📌 Overview

**YulEVMPlayground** is an educational repository that deconstructs core EVM concepts through inline assembly (Yul). Each module is a self-contained, heavily-tested contract demonstrating a specific low-level pattern used in production DeFi protocols.

> **Target audience:** Solidity developers preparing for security audits, gas optimization challenges, or protocol engineering roles.

---

<!-- ═══════════════════════════════════════════════════════════════ -->
<!--                        ARCHITECTURE                             -->
<!-- ═══════════════════════════════════════════════════════════════ -->
## 🏗️ Architecture

```mermaid
%%{init: {'theme': 'dark', 'themeVariables': { 'primaryColor': '#2b4c7e', 'primaryTextColor': '#fff', 'primaryBorderColor': '#1a1a1a', 'lineColor': '#4a90d9', 'secondaryColor': '#1a1a1a', 'tertiaryColor': '#363636'}}}%%
flowchart TB
    subgraph Input["📥 Input Layer"]
        CD[Calldata<br/>04_CallDataDecoder]
    end
    
    subgraph Processing["⚙️ Processing Layer"]
        MEM[Memory<br/>03_MemoryInspector]
        TS[Transient Storage<br/>06_TransientStorage]
    end
    
    subgraph Execution["🚀 Execution Layer"]
        PROXY[Proxy<br/>02_ProxyYul]
        C2[Factory<br/>05_Create2Factory]
    end
    
    CD --> MEM
    MEM --> PROXY
    MEM --> C2
    TS --> PROXY
    
    style CD fill:#2b4c7e,stroke:#4a90d9,stroke-width:2px,color:#fff
    style MEM fill:#2b4c7e,stroke:#4a90d9,stroke-width:2px,color:#fff
    style TS fill:#2b4c7e,stroke:#4a90d9,stroke-width:2px,color:#fff
    style PROXY fill:#1a1a1a,stroke:#4a90d9,stroke-width:2px,color:#fff
    style C2 fill:#1a1a1a,stroke:#4a90d9,stroke-width:2px,color:#fff
