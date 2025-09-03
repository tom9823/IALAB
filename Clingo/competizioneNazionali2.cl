continente(europa;nordcentroamerica;sudamerica;asia;africa;oceania).

squadra(squadra1;squadra2;squadra3;squadra4;squadra5;squadra6;squadra7;squadra8;squadra9;squadra10;squadra11;squadra12;squadra13;squadra14;squadra15;squadra16;squadra17;squadra18;squadra19;squadra20;squadra21;squadra22;squadra23;squadra24;squadra25;squadra26;squadra27;squadra28;squadra29;squadra30;squadra31;squadra32).

girone(girone1;girone2;girone3;girone4;girone5;girone6;girone7;girone8).

categoria(testaDiSerie;primaFascia;secondaFascia;underdog).

giornata(giornata1;giornata2;giornata3).


% Una squadra ha un solo continente di provenienza
1 {provenienza(X,Y):continente(Y)} 1 :- squadra(X).

numero_squadre_per_continente(C, N) :- continente(C),N = #count { S : provenienza(S,C) }.

% Europa ha esattamente 10 squadre
:- not numero_squadre_per_continente(europa, 10).

% Nordcentroamerica ha esattamente 4 squadre
:- not numero_squadre_per_continente(nordcentroamerica, 4).

% Sudamerica ha esattamente 8 squadre
:- not numero_squadre_per_continente(sudamerica, 8).

% Asia ha esattamente 4 squadre
:- not numero_squadre_per_continente(asia, 4).

% Africa ha esattamente 4 squadre
:- not numero_squadre_per_continente(africa, 4).

% Oceania ha esattamente 2 squadre
:- not numero_squadre_per_continente(oceania, 2).

% Una squadra gioca in un solo girone
1 {ha_girone(S,G): girone(G)} 1 :- squadra(S).


numero_squadre_per_girone(G, N) :- girone(G),N = #count { S : ha_girone(S,G) }.

:- girone(G), not numero_squadre_per_girone(G, 4).


% Una squadra ha una sola categoria
1 {ha_categoria(S,C): categoria(C)} 1 :- squadra(S).

% Un girone ha 4 categorie diverse
categoria_presente(G,C) :- ha_girone(S,G), ha_categoria(S,C).
numero_categorie_diverse_per_girone(G,N) :-
  girone(G),
  N = #count { C : categoria_presente(G,C) }.

:- girone(G), not numero_categorie_diverse_per_girone(G,4).

% Un girone prevede almeno 3 squadre con continenti diversi
continente_presente(G,C) :- ha_girone(S,G), provenienza(S,C).
numero_continenti_diversi_per_girone(G,N) :-
  girone(G),
  N = #count { C : continente_presente(G,C) }.

:- girone(G), not numero_continenti_diversi_per_girone(G,3).


0 { partita(S, S2, Giornata, Girone) : giornata(Giornata), ha_girone(S,Girone), ha_girone(S2,Girone), squadra(S2), S != S2 } 1 :- squadra(S), giornata(Giornata).

% nei diversi gironi stessa partita non si può ripetere ne uguale ne invertita
:- ha_girone(S1,Girone), ha_girone(S2,Girone), partita(S1, S2, Giornata1, Girone), partita(S2, S1, Giornata2, Girone), Giornata1 != Giornata2.
:- ha_girone(S1,Girone), ha_girone(S2,Girone), partita(S1, S2, Giornata1, Girone), partita(S1, S2, Giornata2, Girone), Giornata1 != Giornata2.

% per ogni giornata una squadra di un girone gioca solo una partita
:- giornata(Giornata), girone(Girone), partita(S, S2, Giornata, Girone), partita(S3, S, Giornata, Girone), S2 != S3. 
:- giornata(Giornata), girone(Girone), partita(S2, S, Giornata, Girone), partita(S3, S, Giornata, Girone), S2 != S3. 
:- giornata(Giornata), girone(Girone), partita(S, S2, Giornata, Girone), partita(S3, S, Giornata, Girone), S2 != S3. 
:- giornata(Giornata), girone(Girone), partita(S, S2, Giornata, Girone), partita(S2, S, Giornata, Girone). 


numero_partite_girone_per_giornata(Girone, Giornata ,N) :-
  girone(Girone),
  giornata(Giornata),
  N = #count { S, S2 : partita(S, S2, Giornata, Girone) }.

:- girone(Girone), giornata(Giornata), not numero_partite_girone_per_giornata(Girone, Giornata,2).

#show partita/4.

