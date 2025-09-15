num_col(10).
num_righe(10).

iniziale(pos(1,10)).
finale(pos(3,10)).


occupata(pos(2,2)).
occupata(pos(2,3)).
occupata(pos(2,4)).
occupata(pos(2,5)).
occupata(pos(2,6)).
occupata(pos(2,7)).
occupata(pos(2,8)).
occupata(pos(2,9)).
occupata(pos(2,10)).

occupata(pos(3,2)).
occupata(pos(4,2)).
occupata(pos(5,2)).
occupata(pos(6,2)).
occupata(pos(7,2)).
occupata(pos(8,2)).

occupata(pos(9,2)).
occupata(pos(9,3)).
occupata(pos(9,4)).
occupata(pos(9,5)).
occupata(pos(9,6)).
occupata(pos(9,7)).
occupata(pos(9,8)).
occupata(pos(9,9)).

occupata(pos(3,9)).
occupata(pos(4,9)).
occupata(pos(5,9)).
occupata(pos(6,9)).
occupata(pos(7,9)).
occupata(pos(8,9)).


f(G, S, F) :-
    custom_finale(S, BestGoal),
    distanza_manhattan(S, BestGoal, H),
    F is G + H.

distanza_manhattan(pos(Xi,Yi), pos(Xf,Yf), Ris) :-
    DX is abs(Xi - Xf),
    DY is abs(Yi - Yf),
    Ris is DX + DY.

custom_finale(S, Best) :-
    findall(G, finale(G), ListaFinali),
    ListaFinali \= [],                     
    min_wrapper(ListaFinali, S, Best).

min_wrapper([Head|Tail], S, Best) :-
    distanza_manhattan(Head, S, InitialMin),
    min(Tail, InitialMin, Head, S, Best). 

min([], _, CurrentBestGoal, _, CurrentBestGoal).
min([Head|Tail], ActualMin, _, S, Best) :-
    distanza_manhattan(Head, S, MinHead),
    MinHead < ActualMin, !,
    min(Tail, MinHead, Head, S, Best).
min([Head|Tail], ActualMin, CurrentBestGoal, S, Best) :-
    distanza_manhattan(Head, S, MinHead),
    MinHead >= ActualMin, !,
    min(Tail, ActualMin, CurrentBestGoal, S, Best).



