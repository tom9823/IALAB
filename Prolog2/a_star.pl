ric_a_star(Soluzione):-
    iniziale(S0),
    ampiezza([[S0,[]]],[],SoluzioneInversa),
    inverti(SoluzioneInversa,Soluzione).

ampiezza([[S,PathToS]|_],_,PathToS):-
    finale(S).
ampiezza([[S,PathToS]|Coda],Visitati,Soluzione):-
    findall(Az,applicabile(Az,S),ListaApplicabili),
    generaListaNuoviStati([S,PathToS],ListaApplicabili,Visitati,ListaNuoviStati),
    append(Coda,ListaNuoviStati,NuovaCoda),
    bubble_sort_wrapper(NuovaCoda, CodaOrdinata),
    ampiezza(CodaOrdinata,[S|Visitati],Soluzione).

generaListaNuoviStati(_,[],_,[]).
generaListaNuoviStati([S,PathToS],[Az|AltreAzioni],Visitati,[[SNuovo,[Az|PathToS]]|NuoviS]):-
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),!,
    generaListaNuoviStati([S,PathToS],AltreAzioni,Visitati,NuoviS).
generaListaNuoviStati([S,PathToS],[_|AltreAzioni],Visitati,Ris):-
    generaListaNuoviStati([S,PathToS],AltreAzioni,Visitati,Ris).




inverti([],[]).
inverti([Head|Tail],Res):-
    inverti(Tail,TailInv),
    append(TailInv,[Head],Res).

bubble_sort_wrapper(List, Ris):-
    length(List, N),
    bubble_sort(List, N, 0, Ris).

% fine ordinamento quando N è 0
bubble_sort(List, 0, _, List).

% esegue una passata e poi riduce N
bubble_sort(List, N, _, Ris) :-
    N > 0,
    bubble_pass(List, 0, N, Pass),
    NewN is N - 1,
    bubble_sort(Pass, NewN, 0, Ris).

% ---- passata di bubble (scorre la lista una volta) ----
bubble_pass([X], _, _, [X]).
bubble_pass([Head, NextHead | Tail], I, N, [A|Rest]) :-
    swap(Head, NextHead, [A,B]),
    NewI is I + 1,
    bubble_pass([B|Tail], NewI, N, Rest).

% ---- swap (confronto F=G+H; FIX: virgola al posto del punto e finale/1 una sola volta) ----
swap([],[],[]).
swap(A,[],[A]).
swap([],B,[B]).

swap([S,PathToS],[NextS,PathToNextS],[[NextS,PathToNextS],[S,PathToS]]):-
    finale(Sf),
    length(PathToS, Gn),
    h_manhattan(S,Sf,Hn),
    Fn is Gn + Hn,
    length(PathToNextS, NextGn),
    h_manhattan(NextS,Sf,NextHn),
    NextFn is NextGn + NextHn,
    Fn > NextFn.

swap([S,PathToS],[NextS,PathToNextS],[[S,PathToS],[NextS,PathToNextS]]):-
    finale(Sf),
    length(PathToS, Gn),
    h_manhattan(S,Sf,Hn),
    Fn is Gn + Hn,
    length(PathToNextS, NextGn),
    h_manhattan(NextS,Sf,NextHn),
    NextFn is NextGn + NextHn,
    Fn =< NextFn.


