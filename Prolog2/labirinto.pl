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

h_manhattan(pos(Xi,Yi), pos(Xf,Yf), Ris) :-
    DX is Xf - Xi,
    DY is Yf - Yi,
    Ris is abs(DX) + abs(DY).

h_euclidea(pos(Xi,Yi), pos(Xf,Yf), Ris) :-
    DX is Xf - Xi,
    DY is Yf - Yi,
    Ris is sqrt(DX*DX + DY*DY).

