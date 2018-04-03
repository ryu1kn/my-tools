% tools.pl
:- module(tools, [
        if_then/2,

        atom_suffix/2,
        atom_surround/2,

        file_open/3,
        file_each_line/2,
        % file_open_old/3,
        % file_each_line_old/2,

        trim/2,
        trim_codes/2,
        repeat_string/3,
        compare_lexic/3,

        parse_cmd_args/1,
        opt_arg/2,
        pos_arg/2
    ]).

:- use_module(library(lambda)).

if_then(Condition, Then) :- Condition, !, Then.
if_then(_, _).

atom_suffix(A, B) :- sub_atom(A, _, _, 0, B).

atom_surround(A, B) :- atom_prefix(A, B), atom_suffix(A, B).

% atom_wrap(A, B) :-
%     atom_prefix(A, B),
%     atom_codes(B, B_cd),
%     reverse(B_cd, B_cd_rvs),
%     atom_codes(B_rvs, B_cd_rvs),
%     atom_suffix(A, B_rvs).

%
% Clauses for wrapping a whole programme
%
% main_wrap(Main) :-
%     catch(Main, E, print_message(error, E)), halt.

%
% Clauses for file read/write
%
file_open(FileName, Mode, Callback) :-
    open(FileName, Mode, Stream),
    call(Callback, Stream),
    close(Stream).

file_each_line(FileName, Callback) :-
    file_open(FileName, read, \X^each_line(X, Callback)).

each_line(InStream, Callback) :-
    repeat,
    read_line_to_codes(InStream, Codes),
    (Codes \= end_of_file ->
        call(Callback, Codes),
        fail
    ; !, true).

file_open_old(FileName, Mode, Callback) :-
    open(FileName, Mode, Stream),
    Callback =.. [_Fn, Stream|_ArgRest],
    call(Callback),
    close(Stream).

file_each_line_old(FileName, Callback) :-
    file_open_old(FileName, read, each_line_old(_, Callback)).

each_line_old(InStream, Callback) :-
    repeat,
    read_line_to_codes(InStream, Codes),
    (Codes \= end_of_file ->
        Callback =.. [_Fn, Codes|_ArgRest],
        call(Callback),
        fail
    ; !, true).


trim(X, Y) :-
    atom_codes(X, X_),
    trim_codes(X_, Y_),
    atom_codes(Y, Y_).

trim_codes(X, Y) :-
    phrase((space, trimmed(Y), space), X).

trimmed([]) --> [].
trimmed([H]) --> [H], { \+ member(H, " \t") }.
trimmed(Trimmed) --> noblank(C1), anything(Trimmed_), noblank(C2), {
        append([[C1], Trimmed_, [C2]], Trimmed)
    }.

anything([]) --> [].
anything([H|L]) --> [H], anything(L).

noblank(H) --> [H], { \+ member(H, " \t") }.

space --> " ", space.
space --> "\t", space.
space --> [].

:- begin_tests(tools).

test(trim_codes, [nondet]) :- trim_codes("", "").
test(trim_codes, [nondet]) :- trim_codes("a", "a").
test(trim_codes, [nondet]) :- trim_codes("  a", "a").
test(trim_codes, [nondet]) :- trim_codes("a   ", "a").
test(trim_codes, [nondet]) :- trim_codes("  a   ", "a").
test(trim_codes, [nondet]) :- trim_codes("  a b ", "a b").
test(trim_codes, [nondet]) :- trim_codes(" \t a  \t ", "a").

:- end_tests(tools).

repeat_string(_, 0, '') :- !.
repeat_string(X, 1,  X) :- !.
repeat_string(X, N, Xs_res) :-
    repeat_string(X, N, X, Xs_res).

repeat_string(_, 1, X,  X) :- !.
repeat_string(X, N, Xs, Xs_res) :-
    atom_concat(X, Xs, Xs2),
    N2 is N - 1,
    repeat_string(X, N2, Xs2, Xs_res).

%! compare_lexic(?Rel, +A, +B)
%! @param {Rel} either '<', '>', '='
%! @param {A} atom
%! @param {B} atom
compare_lexic(Rel, A, B) :-
    atom_codes(A, As),
    atom_codes(B, Bs),
    compare_lexic_(Rel, As, Bs).

compare_lexic_('=', [],  []).
compare_lexic_('>', [_|_], []).
compare_lexic_('<', [],  [_|_]).
compare_lexic_(Rel, [A|_], [B|_]) :- A \= B, compare(Rel, A, B).
compare_lexic_(Rel, [A|As], [A|Bs]) :- compare_lexic_(Rel, As, Bs).


%
% Clauses for command-line arguments/options parsing
%
:- dynamic opt_arg/2, pos_arg/2.

opt_spec([[
    opt(quiet),
    type(boolean),
    shortflags([q])
], [
    opt(script),
    type(atom),
    shortflags([s])
], [
    opt(extra_file_search_path),
    type(atom),
    shortflags([p])
]]).

%! parse_cmd_args(+OptSpec) is det
%! @param {Term}
parse_cmd_args(OptSpec) :-
    merge_opt_spec(OptSpec, NewOptSpec),
    current_prolog_flag(argv, Argv),
    opt_parse(NewOptSpec, Argv, ParsedOpts, PositionalArgs),
    save_opt_args(ParsedOpts),
    save_pos_args(PositionalArgs).

merge_opt_spec(OptSpec, NewOptSpec) :-
    opt_spec(BaseOptSpec),
    append(OptSpec, BaseOptSpec, NewOptSpec).

%! save_opt_args(+OptionalArgs) is det
save_opt_args([]).
save_opt_args([O|Os]) :-
    O =.. [P,V|_],
    asserta(opt_arg(P,V)),
    save_opt_args(Os).

%! save_pos_args(+PositionalArgs) is det
save_pos_args(V) :- save_pos_args(V, 0).

save_pos_args([], _).
save_pos_args([V|Vs], Idx) :-
    asserta(pos_arg(Idx,V)),
    Idx2 is Idx + 1,
    save_pos_args(Vs, Idx2).
