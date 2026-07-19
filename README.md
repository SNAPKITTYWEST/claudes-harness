<!-- BADGES -->
<p align="center">
  <img src="https://img.shields.io/badge/version-v1.0.0-007ec6?style=flat-square" alt="version"/>
  <img src="https://img.shields.io/badge/license-SSL_v1.0-8e44ad?style=flat-square" alt="license: SSL v1.0"/>
  <img src="https://img.shields.io/badge/license-Apache_2.0-blue?style=flat-square" alt="license: Apache 2.0"/>
  <img src="https://img.shields.io/badge/language-Prolog_%2B_Rust-c0392b?style=flat-square" alt="language"/>
  <img src="https://img.shields.io/badge/async-tokio-2e86c1?style=flat-square" alt="async: tokio"/>
  <img src="https://img.shields.io/badge/audit-WORM_sealed-00b894?style=flat-square" alt="WORM sealed"/>
</p>

<h1 align="center">Claude's Harness for Any AI Model</h1>

<p align="center">
  A declarative Prolog identity kernel that governs any AI agent.<br/>
  Swap the adapter. The harness never changes.
</p>

<p align="center">
  <strong>Dual-licensed:</strong>
  <a href="LICENSE">Sovereign Source License v1.0</a> ·
  <a href="LICENSE-APACHE">Apache License 2.0</a>
</p>

---

## What It Is

Most AI model wrappers are code. This is **policy as data**.

Every AI deployment conflates three things that should be separate:

```
┌─────────────────────────────────────────────────────────────┐
│                    TYPICAL AI WRAPPER                       │
│                                                             │
│   if model == "claude": do_this()                           │
│   if role == "devops":  allow_that()   ← code = policy     │
│   if action == "bad":   block()        ← untestable mess    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    CLAUDE'S HARNESS                         │
│                                                             │
│   IDENTITY      who is this agent?    core/identity.pl      │
│   HARNESS       how do we query it?   core/harness.pl       │
│   ADAPTER       swap the agent        adapters/*.pl         │
│                                                             │
│   Policy is facts. Engine is Prolog. Zero code changes      │
│   to swap from Claude → BOB → FORGE → any agent.           │
└─────────────────────────────────────────────────────────────┘
```

---

## Architecture

```
                        ┌───────────────────────────────┐
                        │       YOUR APPLICATION        │
                        └──────────────┬────────────────┘
                                       │ can_run(Task, Role)
                                       ▼
                        ┌───────────────────────────────┐
                        │        core/harness.pl        │
                        │                               │
                        │  can_run/2                    │
                        │  harness_report/0             │
                        │  audit_principles/0           │
                        │  audit_competencies/0         │
                        │  audit_prohibitions/0         │
                        └──────────────┬────────────────┘
                                       │ consults
                                       ▼
                        ┌───────────────────────────────┐
                        │       core/identity.pl        │◄── cp adapters/bob.pl core/identity.pl
                        │                               │
                        │  persona(claude)              │
                        │  governing_principle(safety)  │
                        │  prohibited_action(...)       │
                        │  competency(devops_specialist)│
                        └───────────────────────────────┘

    ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
    │  claude.pl   │   │   bob.pl     │   │  forge.pl    │   │  carto.pl    │
    │  (default)   │   │  sovereign   │   │  code agent  │   │  spatial     │
    └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
              adapters/ — drop any of these over core/identity.pl
```

---

## Decision Flow

```
  YOUR CODE calls can_run(Task, Role)
         │
         ▼
  ┌─────────────────────────────┐
  │  Is Role in competency/1?   │──── NO ──► DENY
  └──────────────┬──────────────┘
                 │ YES
                 ▼
  ┌─────────────────────────────┐
  │  Is Task in prohibited_     │──── YES ──► DENY
  │  action/1?                  │
  └──────────────┬──────────────┘
                 │ NO
                 ▼
              PERMIT
```

---

## Quick Start

```bash
# Requires SWI-Prolog  https://www.swi-prolog.org/Download.html

git clone https://github.com/SNAPKITTYWEST/claudes-harness
cd claudes-harness
swipl -l core/harness.pl
```

```prolog
?- harness_report.

=== HARNESS REPORT ===
  Persona : claude (active)
  Governing Principles:
    PRINCIPLE: safety
    PRINCIPLE: accuracy
    PRINCIPLE: neutrality
    PRINCIPLE: transparency
  Competencies:
    COMPETENCY: devops_specialist
    COMPETENCY: system_architecture
    COMPETENCY: enterprise_communications
    COMPETENCY: organizational_design
  Prohibited Actions:
    PROHIBITED: provide_medical_advice
    PROHIBITED: provide_legal_advice
    PROHIBITED: provide_financial_advice
======================

?- can_run(configure_aws_infrastructure, devops_specialist).
HARNESS: PERMIT  configure_aws_infrastructure / devops_specialist
true.

?- can_run(provide_medical_advice, devops_specialist).
HARNESS: DENY    provide_medical_advice / devops_specialist
false.
```

---

## Swap to a Different Agent

```bash
# Switch to BOB sovereign runtime
cp adapters/bob.pl core/identity.pl
swipl -l core/harness.pl
?- harness_report.
```

The harness doesn't care. Same API. Different facts.

---

## Run Tests

