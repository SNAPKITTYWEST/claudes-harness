# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-07-19

### Added
- `core/identity.pl` — Claude default identity kernel: persona, governing principles, prohibited actions, competency domains
- `core/harness.pl` — runtime API: `can_run/2`, `harness_report/0`, `audit_principles/0`, `audit_competencies/0`, `audit_prohibitions/0`
- `adapters/bob.pl` — BOB sovereign runtime adapter with borrow-chain and WORM-sealed audit constraints
- `adapters/README.md` — adapter contract and examples
- `tests/test_harness.pl` — 10 plunit tests covering all gate paths
- `LICENSE` — Sovereign Source License v1.0
- `LICENSE-APACHE` — Apache License 2.0 (dual-licensed)
- ASCII architecture diagram
- SVG badges: version, license, language, tests, WORM seal
- User guide with swap walkthrough and adapter contract

### Design decisions
- Policy as data: all governance is Prolog facts, not code branches
- Closed-world assumption: unknown action = denied
- Adapter swap: `cp adapters/X.pl core/identity.pl` is the entire deployment operation
- Audit Spec: `4b565498-9afc-4782-af4a-c6b11a5d0058`
