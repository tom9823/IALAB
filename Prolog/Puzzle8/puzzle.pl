iniziale([
    pos(1,1,7), pos(1,2,3), pos(1,3,1),
    pos(2,1,5), pos(2,2,-1), pos(2,3,6),
    pos(3,1,8), pos(3,2,2), pos(3,3,4)
]).

finale([
  pos(1,1,1), pos(1,2,2), pos(1,3,3),
  pos(2,1,4), pos(2,2,5), pos(2,3,6),
  pos(3,1,7), pos(3,2,8), pos(3,3,-1)
]).

f(G, S, F) :- h(S, H), F is G + H.

% State = lista di pos(R,C,V), vuoto = -1
h(State, H) :-
    manh_acc(State, 0, H).

manh_acc([], Acc, Acc).

% ignora il vuoto
manh_acc([pos(_,_, -1)|T], Acc, H) :- !,
    manh_acc(T, Acc, H).

% tessera 1 -> goal (1,1)
manh_acc([pos(R,C,1)|T], Acc, H)  :- !,
    DX is abs(R-1), DY is abs(C-1), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 2 -> goal (1,2)
manh_acc([pos(R,C,2)|T], Acc, H)  :- !,
    DX is abs(R-1), DY is abs(C-2), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 3 -> goal (1,3)
manh_acc([pos(R,C,3)|T], Acc, H)  :- !,
    DX is abs(R-1), DY is abs(C-3), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 4 -> goal (2,1)
manh_acc([pos(R,C,4)|T], Acc, H)  :- !,
    DX is abs(R-2), DY is abs(C-1), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 5 -> goal (2,2)
manh_acc([pos(R,C,5)|T], Acc, H)  :- !,
    DX is abs(R-2), DY is abs(C-2), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 6 -> goal (2,3)
manh_acc([pos(R,C,6)|T], Acc, H)  :- !,
    DX is abs(R-2), DY is abs(C-3), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 7 -> goal (3,1)
manh_acc([pos(R,C,7)|T], Acc, H)  :- !,
    DX is abs(R-3), DY is abs(C-1), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

% tessera 8 -> goal (3,2)
manh_acc([pos(R,C,8)|T], Acc, H)  :- !,
    DX is abs(R-3), DY is abs(C-2), Acc1 is Acc + DX + DY,
    manh_acc(T, Acc1, H).

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
before_than(pos(X1,_,_), pos(X2,_,_)) :-
    X1 < X2, !.
before_than(pos(X1,Y1,_), pos(X2,Y2,_)) :-
    X1 =:= X2,
    Y1 < Y2.