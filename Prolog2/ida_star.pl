initialize:-
    retractall(soglia(_)),
    iniziale(Si),
    finale(Sf),
    h_manhattan(Si, Sf, Hi),
    asserta(fn_salvato([])),
    asserta(soglia(Hi)).


% provo profondità con questa soglia
ida_star(Cammino):-
    soglia(S),
    retractall(fn_salvato(_)),
    asserta(fn_salvato([])),
    profondita(Cammino,S).

% aggiorno soglia
ida_star(Cammino):-
    fn_salvato([Head | _]),
    SNuova is Head,
    retractall(fn_salvato(_)),
    retractall(soglia(_)),
    asserta(soglia(SNuova)),
    ida_star(Cammino).

ida_star(_) :-
    fn_salvato([]), !, fail.


profondita(Cammino,Soglia):-
    iniziale(S0),
    ricerca(S0,[S0],Soglia,Cammino).

ricerca(S,_,_,[]):-finale(S).
ricerca(S,Visitati,Bound,[Azione|Cammino]):-
    length(Visitati, Gn),
    finale(Sf),
    h_manhattan(S,Sf,Hn),
    Fn is Gn + Hn,
    Fn =< Bound,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
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
    fn_salvato([Head | Tail]),
    length([Head | Tail], N),
    N > 0,
    Fn < Head,
    asserta(fn_salvato([Fn])).

salva(Fn) :-
    fn_salvato([Head | Tail]),
    length([Head | Tail], N),
    N > 0,
    Fn >= Head.

salva(Fn) :-
    fn_salvato([]),
    asserta(fn_salvato([Fn])).
