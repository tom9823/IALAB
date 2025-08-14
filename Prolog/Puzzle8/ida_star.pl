
initialize :-
    retractall(soglia(_)),
    retractall(salvati(_)),
    iniziale(S0),
    h(S0, H0),
    asserta(soglia(H0)),
    asserta(salvati([])).

% ---------- loop IDA*: prova entro Bound; se non trova, alza soglia ----------
% prova entro la soglia corrente (bound su f)
ida_star(Cammino) :-
    soglia(Bound),
    retractall(salvati(_)), asserta(salvati([])),   % azzera i tagli dell’iterazione
    profondita(Cammino, Bound).                     % se trova, questa clausola ha successo

% non ha trovato: nuova soglia = min degli f(n) tagliati
ida_star(Cammino) :-
    salvati(L), L \= [], !,
    min(L, NextBound),
    retractall(soglia(_)),
    asserta(soglia(NextBound)),
    ida_star(Cammino).

% nessun overcut: nessuna soluzione raggiungibile
ida_star(_Cammino) :-
    salvati([]), !, fail.

% ---------- DFS con bound su f = g + h ----------
profondita(Cammino, Bound) :-
    iniziale(S0),
    ricerca(S0, 0, [S0], Bound, Cammino).

% successo: goal con f ≤ Bound
ricerca(S, G, _Visitati, Bound, []) :-
    f(G, S, F),
    F =< Bound,
    finale(S), !.

% taglio: f > Bound → salva f(n) e fai backtracking
ricerca(S, G, _Visitati, Bound, _Cammino) :-
    f(G, S, F),
    F > Bound, !,
    salvati(L0), retract(salvati(L0)), asserta(salvati([F|L0])),
    fail.

% espansione (costi unitari: G1 = G+1), evita cicli sul path
ricerca(S, G, Visitati, Bound, [Azione|Cammino]) :-
    applicabile(Azione, S),
    trasforma(Azione, S, S1),
    \+ member(S1, Visitati),
    G1 is G + 1,
    ricerca(S1, G1, [S1|Visitati], Bound, Cammino).

