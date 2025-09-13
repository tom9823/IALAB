num_col(15).
num_righe(15).

iniziale(pos(4,2)).
finale(pos(14,14)).

% Muro verticale C=5 (varco a R=3)
occupata(pos(1,5)).
occupata(pos(2,5)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,5)).
occupata(pos(7,5)).
occupata(pos(8,5)).
occupata(pos(9,5)).
occupata(pos(10,5)).
occupata(pos(11,5)).
occupata(pos(12,5)).
occupata(pos(13,5)).
occupata(pos(14,5)).
occupata(pos(15,5)).

% Muro verticale C=10 (varco a R=9)
occupata(pos(1,10)).
occupata(pos(2,10)).
occupata(pos(3,10)).
occupata(pos(4,10)).
occupata(pos(5,10)).
occupata(pos(6,10)).
occupata(pos(7,10)).
occupata(pos(8,10)).
occupata(pos(10,10)).
occupata(pos(11,10)).
occupata(pos(12,10)).
occupata(pos(13,10)).
occupata(pos(14,10)).
occupata(pos(15,10)).

% Muro orizzontale R=7 (varco a C=8) — evito duplicati con C=5 e C=10
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(7,6)).
occupata(pos(7,7)).
occupata(pos(7,9)).
occupata(pos(7,11)).
occupata(pos(7,12)).
occupata(pos(7,13)).
occupata(pos(7,14)).
occupata(pos(7,15)).

% Muro orizzontale R=12 (varco a C=13) — evito duplicati con C=5 e C=10
occupata(pos(12,1)).
occupata(pos(12,2)).
occupata(pos(12,3)).
occupata(pos(12,4)).
occupata(pos(12,6)).
occupata(pos(12,7)).
occupata(pos(12,8)).
occupata(pos(12,9)).
occupata(pos(12,11)).
occupata(pos(12,12)).
occupata(pos(12,14)).
occupata(pos(12,15)).

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
