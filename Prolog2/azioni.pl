applicabile(est,pos(R,C)):-
    num_col(N),
    C < N,
    ColonnaDx is C+1,
    \+occupata(pos(R,ColonnaDx)).
applicabile(nord,pos(R,C)):-
    R > 1,
    RigaSopra is R-1,
    \+occupata(pos(RigaSopra,C)).
applicabile(sud,pos(R,C)):-
    num_righe(N),
    R < N,
    RigaSotto is R+1,
    \+occupata(pos(RigaSotto,C)).
applicabile(ovest,pos(R,C)):-
    C > 1,
    ColonnaSx is C-1,
    \+occupata(pos(R,ColonnaSx)).

trasforma(nord,pos(R,C),pos(RigaSopra,C)):-
    RigaSopra is R-1.
trasforma(sud,pos(R,C),pos(RigaSotto,C)):-
    RigaSotto is R+1.
trasforma(est,pos(R,C),pos(R,ColDx)):-
    ColDx is C+1.
trasforma(ovest,pos(R,C),pos(R,ColSx)):-
    ColSx is C-1.