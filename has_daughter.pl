% Exemplos positivos (ex/1)
ex(has_daughter(pam, liz)).
ex(has_daughter(tom, ann)).
ex(has_daughter(tom, liz)).

% Exemplos negativos (nex/1)
nex(has_daughter(bob, liz)).
nex(has_daughter(pat, bob)).
nex(has_daughter(pam, jim)).

% Relações de parentesco (parent/2)
parent(pam, liz).
parent(tom, liz).
parent(tom, ann).
parent(bob, pat).
parent(pat, eve).

% Pessoas do gênero feminino (female/1)
female(liz).
female(ann).
female(pat).
female(eve).

% Literais de conhecimento de fundo
backliteral(parent(X, Y), [parent(X, Y)]).
backliteral(female(Y), [female(Y)]).

% Hipótese inicial para has_daughter/2
start_hyp([
    [has_daughter(X, Y)] / [X, Y]
]).

% Indução de hipóteses
induce(Hyp) :-
    iter_deep(Hyp, 0),
    format('Hipótese aprendida: ~w~n', [Hyp]).

% Busca iterativa em profundidade
iter_deep(Hyp, MaxD) :-
    write('MaxD = '), write(MaxD), nl,
    start_hyp(Hyp0),
    complete(Hyp0),
    depth_first(Hyp0, Hyp, MaxD)
    ;
    NewMaxD is MaxD + 1,
    iter_deep(Hyp, NewMaxD).

% Busca em profundidade limitada
depth_first(Hyp, Hyp, _) :- consistent(Hyp).
depth_first(Hyp0, Hyp, MaxD0) :-
    MaxD0 > 0,
    MaxD1 is MaxD0 - 1,
    refine_hyp(Hyp0, Hyp1),
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

% Refinamento de cláusulas
refine(Clause, Vars, [Lit | Clause], NewVars) :-
    length(Clause, L),
    max_clause_length(MaxL),
    L < MaxL,
    backliteral(Lit, VarsLit),
    append(Vars, VarsLit, NewVars).

% Prova de hipóteses
prove([], _, yes).
prove([G | Gs], Hyp, Answer) :-
    (   member(Clause / Vars, Hyp),
        copy_term(Clause, [Head | Body]),
        G = Head,
        prove(Body, Hyp, yes)
    ->  prove(Gs, Hyp, Answer)
    ;   Answer = no).

% Função de consulta usando a hipótese aprendida
has_daughter_query(X, Y) :-
    induce(Hyp),  % Induz a hipótese
    prove([has_daughter(X, Y)], Hyp, Answer),
    (Answer = yes -> true ; false).

% Concatenação de listas
append([], L, L).
append([X | T], L, [X | L1]) :- append(T, L, L1).

% Parâmetros de controle
max_proof_length(10).
max_clause_length(3).

