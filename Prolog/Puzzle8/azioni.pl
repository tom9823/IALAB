applicabile(est,  Stato) :- member(pos(_R,C,-1), Stato), C < 3.
applicabile(ovest, Stato) :- member(pos(_R,C,-1), Stato), C > 1.
applicabile(nord,  Stato) :- member(pos(R,_C,-1), Stato), R > 1.
applicabile(sud,   Stato) :- member(pos(R,_C,-1), Stato), R < 3.

trasforma(est, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), C < 3, C1 is C+1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R,C1,V), T0, T1),
    Nuovo = [pos(R,C1,-1), pos(R,C,V) | T1].

trasforma(ovest, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), C > 1, C1 is C-1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R,C1,V), T0, T1),
    Nuovo = [pos(R,C1,-1), pos(R,C,V) | T1].

trasforma(nord, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), R > 1, R1 is R-1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R1,C,V), T0, T1),
    Nuovo = [pos(R1,C,-1), pos(R,C,V) | T1].

trasforma(sud, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), R < 3, R1 is R+1,
    select(pos(R,C,-1), Stato, T0),
    select(pos(R1,C,V), T0, T1),
    Nuovo = [pos(R1,C,-1), pos(R,C,V) | T1].