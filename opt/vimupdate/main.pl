% #!/usr/local/bin/swipl -q -t main,halt -s
% vi: ft=prolog
:- use_module(library(optparse)).
:- use_module(library(process)).
:- use_module(library(error)).

:- initialization(main).

opt_spec([[
    opt(use_current),
    type(boolean),
    shortflags([c]),
    longflags(['use-current']),
    default(false),
    help(['Use current repository code and do not get the latest'])
], [
    opt(quiet),
    type(boolean),
    shortflags([q])
], [
    opt(toplevelGoal),
    type(atom),
    shortflags([t])
], [
    opt(script),
    type(atom),
    shortflags([s])
]]).

main :- catch(body, E, print_message(error, E)), halt.

body :-
    getArg(use_current(X)),
    goto_vim_dir,
    ( X -> true ; update_local_repo),
    remove_config_cache,
    configure,
    make_install,
    nl.

%! @param {Term}
getArg(Term) :-
    current_prolog_flag(argv, Argv),
    opt_spec(OptsSpec),
    opt_parse(OptsSpec, Argv, ParsedOpts, _),
    member(Term, ParsedOpts).

goto_vim_dir :-
    getenv('HOME', HOME),
    atomic_list_concat([HOME, repos, vim], /, Path),
    working_directory(_, Path).

update_local_repo :-
    process_create(path(git), ['checkout', 'master'], []),
    process_create(path(git), ['pull'], []),
    latest_vim_version(LatestTag),
    process_create(path(git), ['checkout', LatestTag], []).

latest_vim_version(LatestTag) :-
    process_create(path(git), ['tag'], [stdout(pipe(Out))]),
    read_lines(Out, Lines),
    append(_, [LatestTag], Lines),
    close(Out).

read_lines(Out, Lines) :-
    read_line_to_codes(Out, Line1),
    read_lines(Line1, Out, Lines).
read_lines(end_of_file, _, []) :- !.
read_lines(Codes, Out, [Line|Lines]) :-
    atom_codes(Line, Codes),
    read_line_to_codes(Out, Line2),
    read_lines(Line2, Out, Lines).

remove_config_cache :-
    process_create(path(rm), ['-f', 'src/auto/config.cache'], []).

configure :-
    machine_type(MT),
    findall(Config, buildconfig(MT, Config), Configs),
    process_create(configure, Configs, []).

machine_type(M) :-
    current_prolog_flag(arch, Arch),
    ( sub_atom(Arch, _, _, _, 'darwin') -> M = mac ; M = unix ), !.

make_install :-
    process_create(path(make), [], []),
    process_create(path(sudo), ['make', 'install'], []).

buildconfig(_,    '--with-features=normal').
buildconfig(_,    '--enable-rubyinterp').
buildconfig(_,    '--enable-pythoninterp').
buildconfig(_,    '--enable-luainterp').
buildconfig(_,    '--enable-multibyte').

buildconfig(unix, '--enable-gui=gtk2').
buildconfig(unix, '--with-x').

buildconfig(mac,  '--disable-gui').
buildconfig(mac,  Prefix) :-
    process_create(path(brew), ['--prefix'], [stdout(pipe(Out))]),
    read_line_to_codes(Out, Codes),
    atom_chars(PrefixAtom, Codes),
    atomic_concat('--prefix=', PrefixAtom, Prefix).
buildconfig(mac,  LuaPrefix) :-
    process_create(path(brew), ['--prefix'], [stdout(pipe(Out))]),
    read_line_to_codes(Out, Codes),
    atom_chars(PrefixAtom, Codes),
    atomic_concat('--with-lua-prefix=', PrefixAtom, LuaPrefix).
