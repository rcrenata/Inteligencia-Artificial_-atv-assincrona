% Exemplos positivos (ex/1)
ex(even([])).
ex(even([a, b])).
ex(even([a, b, c, d])).

ex(odd([a])).
ex(odd([a, b, c])).
ex(odd([a, b, c, d, e])).

% Exemplos negativos (nex/1)
nex(even([a])).
nex(even([a, b, c])).
nex(odd([])).
nex(odd([a, b])).

% Predicados auxiliares para verificar paridade
is_even(L) :- length(L, N), N mod 2 =:= 0.
is_odd(L) :- length(L, N), N mod 2 =:= 1.

% Literais de conhecimento de fundo
backliteral(is_even(L), [L]).
backliteral(is_odd(L), [L]).

% Hipótese inicial para odd/1 e even/1
start_hyp([
    [even(L)] / [L],
    [odd(L)] / [L]
]).

% Indução de hipóteses
induce(Hyp) :-
    iter_deep(Hyp, 0),
    format('Hipótese aprendida: ~w~n', [Hyp]).

% Busca iterativa com limite de profundidade
iter_deep(Hyp, MaxD) :-
    format('MaxD = ~w~n', [MaxD]),
    start_hyp(Hyp0),
    complete(Hyp0),
    depth_first(Hyp0, Hyp, MaxD),
    !.  % Evitar backtracking infinito
iter_deep(Hyp, MaxD) :-
    NewMaxD is MaxD + 1,
    iter_deep(Hyp, NewMaxD).

% Refinamento e busca em profundidade limitada
depth_first(Hyp, Hyp, _) :- consistent(Hyp).
depth_first(Hyp0, Hyp, MaxD0) :-
    MaxD0 > 0,
    MaxD1 is MaxD0 - 1,
    refine_hyp(Hyp0, Hyp1),
    format('Refinando para: ~w~n', [Hyp1]),
    complete(Hyp1),
    depth_first(Hyp1, Hyp, MaxD1).

% Verificação de completude e consistência
complete(Hyp) :-
    \+ (ex(E), once(prove(E, Hyp, yes))).

consistent(Hyp) :-
    \+ (nex(E), once(prove(E, Hyp, no))).

% Refinamento de hipóteses
refine_hyp(Hyp0, Hyp) :-
    select(Clause0 / Vars0, Hyp0, Rest),
    refine(Clause0, Vars0, NewClause, NewVars),
    Hyp = [NewClause / NewVars | Rest].

% Refinamento de cláusulas com literais de paridade
refine(Clause, Vars, [Lit | Clause], NewVars) :-
    length(Clause, L),
    max_clause_length(MaxL),
    L < MaxL,
    backliteral(Lit, VarsLit),
    append(Vars, VarsLit, NewVars).

% Prova de hipóteses com verificação explícita de paridade
prove([], _, yes).
prove([G | Gs], Hyp, Answer) :-
    (   member(Clause / Vars, Hyp),
        copy_term(Clause, [Head | Body]),
        G = Head,
        verify_parity(Head),  % Verifica a paridade explicitamente
        prove(Body, Hyp, yes)
    ->  prove(Gs, Hyp, Answer)
    ;   Answer = no).

% Verificação explícita de paridade
verify_parity(even(L)) :- is_even(L).
verify_parity(odd(L)) :- is_odd(L).

% Consulta com a hipótese aprendida
odd_even_query(L, Type) :-
    induce(Hyp),  % Induz a hipótese
    ( Type = odd -> prove([odd(L)], Hyp, yes)
    ; Type = even -> prove([even(L)], Hyp, yes)
    ).

% Função de concatenação de listas
append([], L, L).
append([X | T], L, [X | L1]) :- append(T, L, L1).

% Parâmetros de controle
max_proof_length(10).
max_clause_length(3).

