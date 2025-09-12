applicabile(est,  Stato) :- member(pos(_R,C,-1), Stato), C < 3.
applicabile(ovest, Stato) :- member(pos(_R,C,-1), Stato), C > 1.
applicabile(nord,  Stato) :- member(pos(R,_C,-1), Stato), R > 1.
applicabile(sud,   Stato) :- member(pos(R,_C,-1), Stato), R < 3.

% --- trasforma: scambia vuoto con tessera adiacente ---
trasforma(est, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), C < 3, C1 is C+1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R,C1,V), T0, T1),
    Nuovo0 = [pos(R,C1,-1), pos(R,C,V) | T1],
    ordina_stato(Nuovo0, Nuovo).

trasforma(ovest, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), C > 1, C1 is C-1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R,C1,V), T0, T1),
    Nuovo0 = [pos(R,C1,-1), pos(R,C,V) | T1],
    ordina_stato(Nuovo0, Nuovo).

trasforma(nord, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), R > 1, R1 is R-1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R1,C,V), T0, T1),
    Nuovo0 = [pos(R1,C,-1), pos(R,C,V) | T1],
    ordina_stato(Nuovo0, Nuovo).

trasforma(sud, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), R < 3, R1 is R+1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R1,C,V), T0, T1),
    Nuovo0 = [pos(R1,C,-1), pos(R,C,V) | T1],
    ordina_stato(Nuovo0, Nuovo).


% ordina_stato(+Stato, -StatoOrdinato) 
ordina_stato([], []).
ordina_stato([H|T], Ord) :-
    ordina_stato(T, OrdT),
    inserisci_ordinato(H, OrdT, Ord).

% inserimento stabile in lista già ordinata
inserisci_ordinato(X, [], [X]) :- !.
inserisci_ordinato(X, [Y|Ys], [X,Y|Ys]) :-
    prima_di(X, Y), !.
inserisci_ordinato(X, [Y|Ys], [Y|Zs]) :-
    inserisci_ordinato(X, Ys, Zs).

% X prima di Y se riga minore...
prima_di(pos(R1,_,_), pos(R2,_,_)) :-
    R1 < R2, !.
% ...oppure stessa riga e colonna minore/uguale
prima_di(pos(R1,C1,_), pos(R2,C2,_)) :-
    R1 == R2,
    C1 =< C2.