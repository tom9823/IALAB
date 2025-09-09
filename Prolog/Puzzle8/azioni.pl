applicabile(est,  Stato) :- member(pos(_R,C,-1), Stato), C < 3.
applicabile(ovest, Stato) :- member(pos(_R,C,-1), Stato), C > 1.
applicabile(nord,  Stato) :- member(pos(R,_C,-1), Stato), R > 1.
applicabile(sud,   Stato) :- member(pos(R,_C,-1), Stato), R < 3.

% --- trasforma: scambia vuoto con tessera adiacente ---
trasforma(est, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), C < 3, C1 is C+1,
    my_delete_from_list(pos(R,C,-1), Stato, T0),
    my_delete_from_list(pos(R,C1,V), T0, T1),
    Nuovo0 = [pos(R,C1,-1), pos(R,C,V) | T1],
    order_state(Nuovo0, Nuovo).

trasforma(ovest, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), C > 1, C1 is C-1,
    my_delete_from_list(pos(R,C,-1), Stato, T0),
    my_delete_from_list(pos(R,C1,V), T0, T1),
    Nuovo0 = [pos(R,C1,-1), pos(R,C,V) | T1],
    order_state(Nuovo0, Nuovo).

trasforma(nord, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), R > 1, R1 is R-1,
    my_delete_from_list(pos(R,C,-1), Stato, T0),
    my_delete_from_list(pos(R1,C,V), T0, T1),
    Nuovo0 = [pos(R1,C,-1), pos(R,C,V) | T1],
    order_state(Nuovo0, Nuovo).

trasforma(sud, Stato, Nuovo) :-
    member(pos(R,C,-1), Stato), R < 3, R1 is R+1,
    my_delete_from_list(pos(R,C,-1), Stato, T0),
    my_delete_from_list(pos(R1,C,V), T0, T1),
    Nuovo0 = [pos(R1,C,-1), pos(R,C,V) | T1],
    order_state(Nuovo0, Nuovo).

my_delete_from_list(_, [], []).
my_delete_from_list(Elem, [Elem|Tail], Rest) :-
    my_delete_from_list(Elem, Tail, Rest).
my_delete_from_list(Elem, [Head|Tail], [Head|Rest]) :-
    dif(Head, Elem),
    my_delete_from_list(Elem, Tail, Rest).


% --- insertion sort su pos/3: ordina per riga (X) poi colonna (Y) ---

order_state([], []).
order_state([Head|Tail], StatoOrdinato) :-
    order_state(Tail, OrderedTail),
    ordered_insert(Head, OrderedTail, StatoOrdinato).

% inserimento stabile
ordered_insert(Elem, [], [Elem]).
ordered_insert(Elem, [Head|Tail], [Elem,Head|Tail]) :-
    before_than(Elem, Head), !.
ordered_insert(Elem, [Head|Tail], [Head|Ris]) :-
    ordered_insert(Elem, Tail, Ris).

% lessicografico: prima X, poi Y (entrambi stretti)
before_than(pos(X1,Y1,_), pos(X2,Y2,_)) :-
    X1 < X2, !.
before_than(pos(X1,Y1,_), pos(X2,Y2,_)) :-
    X1 =:= X2,
    Y1 < Y2.