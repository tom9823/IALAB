initialize :-
    retractall(soglia(_)),
    retractall(salvati(_)),
    iniziale(S0),
    h(S0, H0),
    asserta(soglia(H0)),
    asserta(salvati([])).

% prova entro la soglia corrente (bound su f)
ida_star(Cammino) :-
    soglia(Bound),
    retractall(salvati(_)), asserta(salvati([])),  
    profondita(Cammino, Bound).                     


% se non ha trovato: nuova soglia = min degli f(n) tagliati
ida_star(Cammino) :-
    salvati(L), 
    L \= [], !,                        
    min(L, NextBound),
    retractall(soglia(_)),
    asserta(soglia(NextBound)),
    ida_star(Cammino).

ida_star(Cammino) :-
    salvati([]), !, fail.

profondita(Cammino, Bound) :-
    iniziale(S0),
    ricerca(S0, 0, [S0], Bound, Cammino).

% --- RICERCA DFS con bound su f = g + h ---

% Successo: goal con f <= Bound
ricerca(S, G, _Visitati, Bound, []) :-
    f(G, S, F),
    F =< Bound,
    finale(S), !.

% Taglio: f > Bound -> salva f(n) e fallisci per backtracking
ricerca(S, G, _Visitati, Bound, _Cammino) :-
    f(G, S, F),
    F > Bound, !,
    salvati(L0),
    retract(salvati(L0)),
    asserta(salvati([F|L0])),
    fail.

% Espansione normale (costi unitari: G1 = G+1)
ricerca(S, G, Visitati, Bound, [Azione|Cammino]) :-
    applicabile(Azione, S),
    trasforma(Azione, S, S1),
    \+ member(S1, Visitati),
    G1 is G + 1,
    ricerca(S1, G1, [S1|Visitati], Bound, Cammino).

% f(G,S) = g + h
f(G, S, F) :- h(S, H), F is G + H.

distanza_manhattan(pos(Xi,Yi), pos(Xf,Yf), Ris) :- DeltaX is abs(Xi-Xf), DeltaY is abs(Yi-Yf), Ris is DeltaX + DeltaY.

% conta quante finali/1 sono definite
conta_finali(N) :-
    conta_finali_acc([], 0, N).

conta_finali_acc(Visti, Acc, N) :-
    finale(F),
    \+ member(F, Visti), !,
    Acc1 is Acc + 1,
    conta_finali_acc([F|Visti], Acc1, N).
conta_finali_acc(_, Acc, Acc).

% euristica h(S,H): minima Manhattan verso la finale più vicina
h(S, 0) :-
    finale(S), !.

h(S, H) :-
    conta_finali(N), N > 0,
    mia_h(S, [], N, _, H), !.

% mia_h(S, Visti, N, Best0, Best):
%   visita N finali non ancora viste, aggiornando il migliore (minimo)
mia_h(_, _, 0, Best, Best) :- nonvar(Best), !.
mia_h(S, Visti, N, Best0, Best) :-
    finale(F),
    \+ member(F, Visti), !,
    distanza_manhattan(S, F, D),
    update_best(Best0, D, Best1),
    N1 is N - 1,
    mia_h(S, [F|Visti], N1, Best1, Best).

% aggiorna il minimo corrente
update_best(B0, D, D) :- var(B0), !.
update_best(B0, D, D) :- number(B0), D < B0, !.
update_best(B0, _, B0).

min([], _):- !,false.
min([Head | Tail], Ris) :- Tail = [], !, Ris is Head.
min([Head | Tail],Ris) :- min_acc(Tail,Head, Ris).
min_acc([Head | Tail], Min, Ris) :- Min > Head, !, min_acc(Tail, Head, Ris).
min_acc([Head | Tail], Min, Ris) :- Min =< Head, !, min_acc(Tail, Min, Ris).
min_acc([], Min, Min).