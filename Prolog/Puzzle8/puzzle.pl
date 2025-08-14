iniziale([
    pos(1,1,2), pos(1,2,5), pos(1,3,3),
    pos(2,1,1), pos(2,2,7), pos(2,3,-1),
    pos(3,1,4), pos(3,2,8), pos(3,3,6)
]).

finale([
    pos(1,1,1), pos(1,2,2), pos(1,3,3),
    pos(2,1,4), pos(2,2,5), pos(2,3,6),
    pos(3,1,7), pos(3,2,8), pos(3,3,-1)
]).

h(S, H) :- h_puzzle_misplaced(S, H).

f(G, S, F) :- h(S, H), F is G + H.

h_puzzle_misplaced(State, H) :- mis_acc(State, 0, H).

% h: numero di tessere fuori posto (vuoto -1 escluso)
h_puzzle_misplaced(State, H) :-
    mis_acc(State, 0, H).

mis_acc([], Acc, Acc).

% ignora il vuoto
mis_acc([pos(_,_, -1)|T], Acc, H) :- !,
    mis_acc(T, Acc, H).

% tessere al posto giusto 
mis_acc([pos(1,1,1)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(1,2,2)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(1,3,3)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(2,1,4)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(2,2,5)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(2,3,6)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(3,1,7)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(3,2,8)|T], Acc, H)  :- !, mis_acc(T, Acc, H).
mis_acc([pos(3,3,-1)|T], Acc, H) :- !, mis_acc(T, Acc, H).  % vuoto in goal: non conta

% tutto il resto è "fuori posto"
mis_acc([_|T], Acc, H) :-
    Acc1 is Acc + 1,
    mis_acc(T, Acc1, H).

min([], _):- !,false.
min([Head | Tail], Ris) :- Tail = [], !, Ris is Head.
min([Head | Tail],Ris) :- min_acc(Tail,Head, Ris).
min_acc([Head | Tail], Min, Ris) :- Min > Head, !, min_acc(Tail, Head, Ris).
min_acc([Head | Tail], Min, Ris) :- Min =< Head, !, min_acc(Tail, Min, Ris).
min_acc([], Min, Min).