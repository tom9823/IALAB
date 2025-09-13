num_col(30).
num_righe(30).

iniziale(pos(4,2)).
finale(pos(27,29)).

% Muro verticale C=7 (varco a R=6)
occupata(pos(1,7)).
occupata(pos(2,7)).
occupata(pos(3,7)).
occupata(pos(4,7)).
occupata(pos(5,7)).
occupata(pos(7,7)).
occupata(pos(8,7)).
occupata(pos(9,7)).
occupata(pos(10,7)).
occupata(pos(11,7)).
occupata(pos(12,7)).
occupata(pos(13,7)).
occupata(pos(14,7)).
occupata(pos(15,7)).
occupata(pos(16,7)).
occupata(pos(17,7)).
occupata(pos(18,7)).
occupata(pos(19,7)).
occupata(pos(20,7)).
occupata(pos(21,7)).
occupata(pos(22,7)).
occupata(pos(23,7)).
occupata(pos(24,7)).
occupata(pos(25,7)).
occupata(pos(26,7)).
occupata(pos(27,7)).
occupata(pos(28,7)).
occupata(pos(29,7)).
occupata(pos(30,7)).

% Muro verticale C=14 (varco a R=20)
occupata(pos(1,14)).
occupata(pos(2,14)).
occupata(pos(3,14)).
occupata(pos(4,14)).
occupata(pos(5,14)).
occupata(pos(6,14)).
occupata(pos(7,14)).
occupata(pos(8,14)).
occupata(pos(9,14)).
occupata(pos(10,14)).
occupata(pos(11,14)).
occupata(pos(12,14)).
occupata(pos(13,14)).
occupata(pos(14,14)).
occupata(pos(15,14)).
occupata(pos(16,14)).
occupata(pos(17,14)).
occupata(pos(18,14)).
occupata(pos(19,14)).
occupata(pos(21,14)).
occupata(pos(22,14)).
occupata(pos(23,14)).
occupata(pos(24,14)).
occupata(pos(25,14)).
occupata(pos(26,14)).
occupata(pos(27,14)).
occupata(pos(28,14)).
occupata(pos(29,14)).
occupata(pos(30,14)).

% Muro verticale C=26 (varco a R=27)
occupata(pos(1,26)).
occupata(pos(2,26)).
occupata(pos(3,26)).
occupata(pos(4,26)).
occupata(pos(5,26)).
occupata(pos(6,26)).
occupata(pos(7,26)).
occupata(pos(8,26)).
occupata(pos(9,26)).
occupata(pos(10,26)).
occupata(pos(11,26)).
occupata(pos(12,26)).
occupata(pos(13,26)).
occupata(pos(14,26)).
occupata(pos(15,26)).
occupata(pos(16,26)).
occupata(pos(17,26)).
occupata(pos(18,26)).
occupata(pos(19,26)).
occupata(pos(20,26)).
occupata(pos(21,26)).
occupata(pos(22,26)).
occupata(pos(23,26)).
occupata(pos(24,26)).
occupata(pos(25,26)).
occupata(pos(26,26)).
occupata(pos(28,26)).
occupata(pos(29,26)).
occupata(pos(30,26)).

% Muro orizzontale R=12 (varco a C=10) — (evito duplicati con C=7,14,26)
occupata(pos(12,1)).
occupata(pos(12,2)).
occupata(pos(12,3)).
occupata(pos(12,4)).
occupata(pos(12,5)).
occupata(pos(12,6)).
occupata(pos(12,8)).
occupata(pos(12,9)).
occupata(pos(12,11)).
occupata(pos(12,12)).
occupata(pos(12,13)).
occupata(pos(12,15)).
occupata(pos(12,16)).
occupata(pos(12,17)).
occupata(pos(12,18)).
occupata(pos(12,19)).
occupata(pos(12,20)).
occupata(pos(12,21)).
occupata(pos(12,22)).
occupata(pos(12,23)).
occupata(pos(12,24)).
occupata(pos(12,25)).
occupata(pos(12,27)).
occupata(pos(12,28)).
occupata(pos(12,29)).
occupata(pos(12,30)).

% Muro orizzontale R=23 (varco a C=22) — (evito duplicati con C=7,14,26)
occupata(pos(23,1)).
occupata(pos(23,2)).
occupata(pos(23,3)).
occupata(pos(23,4)).
occupata(pos(23,5)).
occupata(pos(23,6)).
occupata(pos(23,8)).
occupata(pos(23,9)).
occupata(pos(23,10)).
occupata(pos(23,11)).
occupata(pos(23,12)).
occupata(pos(23,13)).
occupata(pos(23,15)).
occupata(pos(23,16)).
occupata(pos(23,17)).
occupata(pos(23,18)).
occupata(pos(23,19)).
occupata(pos(23,20)).
occupata(pos(23,21)).
occupata(pos(23,23)).
occupata(pos(23,24)).
occupata(pos(23,25)).
occupata(pos(23,27)).
occupata(pos(23,28)).
occupata(pos(23,29)).
occupata(pos(23,30)).

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

    