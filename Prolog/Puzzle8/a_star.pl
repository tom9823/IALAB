ric_a_star(Soluzione):-
    iniziale(S0),
    ordina_stato(S, S0),
    ampiezza([[S0,[]]],[],SoluzioneInversa),
    inverti(SoluzioneInversa,Soluzione).

ampiezza([[S,PathToS]|_],_,PathToS):-
    finale(S).
ampiezza([[S,PathToS]|Coda],Visitati,Soluzione):-
    findall(Az,applicabile(Az,S),ListaApplicabili),
    generaListaNuoviStati([S,PathToS],ListaApplicabili,Visitati,ListaNuoviStati),
    ordered_concat(Coda,ListaNuoviStati, NuovaCodaOrdinata),
    ampiezza(NuovaCodaOrdinata,[S|Visitati],Soluzione).

generaListaNuoviStati(_,[],_,[]).
% aggiungo stato se azione mi porta in uno stato non visitato
generaListaNuoviStati([S,PathToS],[Az|AltreAzioni],Visitati,[[SNuovo,[Az|PathToS]]|NuoviS]):-
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),!,
    generaListaNuoviStati([S,PathToS],AltreAzioni,Visitati,NuoviS).

% salto azione se mi porta in uno stato già visitato
generaListaNuoviStati([S,PathToS],[_|AltreAzioni],Visitati,Ris):-
    generaListaNuoviStati([S,PathToS],AltreAzioni,Visitati,Ris).

inverti([],[]).
inverti([Head|Tail],Res):-
    inverti(Tail,TailInv),
    append(TailInv,[Head],Res).

% ---------- utilità ----------
len([], 0).
len([_|T], N) :- len(T, N1), N is N1 + 1.

f_da_coppia(Stato, Path, F) :-
    len(Path, G),
    f(G, Stato, F).

% ---------- inserimento ordinato di UN elemento ----------

ordered_append([], [E,P], [[E,P]]) :- !.

% metti davanti se F(E) < F(Testa)
ordered_append([[S,PS]|Altri], [E,PE], [[E,PE],[S,PS]|Altri]) :- 
    f_da_coppia(E,PE,FE),
    f_da_coppia(S,PS,FS),
    FE < FS, !.

% altrimenti tieni la testa e inserisci nel resto
ordered_append([[S,PS]|Altri], [E,PE], [[S,PS]|Nuova]) :-
    ordered_append(Altri, [E,PE], Nuova).

% ---------- concatenazione ordinata di UNA LISTA di elementi ----------

ordered_concat(Coda, [], Coda) :- !.
ordered_concat(Coda, [Head|Tail], Nuova) :-
    ordered_append(Coda, Head, Coda1),
    ordered_concat(Coda1, Tail, Nuova).