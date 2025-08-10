num_col(10).
num_righe(10).

iniziale(pos(4,2)).
finale(pos(7,9)).
finale(pos(1,2)).

occupata(pos(2,5)).
occupata(pos(3,5)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,5)).
occupata(pos(7,5)).
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,10)).
occupata(pos(5,7)).
occupata(pos(6,7)).
occupata(pos(7,7)).
occupata(pos(8,7)).

distanza_manhattan(pos(Xi,Yi), pos(Xf,Yf), Ris) :- DeltaX is abs(Xi-Xf), DeltaY is abs(Yi-Yf), Ris is DeltaX + DeltaY.

% -------- conta quante finali/1 sono definite (senza librerie) --------
conta_finali(N) :-
    conta_finali_acc([], 0, N).

conta_finali_acc(Visti, Acc, N) :-
    finale(F),
    \+ member(F, Visti), !,
    Acc1 is Acc + 1,
    conta_finali_acc([F|Visti], Acc1, N).
conta_finali_acc(_, Acc, Acc).

% -------- euristica h(S,H): minima Manhattan verso la finale più vicina --------
h(S, 0) :-
    finale(S), !.

h(S, H) :-
    conta_finali(N), N > 0,
    mia_h(S, [], N, _, H), !.

% mia_h(S, Visti, N, Best0, Best):
%   visita N finali non ancora viste, aggiornando il migliore (minimo)
mia_h(_, _, 0, Best, Best) :- nonvar(Best), !.
mia_h(S, Visti, N, Best0, Best) :-
    finale(F),
    \+ member(F, Visti), !,
    distanza_manhattan(S, F, D),
    update_best(Best0, D, Best1),
    N1 is N - 1,
    mia_h(S, [F|Visti], N1, Best1, Best).

% aggiorna il minimo corrente
update_best(B0, D, D) :- var(B0), !.
update_best(B0, D, D) :- number(B0), D < B0, !.
update_best(B0, _, B0).
