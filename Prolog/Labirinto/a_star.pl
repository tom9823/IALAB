ric_ampiezza(Soluzione):-
    iniziale(S0),
    ampiezza([[(S0,f(S0)],[]]],[],SoluzioneInversa),
    inverti(SoluzioneInversa,Soluzione).

ampiezza([[(S,_),PathToS]|_],_,PathToS):-
    finale(S).
ampiezza([[(S,Fs),PathToS]|Coda],Visitati,Soluzione):-
    findall(Az,applicabile(Az,S),ListaApplicabili),
    generaListaNuoviStati([(S,Fs),PathToS],ListaApplicabili,Visitati,ListaNuoviStati),
    append(Coda,ListaNuoviStati,NuovaCoda),
    ordina_per_f(NuovaCoda, NuovaCod1),
    ampiezza(NuovaCoda1,[S|Visitati],Soluzione).

generaListaNuoviStati(_,[],_,[]).
generaListaNuoviStati([(S,Fs),PathToS],[Az|AltreAzioni],Visitati,[[SNuovo,[Az|PathToS]]|NuoviS]):-
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),!,
    generaListaNuoviStati([S,PathToS],AltreAzioni,Visitati,NuoviS).
generaListaNuoviStati([S,PathToS],[_|AltreAzioni],Visitati,Ris):-
    generaListaNuoviStati([S,PathToS],AltreAzioni,Visitati,Ris).

inverti([],[]).
inverti([Head|Tail],Res):-
    inverti(Tail,TailInv),
    append(TailInv,[Head],Res).

ordina_per_f(Coda, CodaOrdinata):-
    len(Coda) == 1,
    !,
    CodaOrdinata = Coda.
ordina_per_f([], []).
ordina_per_f(Head|Tail], CodaOrdinata):-
    
