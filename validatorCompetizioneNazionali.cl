% === validator.cl ===

% Cardinalità globali
:- #count{S:squadra(S)} != 32.
:- #count{G:girone(G)} != 8.
:- #count{C:categoria(C)} != 4.
:- #count{J:giornata(J)} != 3.

% Distribuzione per continente
:- #count{S: provenienza(S,europa)} != 10.
:- #count{S: provenienza(S,nordcentroamerica)} != 4.
:- #count{S: provenienza(S,sudamerica)} != 8.
:- #count{S: provenienza(S,asia)} != 4.
:- #count{S: provenienza(S,africa)} != 4.
:- #count{S: provenienza(S,oceania)} != 2.

% Assegnazioni ai gironi
:- squadra(S), #count{G: assegnazione(S,G)} != 1.
:- girone(G), #count{S: assegnazione(S,G)} != 4.

% Fasce: una per squadra, e in ogni girone esattamente una per fascia
:- squadra(S), #count{C: fascia(S,C)} != 1.
:- girone(G), categoria(C), #count{S: assegnazione(S,G), fascia(S,C)} != 1.

% Ogni girone rappresenta almeno 3 continenti
cont_in_girone(G,C) :- assegnazione(S,G), provenienza(S,C).
:- girone(G), #count{C: cont_in_girone(G,C)} < 3.

% Partite: coerenza strutturale
:- match(P,S1,S2), assegnazione(S1,G1), assegnazione(S2,G2), G1 != G2.
:- match(P,_,_), #count{J: partita_giornata(P,J)} != 1.

% Totale partite: 6 per girone (= round robin a 4)
:- girone(G),
   #count{P: match(P,S1,S2), assegnazione(S1,G), assegnazione(S2,G)} != 6.

% Per giornata: 2 partite per girone
:- girone(G), giornata(J),
   #count{P: partita_giornata(P,J), match(P,S1,S2),
          assegnazione(S1,G), assegnazione(S2,G)} != 2.

% Ogni squadra gioca esattamente una volta per giornata
:- squadra(S), giornata(J),
   #count{P: partita_giornata(P,J), match(P,S,_);
          P: partita_giornata(P,J), match(P,_,S)} != 1.

% Ogni coppia nello stesso girone si affronta esattamente una volta
:- assegnazione(S1,G), assegnazione(S2,G), S1 < S2,
   #count{P: match(P,S1,S2); P: match(P,S2,S1)} != 1.

% Coerenza con 'gioca/3'
:- gioca(S,P,J), not partita_giornata(P,J).
:- gioca(S,P,J), not match(P,S,_), not match(P,_,S).
:- partita_giornata(P,J), #count{S: gioca(S,P,J)} != 2.
:- match(P,S1,S2), partita_giornata(P,J), not gioca(S1,P,J).
:- match(P,S1,S2), partita_giornata(P,J), not gioca(S2,P,J).
