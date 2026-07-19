# Claude's Harness for Any AI Model

A Prolog identity kernel that wraps **any AI model** with trust axioms, behavioral constraints, and competency domains.

Swap the adapter. Keep the harness. The same runtime governs Claude, BOB, FORGE, CARTO — any agent.

---

## Structure

```
core/
  identity.pl   — default identity (Claude)
  harness.pl    — runtime API (can_run, audit_*, harness_report)
adapters/
  bob.pl        — BOB sovereign runtime adapter
  README.md     — how to write your own adapter
tests/
  test_harness.pl
```

---

## Quick Start

```prolog
% SWI-Prolog
swipl -l core/harness.pl

?- harness_report.
?- can_run(configure_aws_infrastructure, devops_specialist).
?- can_run(provide_medical_advice, devops_specialist).
```

---

## Swap to BOB

```bash
cp adapters/bob.pl core/identity.pl
swipl -l core/harness.pl
?- harness_report.
```

---

## Run Tests

```bash
swipl -g "consult('tests/test_harness.pl'), run_tests, halt."
```

---

## Adapter Contract

Every `identity.pl` must define:

| Fact | Arity | Purpose |
|------|-------|---------|
| `persona/1` | atom | model name |
| `status/1` | atom | active / suspended / sandboxed |
| `governing_principle/1` | atom | trust axiom |
| `prohibited_action/1` | atom | hard constraint |
| `competency/1` | atom | domain capability |
| `permitted/1` | rule | `\+ prohibited_action` |
| `can_execute/2` | rule | `qualified + permitted` |

---

## Design

- **No external dependencies** — pure SWI-Prolog
- **Declarative** — policy is data, not code
- **Auditable** — `harness_report/0` dumps full state
- **Model-agnostic** — persona is a fact, not a hardcoded string

Built by SnapKitty West. Audit spec: 4b565498-9afc-4782-af4a-c6b11a5d0058.
