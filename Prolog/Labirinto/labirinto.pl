num_col(10).
num_righe(10).

iniziale(pos(4,2)).
finale(pos(7,9)).

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
min([Head|Tail], ActualMin, CurrentBestGoal, S, Best) :-
    distanza_manhattan(Head, S, MinHead),
    MinHead < ActualMin, !,
    min(Tail, MinHead, Head, S, Best).
min([Head|Tail], ActualMin, CurrentBestGoal, S, Best) :-
    distanza_manhattan(Head, S, MinHead),
    MinHead >= ActualMin, !,
    min(Tail, ActualMin, CurrentBestGoal, S, Best).


