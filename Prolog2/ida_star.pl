initialize:-
    retractall(soglia(_)),
    retractall(next_bound(_)),
    iniziale(Si),
    finale(Sf),
    h_manhattan(Si, Sf, Hi),
    asserta(soglia(Hi)).

% provo profondità con questa soglia
ida_star(Cammino):-
    soglia(S),
    retractall(next_bound(_)),
    asserta(next_bound([])),
    profondita(Cammino,S).

% aggiorno soglia
ida_star(Cammino):-
    next_bound([Head | _]),
    SNuova is Head,
    retractall(next_bound(_)),
    retractall(soglia(_)),
    asserta(soglia(SNuova)),
    ida_star(Cammino).

ida_star(_) :-
    next_bound([]), !, fail.

profondita(Cammino,Soglia):-
    iniziale(S0),
    ricerca(S0,[S0],Soglia,Cammino).

ricerca(S,_,_,[]):- finale(S).

ricerca(S,Visitati,Bound,[Azione|Cammino]):-
    length(Visitati, Gn),
    finale(Sf),
    h_manhattan(S,Sf,Hn),
    Fn is Gn + Hn,
    Fn =< Bound,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+ member(SNuovo,Visitati),
    ricerca(SNuovo,[SNuovo|Visitati],Bound,Cammino).

ricerca(S,Visitati,Bound,_):-
    length(Visitati, Gn),
    finale(Sf),
    h_manhattan(S,Sf,Hn),
    Fn is Gn + Hn,
    Fn > Bound,
    salva(Fn),
    Fn < Bound.   
salva(Fn) :-
    next_bound([Head | _]),
    Fn < Head, !,
    retractall(next_bound(_)),
    asserta(next_bound([Fn])).

salva(Fn) :-
    next_bound([Head | _]),
    Fn >= Head, !.

salva(Fn) :-
    next_bound([]), !,
    retractall(next_bound(_)),
    asserta(next_bound([Fn])).