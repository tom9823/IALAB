
initialize :-
    retractall(soglia(_)),
    retractall(prossimaSoglia(_)),
    iniziale(Si),
    f(0, Si, F0),
    asserta(soglia(F0)),
    write('Soglia iniziale = '), write(F0), nl.

% ---------- loop IDA* ----------
ida_star(Cammino) :-
    soglia(Bound),
    % reset del contenitore "next bound"
    retractall(prossimaSoglia(_)),
    asserta(prossimaSoglia(none)),
    write('IDA*: iterazione con soglia = '), write(Bound), nl,
    profondita(Cammino, Bound).

% alza la soglia se è stato salvato un overcut
ida_star(Cammino) :-
    prossimaSoglia(Next),
    number(Next), !,
    soglia(Old),
    retractall(soglia(_)),
    asserta(soglia(Next)),
    write('Alzo soglia: '), write(Old), write(' -> '), write(Next), nl,
    ida_star(Cammino).

% nessun overcut raccolto: nessuna soluzione raggiungibile
ida_star(_) :-
    prossimaSoglia(none), !,
    soglia(B),
    write('IDA*: nessun overcut raccolto. Nessuna soluzione con soglia '),
    write(B), nl,
    fail.

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
    F =< Bound.

% espansione
ricerca(S, G, Visitati, Bound, [Az|Cammino]) :-
    applicabile(Az, S),
    trasforma(Az, S, SNuovo),
    \+ member(SNuovo, Visitati),
    G1 is G + 1,
    ricerca(SNuovo, G1, [SNuovo|Visitati], Bound, Cammino).

% ---------- aggiorna la prossima soglia (min degli overcut) ----------
salva(Fs) :-
    retract(prossimaSoglia(none)), !,
    asserta(prossimaSoglia(Fs)),
    write('Scrivo la prossimaSoglia := '), write(Fs), nl.

salva(Fs) :-
    prossimaSoglia(Cur),
    Fs < Cur, !,
    retractall(prossimaSoglia(_)),
    asserta(prossimaSoglia(Fs)),
    write('Aggiorno prossimaSoglia: '),
    write(Cur), write(' -> '), write(Fs), nl.

salva(_Fs) :-
    prossimaSoglia(_Cur), !.
