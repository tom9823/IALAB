

iniziale([
    pos(2,1),  pos(5,2),  pos(3,3),
    pos(1,4),  pos(7,5),  pos(-1,6),
    pos(4,7),  pos(8,8),  pos(6,9)
]).

finale([pos(-1,9)]).
finale([pos(Valore, Posizione) | Tail]) :- Valore == Posizione, finale(Tail).