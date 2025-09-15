num_col(10).
num_righe(10).

iniziale(pos(1,1)).
finale(pos(10,10)).


occupata(pos(2,1)).
occupata(pos(2,2)).
occupata(pos(2,3)).
occupata(pos(2,4)).
occupata(pos(2,5)).
occupata(pos(2,6)).
occupata(pos(2,7)).
occupata(pos(2,8)).
occupata(pos(2,9)).
occupata(pos(4,2)).
occupata(pos(4,3)).
occupata(pos(4,4)).
occupata(pos(4,5)).
occupata(pos(4,6)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,10)).
occupata(pos(6,1)).
occupata(pos(6,2)).
occupata(pos(6,3)).
occupata(pos(6,4)).
occupata(pos(6,5)).
occupata(pos(6,6)).
occupata(pos(6,7)).
occupata(pos(6,8)).
occupata(pos(6,9)).
occupata(pos(8,2)).
occupata(pos(8,3)).
occupata(pos(8,4)).
occupata(pos(8,5)).
occupata(pos(8,6)).
occupata(pos(8,7)).
occupata(pos(8,8)).
occupata(pos(8,9)).
occupata(pos(8,10)).
occupata(pos(10,1)).
occupata(pos(10,2)).
occupata(pos(10,3)).
occupata(pos(10,4)).
occupata(pos(10,5)).
occupata(pos(10,6)).
occupata(pos(10,7)).
occupata(pos(10,8)).
occupata(pos(10,9)).

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



