continente(europa;nordcentroamerica;sudamerica;asia;africa;oceania).

squadra(squadra1;squadra2;squadra3;squadra4;squadra5;squadra6;squadra7;squadra8;squadra9;squadra10;squadra11;squadra12;squadra13;squadra14;squadra15;squadra16;squadra17;squadra18;squadra19;squadra20;squadra21;squadra22;squadra23;squadra24;squadra25;squadra26;squadra27;squadra28;squadra29;squadra30;squadra31;squadra32).

1 {provenienza(X,Y):continente(Y)} 1 :- squadra(X).
10 {provenienza(Y,europa):squadra(Y)} 10:- continente(europa).
4 {provenienza(Y,nordcentroamerica):squadra(Y)} 4:- continente(nordcentroamerica).
8 {provenienza(Y,sudamerica):squadra(Y)} 8:- continente(sudamerica).
4 {provenienza(Y,asia):squadra(Y)} 4:- continente(asia).
4 {provenienza(Y,africa):squadra(Y)} 4:- continente(africa).
2 {provenienza(Y,oceania):squadra(Y)} 2:- continente(oceania).

girone(girone1;girone2;girone3;girone4;girone5;girone6;girone7;girone8).

1 {assegnazione(X,Y):girone(Y)} 1 :- squadra(X).
4 {assegnazione(X,Y):squadra(X)} 4 :- girone(Y).

categoria(testaDiSerie;primaFascia;secondaFascia;underdog).

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

giornata(giornata1;giornata2;giornata3).

partita(partita1;partita2;partita3;partita4;partita5;partita6;partita7;partita8;partita9;partita10;partita11;partita12;partita13;partita14;partita15;partita16;partita17;partita18;partita19;partita20;partita21;partita22;partita23;partita24;partita25;partita26;partita27;partita28;partita29;partita30;partita31;partita32;partita33;partita34;partita35;partita36;partita37;partita38;partita39;partita40;partita41;partita42;partita43;partita44;partita45;partita46;partita47;partita48).

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