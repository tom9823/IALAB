initialize :-
    retractall(soglia(_)),
    retractall(prossimaSoglia(_)),
    iniziale(Si),
    f(0, Si, F0),              
    asserta(soglia(F0)).

% ---------- loop IDA* ----------
ida_star(Cammino) :-
    soglia(Bound),
    % reset del contenitore "next bound"
    retractall(prossimaSoglia(_)),
    asserta(prossimaSoglia(none)),
    profondita(Cammino, Bound), !.   % se trova soluzione, chiude qui

% alza la soglia se è stato salvato un overcut
ida_star(Cammino) :-
    prossimaSoglia(Next),
    number(Next), !,
    retractall(soglia(_)),
    asserta(soglia(Next)),
    ida_star(Cammino).

% nessun overcut raccolto: nessuna soluzione raggiungibile
ida_star(_) :-
    prossimaSoglia(none), !, fail.

% ---------- DFS con bound su f = g + h ----------
profondita(Cammino, Bound) :-
    iniziale(S0),
    ricerca(S0, 0, [S0], Bound, Cammino).

% goal: anche qui controllo f<=Bound per coerenza
ricerca(S, G, _Visitati, Bound, []) :-
    finale(S),
    f(G, S, F),
    F =< Bound, !.

% taglio: f>Bound -> salva e fallisci per backtracking
ricerca(S, G, _Visitati, Bound, _) :-
    f(G, S, F),
    F > Bound, !,
    salva(F),
    fail.

% espansione
ricerca(S, G, Visitati, Bound, [Az|Cammino]) :-
    applicabile(Az, S),
    trasforma(Az, S, S1),
    \+ member(S1, Visitati),
    G1 is G + 1,
    ricerca(S1, G1, [S1|Visitati], Bound, Cammino).

% ---------- aggiorna la prossima soglia (min degli overcut) ----------
salva(Fs) :-
    retract(prossimaSoglia(none)), !,
    asserta(prossimaSoglia(Fs)).

salva(Fs) :-
    prossimaSoglia(Cur),
    Fs < Cur, !,
    retractall(prossimaSoglia(_)),
    asserta(prossimaSoglia(Fs)).

salva(Fs) :-
    prossimaSoglia(Cur),
    Fs >= Cur, !.
