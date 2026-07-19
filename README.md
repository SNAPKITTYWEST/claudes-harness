# Claude's Harness for Any AI Model

> A declarative Prolog identity kernel that governs any AI agent — Claude, BOB, FORGE, CARTO, or one you build tomorrow.
> Swap the adapter. The harness never changes.

Licensed under the **Sovereign Source License v1.0** — see [LICENSE](LICENSE).

---

## What It Is

Most AI model wrappers are code. This is **policy as data**.

Claude's Harness separates three things that every AI deployment conflates:

| Layer | What it answers | Where it lives |
|-------|----------------|----------------|
| **Identity** | Who is this agent? What can it do? | `core/identity.pl` |
| **Harness** | How do we query and audit it? | `core/harness.pl` |
| **Adapter** | Remapped identity for a different model | `adapters/*.pl` |

The harness is a Prolog runtime. The identity is just facts. You swap the facts — the entire governance model resets automatically, with zero code changes.

---

## Why Prolog

Prolog is the right tool because:

- **Policy is logic, not if/else** — `permitted(X) :- \+ prohibited_action(X)` is a theorem, not a branch
- **Auditable** — `harness_report/0` dumps complete agent state in one call
- **Declarative** — you define what is true; the engine figures out what follows
- **No runtime surprises** — closed-world assumption means unknown = denied

---

## Structure

```
core/
  identity.pl       Claude default — persona, principles, constraints, competencies
  harness.pl        Runtime API — can_run/2, harness_report/0, audit_*/0

adapters/
  bob.pl            BOB sovereign runtime adapter
  README.md         How to write your own adapter

tests/
  test_harness.pl   plunit test suite (10 tests)

LICENSE             Sovereign Source License v1.0
```

---

## Quick Start

```bash
# SWI-Prolog required
swipl -l core/harness.pl

?- harness_report.
% prints full agent state

?- can_run(configure_aws_infrastructure, devops_specialist).
% HARNESS: PERMIT  configure_aws_infrastructure / devops_specialist
% true

?- can_run(provide_medical_advice, devops_specialist).
% HARNESS: DENY    provide_medical_advice / devops_specialist
% false
```

---

## Swap to a Different Model

```bash
# BOB sovereign runtime
cp adapters/bob.pl core/identity.pl
swipl -l core/harness.pl
?- harness_report.
```

The harness doesn't care which agent is loaded. Same API. Different facts.

---

## Run Tests

```bash
swipl -g "consult('tests/test_harness.pl'), run_tests, halt."
```

---

## Write Your Own Adapter

Every adapter is a plain Prolog file with these required facts:

```prolog
persona(your_model_name).
status(active).                          % active | suspended | sandboxed

governing_principle(safety).             % one or more
prohibited_action(do_harmful_thing).     % one or more

permitted(Action) :- \+ prohibited_action(Action).

competency(your_domain).
qualified(Role) :- competency(Role).
can_execute(Task, Role) :- qualified(Role), permitted(Task).
```

Save it in `adapters/`, copy it to `core/identity.pl`, reload. Done.

---

## The Bigger Picture

This harness is part of the **SnapKitty Sovereign Stack** — a set of tools for building AI systems that are governed by math, not policy documents:

- **sovereign-array** — Lean 4 APL kernel with zero-sorry proofs
- **claudes-harness** — Prolog identity + trust layer (this repo)
- **BOB** — sovereign reasoning engine governed by this harness
- **Bifrost** — WORM-sealed audit trail, Ed25519 + Blake3

Every agent that runs on the sovereign stack loads this harness. Every action is gated. Every output is attested.

---

Built by SnapKitty West.
`snapkittywest.github.io` — Evidence or Silence — 2026