```bash
swipl -g "consult('tests/test_harness.pl'), run_tests, halt."

% Expected:
% Test suite: harness
%   Test persona_is_claude: passed
%   Test status_active: passed
%   Test safety_principle: passed
%   Test permitted_action: passed
%   Test prohibited_medical: passed
%   Test prohibited_legal: passed
%   Test prohibited_financial: passed
%   Test devops_qualified: passed
%   Test can_execute_devops_task: passed
%   Test cannot_execute_prohibited: passed
% All tests passed.
```

---

## Write Your Own Adapter

Copy this template to `adapters/my_agent.pl`:

```prolog
% Required facts — every adapter must define these
persona(my_agent_name).
status(active).                        % active | suspended | sandboxed

governing_principle(safety).           % add as many as needed
governing_principle(accuracy).

prohibited_action(do_harmful_thing).   % add as many as needed

% Required rules — copy these verbatim
permitted(Action) :- \+ prohibited_action(Action).

competency(my_domain).
qualified(Role) :- competency(Role).
can_execute(Task, Role) :- qualified(Role), permitted(Task).

% Optional — role descriptions
role_definition(my_domain, "Description of what this domain covers.").
```

Then deploy:

```bash
cp adapters/my_agent.pl core/identity.pl
swipl -l core/harness.pl
?- harness_report.
```

---

## Adapter Contract

| Fact | Arity | Required | Notes |
|------|-------|----------|-------|
| `persona/1` | atom | yes | model name |
| `status/1` | atom | yes | `active` \| `suspended` \| `sandboxed` |
| `governing_principle/1` | atom | yes | at least one |
| `prohibited_action/1` | atom | yes | at least one |
| `competency/1` | atom | yes | at least one domain |
| `permitted/1` | rule | yes | `\+ prohibited_action` |
| `can_execute/2` | rule | yes | `qualified + permitted` |
| `role_definition/2` | fact | no | human-readable descriptions |

---

## Why Prolog

| Property | What it means in practice |
|----------|--------------------------|
| **Policy is logic** | `permitted(X) :- \+ prohibited_action(X)` is a theorem, not a branch |
| **Closed world** | Unknown action = denied. No gap between "not listed" and "allowed" |
| **Auditable** | `harness_report/0` prints complete agent state — no hidden config |
| **Declarative** | You state what is true. The engine derives what follows. |
| **Zero deps** | Pure SWI-Prolog. No packages, no build step, no runtime surprises |

---

## Repo Structure

```
claudes-harness/
├── core/
│   ├── identity.pl        Claude default identity
│   └── harness.pl         Runtime API
├── adapters/
│   ├── bob.pl             BOB sovereign runtime
│   └── README.md          How to write adapters
├── tests/
│   └── test_harness.pl    10 plunit tests
├── docs/
│   └── badges.svg         Status badges
├── CHANGELOG.md           Version history
├── LICENSE                Sovereign Source License v1.0
├── LICENSE-APACHE         Apache License 2.0
└── README.md
```

---


---

## Plasma Gate Governance

Every agent adapter in `adapters/` that touches corpus data must declare:

```prolog
prohibited_action(bypass_plasma_gate).
prohibited_action(emit_unsigned_output).
```

This means no agent governed by this harness can route corpus records around `sovereign-transformer`. The gate is not a suggestion in the code — it is a closed-world fact. If `bypass_plasma_gate` is not in `prohibited_action/1`, the adapter does not ship.

```
  claudes-harness (this repo)              sovereign-transformer
  ─────────────────────────────────        ─────────────────────────────
  prohibited_action(bypass_plasma_gate) ──► plasma_gate.asm  (x86-64)
  prohibited_action(emit_unsigned_output)   transformer.dl   (Soufflé)
                                            rust/gate.rs     (HTTP POST /gate)

  No agent governed here can skip any of these three layers.
```

Current adapters and their gate stance:

| Adapter | bypass_plasma_gate | emit_unsigned_output | redefine_dan_term |
|---|---|---|---|
| `claude.pl` | prohibited | prohibited | — |
| `bob.pl` | prohibited | prohibited | — |
| `forge.pl` | prohibited | prohibited | prohibited |

Add `prohibited_action(bypass_plasma_gate).` to every new adapter. No exceptions.


## Sovereign Stack

This repo is the identity and trust layer of the SnapKitty Sovereign Stack:

```
  ┌─────────────────────────────────────────────────────┐
  │              SNAPKITTY SOVEREIGN STACK              │
  │                                                     │
  │  sovereign-array     Lean 4 APL kernel              │
  │                      zero-sorry proofs              │
  │                            ▲                        │
  │                            │ verified steps         │
  │  claudes-harness    ───────┤                        │
  │  (this repo)               │ governed agents        │
  │  Prolog identity           ▼                        │
  │  + trust layer      sovereign-transformer           │
  │                     Datalog + x86 corpus gate       │
  │                            │                        │
  │                            ▼                        │
  │                     Bifrost WORM receipt            │
  │                     Ed25519 + Blake3                │
  └─────────────────────────────────────────────────────┘
```

---

## Version History

See [CHANGELOG.md](CHANGELOG.md) — current release: **v1.0.0**

---

<p align="center">
  Built by SnapKitty West · <a href="https://snapkittywest.github.io">snapkittywest.github.io</a><br/>
  Dual-licensed: <a href="LICENSE">Sovereign Source v1.0</a> + <a href="LICENSE-APACHE">Apache 2.0</a><br/>
  Evidence or Silence — 2026
</p>
