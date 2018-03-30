% #!/usr/local/bin/swipl -q -t main,halt -s
% vi: ft=prolog
% OPTIONS:
%   -r <rev>    revision
:- use_module(library(optparse)).
:- use_module(library(process)).
:- use_module(library(error)).

:- initialization(main).

opt_spec([[
    opt(revision),
    type(integer),
    default(13107),
    shortflags([r]),
    longflags(['revision']),
    help(['revision to which you want your vim upgraded'])
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
    getArg(revision(X)),
    goto_vim_dir,
    update_local_repo(X),
    remove_config_cache,
    configure,
    make_install,
    nl.

%! @param {Term}
getArg(Term) :-
    % trace,
    current_prolog_flag(argv, Argv),
    process_create(path(echo), ['Argv ', Argv], []),
    opt_spec(OptsSpec),
    opt_parse(OptsSpec, Argv, ParsedOpts, _),
    member(Term, ParsedOpts).

goto_vim_dir :-
    getenv('HOME', HOME),
    atomic_list_concat([HOME, repos, vim], /, Path),
    working_directory(_, Path).

update_local_repo(X) :-
    must_be(positive_integer, X),
    process_create(path(hg), ['pull'], []),
    process_create(path(echo), ['updating to revision ', X], []),
    process_create(path(hg), ['update', '-r', X], []).

remove_config_cache :-
    process_create(path(rm), ['-f', 'src/auto/config.cache'], []).

configure :-
    machine_type(MT),
    findall(Config, buildconfig(MT, Config), Configs),
    % process_create(path(echo), Configs, []),
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
