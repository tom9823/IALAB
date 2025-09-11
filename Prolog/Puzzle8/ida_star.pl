
initialize :-
    retractall(soglia(_)),
    retractall(prossimaSoglia(_)),
    iniziale(S0),
    h(S0, H0),
    asserta(soglia(H0)).

% ---------- loop IDA*: prova entro Bound; se non trova, alza soglia ----------
% prova entro la soglia corrente (bound su f)
ida_star(Cammino) :-
    soglia(Bound),
    % reset del contenitore "next bound"
    retractall(prossimaSoglia(_)),
    asserta(prossimaSoglia(none)), 
    profondita(Cammino, Bound).                  

% non ha trovato: nuova soglia = min degli f(n) tagliati
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
    order_state(S0, S),
    ricerca(S, 0, [S0], Bound, Cammino).

% successo: goal con f ≤ Bound
ricerca(S, G, _Visitati, Bound, []) :-
    finale(S),
    f(G, S, F),
    F =< Bound,
    !.

% taglio: f > Bound → salva f(n) e backtracking
ricerca(S, G, _Visitati, Bound, _Cammino) :-
    f(G, S, F),
    F > Bound, !,
    salva(F),
    F =< Bound.

% espansione, evita cicli sul path
ricerca(S, G, Visitati, Bound, [Azione|Cammino]) :-
    applicabile(Azione, S),
    trasforma(Azione, S, S1),
    \+ member(S1, Visitati),
    G1 is G + 1,
    ricerca(S1, G1, [S1|Visitati], Bound, Cammino).

% ---------- aggiorna la prossima soglia (min degli overcut) ----------
salva(Fs) :-
    retract(prossimaSoglia(none)), !,
    asserta(prossimaSoglia(Fs)),
    write('prossimaSoglia := '), write(Fs), nl.

salva(Fs) :-
    prossimaSoglia(Cur),
    Fs < Cur, !,
    retractall(prossimaSoglia(_)),
    asserta(prossimaSoglia(Fs)),
    write('prossimaSoglia aggiornata: '),
    write(Cur), write(' -> '), write(Fs), nl.

salva(_Fs) :-
    prossimaSoglia(_Cur), !.


