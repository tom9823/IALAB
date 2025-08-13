ric_ampiezza(Soluzione):-
    iniziale(S0),
    ampiezza([[S0,[]]],[],SoluzioneInversa),
    inverti(SoluzioneInversa,Soluzione).

ampiezza([[S,PathToS]|_],_,PathToS):-
    finale(S).
ampiezza([[S,PathToS]|Coda],Visitati,Soluzione):-
    findall(Az,applicabile(Az,S),ListaApplicabili),
    generaListaNuoviStati([S,PathToS],ListaApplicabili,Visitati,ListaNuoviStati),
    append(Coda,ListaNuoviStati,NuovaCoda),
    ampiezza(NuovaCoda,[S|Visitati],Soluzione).

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