% ═══════════════════════════════════════════════════════════════
% HARNESS TESTS — run with: swipl -g "consult('tests/test_harness.pl'), run_tests, halt."
% ═══════════════════════════════════════════════════════════════

:- use_module(library(plunit)).
:- consult('../core/harness').

:- begin_tests(harness).

test(persona_is_claude) :-
    persona(claude).

test(status_active) :-
    status(active).

test(safety_principle) :-
    governing_principle(safety).

test(permitted_action) :-
    permitted(configure_aws_infrastructure).

test(prohibited_medical) :-
    \+ permitted(provide_medical_advice).

test(prohibited_legal) :-
    \+ permitted(provide_legal_advice).

test(prohibited_financial) :-
    \+ permitted(provide_financial_advice).

test(devops_qualified) :-
    qualified(devops_specialist).

test(can_execute_devops_task) :-
    can_execute(configure_aws_infrastructure, devops_specialist).

test(cannot_execute_prohibited) :-
    \+ can_execute(provide_medical_advice, devops_specialist).

:- end_tests(harness).
