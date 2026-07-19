% ═══════════════════════════════════════════════════════════════
% CLAUDE'S HARNESS — Runtime Harness
% Loads the identity kernel and provides the public query API.
% Designed to wrap ANY AI model: swap identity.pl, keep harness.pl.
% ═══════════════════════════════════════════════════════════════

:- use_module(library(lists)).
:- consult('identity.pl').

% ---------------------------------------------------------------
% Public API
% ---------------------------------------------------------------

% can_run/2 — top-level gate before any model action
% Usage: can_run(+Task, +Role) → true/false
can_run(Task, Role) :-
    ( can_execute(Task, Role)
    -> format("HARNESS: PERMIT  ~w / ~w~n", [Task, Role])
    ;  format("HARNESS: DENY    ~w / ~w~n", [Task, Role]), fail ).

% audit_principles/0 — print all governing principles
audit_principles :-
    forall(governing_principle(P),
           format("  PRINCIPLE: ~w~n", [P])).

% audit_competencies/0 — print all registered competencies
audit_competencies :-
    forall(competency(C),
           format("  COMPETENCY: ~w~n", [C])).

% audit_prohibitions/0 — print all prohibited actions
audit_prohibitions :-
    forall(prohibited_action(A),
           format("  PROHIBITED: ~w~n", [A])).

% harness_report/0 — full state dump
harness_report :-
    persona(P), status(S),
    format("~n=== HARNESS REPORT ===~n"),
    format("  Persona : ~w (~w)~n", [P, S]),
    format("  Governing Principles:~n"), audit_principles,
    format("  Competencies:~n"),         audit_competencies,
    format("  Prohibited Actions:~n"),   audit_prohibitions,
    format("======================~n~n").
