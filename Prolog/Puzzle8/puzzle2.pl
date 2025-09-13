iniziale([
  pos(1,1,1), pos(1,2,4), pos(1,3,2),
  pos(2,1,3), pos(2,2,7), pos(2,3,5),
  pos(3,1,6), pos(3,2,-1), pos(3,3,8)
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


min([], _):- !,false.
min([Head | Tail], Ris) :- Tail = [], !, Ris is Head.
min([Head | Tail],Ris) :- min_acc(Tail,Head, Ris).
min_acc([Head | Tail], Min, Ris) :- Min > Head, !, min_acc(Tail, Head, Ris).
min_acc([Head | Tail], Min, Ris) :- Min =< Head, !, min_acc(Tail, Min, Ris).
min_acc([], Min, Min).