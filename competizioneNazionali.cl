continente(europa).
continente(nordcentroamerica).    
continente(sudamerica).         
continente(asia).
continente(africa).
continente(oceania).

squadra(sq1).  
squadra(sq2).  
squadra(sq3).  
squadra(sq4).
squadra(sq5).  
squadra(sq6).  
squadra(sq7).  
squadra(sq8).
squadra(sq9).  
squadra(sq10). 
squadra(sq11). 
squadra(sq12).
squadra(sq13). 
squadra(sq14). 
squadra(sq15). 
squadra(sq16).
squadra(sq17). 
squadra(sq18). 
squadra(sq19). 
squadra(sq20).
squadra(sq21). 
squadra(sq22). 
squadra(sq23). 
squadra(sq24).
squadra(sq25). 
squadra(sq26). 
squadra(sq27). 
squadra(sq28).
squadra(sq29). 
squadra(sq30). 
squadra(sq31). 
squadra(sq32).

1 {provenienza(X,Y):continente(Y)} 1 :- squadra(X).
10 {provenienza(Y,europa):squadra(Y)} 10:- continente(europa).
4 {provenienza(Y,nordcentroamerica):squadra(Y)} 4:- continente(nordcentroamerica).
8 {provenienza(Y,sudamerica):squadra(Y)} 8:- continente(sudamerica).
4 {provenienza(Y,asia):squadra(Y)} 4:- continente(asia).
4 {provenienza(Y,africa):squadra(Y)} 4:- continente(africa).
2 {provenienza(Y,oceania):squadra(Y)} 2:- continente(oceania).

girone(girone1).
girone(girone2).
girone(girone3).
girone(girone4).
girone(girone5).
girone(girone6).
girone(girone7).
girone(girone8).

1 {assegnazione(X,Y):girone(Y)} 1 :- squadra(X).
4 {assegnazione(X,Y):squadra(X)} 4 :- girone(Y).

categoria(testaDiSerie).
categoria(primaFascia).
categoria(secondaFascia).
categoria(underdog).

1 {fascia(X,Y):categoria(Y)} 1 :- squadra(X).
8 {fascia(X,Y):squadra(X)} 8 :- categoria(Y).


1 { assegnazione(X,Y) : fascia(X,testaDiSerie) } 1 :- girone(Y).
1 { assegnazione(X,Y) : fascia(X,primaFascia) } 1 :- girone(Y).
1 { assegnazione(X,Y) : fascia(X,secondaFascia) } 1 :- girone(Y).
1 { assegnazione(X,Y) : fascia(X,underdog) } 1 :- girone(Y).

triple_continenti(G) :-
    girone(G),
    squadra(X), squadra(Y), squadra(Z),
    X != Y, Y != Z,
    assegnazione(X,G), assegnazione(Y,G), assegnazione(Z,G),
    provenienza(X,C1), provenienza(Y,C2), provenienza(Z,C3),
    C1 != C2, C1 != C3, C2 != C3.

:- girone(G), not triple_continenti(G).

giornata(giornata1).
giornata(giornata2).
giornata(giornata3).

partita(partita1).
partita(partita2).
partita(partita3).
partita(partita4).
partita(partita5).
partita(partita6).
partita(partita7).
partita(partita8).
partita(partita9).
partita(partita10).
partita(partita11).
partita(partita12).
partita(partita13).
partita(partita14).
partita(partita15).
partita(partita16).
partita(partita17).
partita(partita18).
partita(partita19).
partita(partita20).
partita(partita21).
partita(partita22).
partita(partita23).
partita(partita24).
partita(partita25).
partita(partita26).
partita(partita27).
partita(partita28).
partita(partita29).
partita(partita30).
partita(partita31).
partita(partita32).
partita(partita33).
partita(partita34).
partita(partita35).
partita(partita36).
partita(partita37).
partita(partita38).
partita(partita39).
partita(partita40).
partita(partita41).
partita(partita42).
partita(partita43).
partita(partita44).
partita(partita45).
partita(partita46).
partita(partita47).
partita(partita48).

% Genera ogni match una sola volta (A<B) e solo tra squadre dello stesso girone
1 { match(P,A,B) :
      squadra(A), squadra(B), A < B,
      assegnazione(A,G), assegnazione(B,G)
  } 1 :- partita(P).

% Assegna OGNI match P a esattamente UNA giornata D
1 { partita_giornata(P,D) : giornata(D) } 1 :- match(P,_,_).

% Impone ESATTAMENTE 2 match per girone G e giornata D
2 { partita_giornata(P,D) :
      match(P,A,B),
      assegnazione(A,G), assegnazione(B,G)
  } 2 :- girone(G), giornata(D).

% Non può esserci tra partite diverse lo stesso scontro A–B
:- match(P1,A,B), match(P2,A,B), P1 < P2.

% Predicato di supporto: squadra T gioca in P nel giorno D
gioca(T,P,D) :- match(P,A,B), partita_giornata(P,D),T = A.
gioca(T,P,D) :- match(P,A,B), partita_giornata(P,D),T = B.

% Integrity constraint: nessuna squadra può giocare due partite diverse nello stesso giorno
:- gioca(T,P1,D), gioca(T,P2,D), P1 < P2.