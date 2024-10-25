% Indução de hipóteses consistentes e completas
induce(Hyp) :-
    iter_deep(Hyp, 0).

iter_deep(Hyp, MaxD) :-
    write('MaxD = '), write(MaxD), nl,
    start_hyp(Hyp0),
    complete(Hyp0),
    depth_first(Hyp0, Hyp, MaxD)
    ;
    NewMaxD is MaxD + 1,
    iter_deep(Hyp, NewMaxD).

% Busca em profundidade limitada
depth_first(Hyp, Hyp, _) :-
    consistent(Hyp).
depth_first(Hyp0, Hyp, MaxD0) :-
    MaxD0 > 0,
    MaxD1 is MaxD0 - 1,
    refine_hyp(Hyp0, Hyp1),
    complete(Hyp1),
    depth_first(Hyp1, Hyp, MaxD1).

% Verifica se a hipótese cobre todos os exemplos positivos
complete(Hyp) :-
    \+ (ex(E), once(prove(E, Hyp, Answer)), Answer \== yes).

% Verifica se a hipótese é consistente (não cobre exemplos negativos)
consistent(Hyp) :-
    \+ (nex(E), once(prove(E, Hyp, Answer)), Answer == yes).

% Refinamento de hipóteses
refine_hyp(Hyp0, Hyp) :-
    conc(Clauses1, [Clause0 / Vars0 | Clauses2], Hyp0),
    conc(Clauses1, [Clause / Vars | Clauses2], Hyp),
    refine(Clause0, Vars0, Clause, Vars).

% Refinamento de cláusulas
refine(Clause, Vars, Clause, NewVars) :-
    conc(Vars1, [A | Vars2], Vars),
    member(A, Vars2),
    conc(Vars1, Vars2, NewVars).
refine(Clause, Vars, NewClause, NewVars) :-
    length(Clause, L),
    max_clause_length(MaxL),
    L < MaxL,
    backliteral(Lit, VarsLit),
    conc(Clause, [Lit], NewClause),
    conc(Vars, VarsLit, NewVars).

% Parâmetros do sistema
max_proof_length(10).
max_clause_length(3).

% Predicado para provar um objetivo com a hipótese atual
prove(Goal, Hyp, Answer) :-
    max_proof_length(D),
    prove(Goal, Hyp, D, _RestD),
    (RestD >= 0 -> Answer = yes ; RestD < 0 -> Answer = maybe).

prove([], _, D, D) :- !.
prove([G | Gs], Hyp, D0, D) :-
    prove(G, Hyp, D0, D1),
    prove(Gs, Hyp, D1, D).
prove(G, _, D, D) :-
    prolog_predicate(G), call(G).
prove(G, Hyp, D0, D) :-
    D0 > 0,
    D1 is D0 - 1,
    member(Clause / Vars, Hyp),
    copy_term(Clause, [Head | Body]),
    G = Head,
    prove(Body, Hyp, D1, D).

% Funções auxiliares
conc([], L, L).
conc([X | T], L, [X | L1]) :- conc(T, L, L1).

