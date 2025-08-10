initialize:-
    retractall(soglia(_)),
    asserta(soglia(1)).
itdeep(Cammino):-
    soglia(S),
    profondita(Cammino,S).
itdeep(Cammino):-
    soglia(S),
    SNuova is S+1,
    retractall(soglia(_)),
    asserta(soglia(SNuova)),
    itdeep(Cammino).

profondita(Cammino,Soglia):-
    iniziale(S0),
    ricerca(S0,[S0],Soglia,Cammino).
ricerca(S,_,_,[]):-finale(S).
ricerca(S,Visitati,MaxDepth,[Azione|Cammino]):-
    MaxDepth > 0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NewMax is MaxDepth-1,
    ricerca(SNuovo,[SNuovo|Visitati],NewMax,Cammino).