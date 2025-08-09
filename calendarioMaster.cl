ore_totali_master(1152).
ore_occupate_master(270).

% Predicato di supporto: week_num(settimanaN,N).
week_num(settimana1,  1).
week_num(settimana2,  2).
week_num(settimana3,  3).
week_num(settimana4,  4).
week_num(settimana5,  5).
week_num(settimana6,  6).
week_num(settimana7,  7).
week_num(settimana8,  8).
week_num(settimana9,  9).
week_num(settimana10, 10).
week_num(settimana11, 11).
week_num(settimana12, 12).
week_num(settimana13, 13).
week_num(settimana14, 14).
week_num(settimana15, 15).
week_num(settimana16, 16).
week_num(settimana17, 17).
week_num(settimana18, 18).
week_num(settimana19, 19).
week_num(settimana20, 20).
week_num(settimana21, 21).
week_num(settimana22, 22).
week_num(settimana23, 23).
week_num(settimana24, 24).

daynum(lunedi, 1).
daynum(martedi, 2).
daynum(mercoledi, 3).
daynum(giovedi, 4).
daynum(venerdi, 5).
daynum(sabato, 6).

% attivo se in (I,S,G) esiste almeno una lezione

% — relazioni propedeutiche — 

prereq(fondamenti_ict_paradigmi_programmazione, ambienti_sviluppo_linguaggi_client_side_web).
prereq(ambienti_sviluppo_linguaggi_client_side_web, progettazione_sviluppo_app_web_mobile_i).
prereq(progettazione_sviluppo_app_web_mobile_i, progettazione_sviluppo_app_web_mobile_ii).
prereq(progettazione_basi_dati, tecnologie_server_side_web).
prereq(linguaggi_markup, ambienti_sviluppo_linguaggi_client_side_web).
prereq(project_management, marketing_digitale).
prereq(marketing_digitale, tecniche_strumenti_marketing_digitale).
prereq(project_management, strumenti_metodi_interazione_social_media).
prereq(project_management, progettazione_grafica_design_interfacce).
prereq(acquisizione_elaborazione_immagini_statiche_grafica, elementi_fotografia_digitale).
prereq(elementi_fotografia_digitale, acquisizione_elaborazione_sequenze_immagini).
prereq(acquisizione_elaborazione_immagini_statiche_grafica, grafica_3d).


% Project Management
insegnamento(project_management).
docente(muzzetto).
ore_per_insegnamento(project_management,14).
insegna(muzzetto,project_management).

% Fondamenti di ICT e Paradigmi di Programmazione
insegnamento(fondamenti_ict_paradigmi_programmazione).
docente(pozzato).
ore_per_insegnamento(fondamenti_ict_paradigmi_programmazione,14).
insegna(pozzato,fondamenti_ict_paradigmi_programmazione).

% Linguaggi di markup
insegnamento(linguaggi_markup).
docente(schifanella_rossano).
ore_per_insegnamento(linguaggi_markup,20).
insegna(schifanella_rossano,linguaggi_markup).

% La gestione della qualità
insegnamento(gestione_qualita).
docente(tomatis).
ore_per_insegnamento(gestione_qualita,10).
insegna(tomatis,gestione_qualita).

% Ambienti di sviluppo e linguaggi client-side per il web
insegnamento(ambienti_sviluppo_linguaggi_client_side_web).
docente(micalizio).
ore_per_insegnamento(ambienti_sviluppo_linguaggi_client_side_web,20).
insegna(micalizio,ambienti_sviluppo_linguaggi_client_side_web).

% Progettazione grafica e design di interfacce
insegnamento(progettazione_grafica_design_interfacce).
docente(terranova).
ore_per_insegnamento(progettazione_grafica_design_interfacce,10).
insegna(terranova,progettazione_grafica_design_interfacce).

% Strumenti e metodi di interazione nei Social media
insegnamento(strumenti_metodi_interazione_social_media).
docente(giordani).
ore_per_insegnamento(strumenti_metodi_interazione_social_media,14).
insegna(giordani,strumenti_metodi_interazione_social_media).

% Acquisizione ed elaborazione di immagini statiche – grafica
insegnamento(acquisizione_elaborazione_immagini_statiche_grafica).
docente(zanchetta).
ore_per_insegnamento(acquisizione_elaborazione_immagini_statiche_grafica,14).
insegna(zanchetta,acquisizione_elaborazione_immagini_statiche_grafica).

% Accessibilità e usabilità nella progettazione multimediale
insegnamento(accessibilita_usabilita_progettazione_multimediale).
docente(gena).
ore_per_insegnamento(accessibilita_usabilita_progettazione_multimediale,14).
insegna(gena,accessibilita_usabilita_progettazione_multimediale).

% Marketing digitale
insegnamento(marketing_digitale).
docente(muzzetto).
ore_per_insegnamento(marketing_digitale,10).
insegna(muzzetto,marketing_digitale).

% Elementi di fotografia digitale
insegnamento(elementi_fotografia_digitale).
docente(vargiu).
ore_per_insegnamento(elementi_fotografia_digitale,10).
insegna(vargiu,elementi_fotografia_digitale).

% Risorse digitali per il progetto: collaborazione e documentazione
insegnamento(risorse_digitali_collaborazione_documentazione).
docente(boniolo).
ore_per_insegnamento(risorse_digitali_collaborazione_documentazione,10).
insegna(boniolo,risorse_digitali_collaborazione_documentazione).

% Tecnologie server-side per il web
insegnamento(tecnologie_server_side_web).
docente(damiano).
ore_per_insegnamento(tecnologie_server_side_web,20).
insegna(damiano,tecnologie_server_side_web).

% Tecniche e strumenti di Marketing digitale
insegnamento(tecniche_strumenti_marketing_digitale).
docente(zanchetta).
ore_per_insegnamento(tecniche_strumenti_marketing_digitale,10).
insegna(zanchetta,tecniche_strumenti_marketing_digitale).

% Introduzione al social media management
insegnamento(introduzione_social_media_management).
docente(suppini).
ore_per_insegnamento(introduzione_social_media_management,14).
insegna(suppini,introduzione_social_media_management).

% Acquisizione ed elaborazione del suono
insegnamento(acquisizione_elaborazione_suono).
docente(valle).
ore_per_insegnamento(acquisizione_elaborazione_suono,10).
insegna(valle,acquisizione_elaborazione_suono).

% Acquisizione ed elaborazione di sequenze di immagini digitali
insegnamento(acquisizione_elaborazione_sequenze_immagini).
docente(ghidelli).
ore_per_insegnamento(acquisizione_elaborazione_sequenze_immagini,20).
insegna(ghidelli,acquisizione_elaborazione_sequenze_immagini).

% Comunicazione pubblicitaria e comunicazione pubblica
insegnamento(comunicazione_pubblicitaria_pubblica).
docente(gabardi).
ore_per_insegnamento(comunicazione_pubblicitaria_pubblica,14).
insegna(gabardi,comunicazione_pubblicitaria_pubblica).

% Semiologia e multimedialità
insegnamento(semiologia_multimedialita).
docente(santangelo).
ore_per_insegnamento(semiologia_multimedialita,10).
insegna(santangelo,semiologia_multimedialita).

% Crossmedia: articolazione delle scritture multimediali
insegnamento(crossmedia_articolazione_scritture_multimediali).
docente(taddeo).
ore_per_insegnamento(crossmedia_articolazione_scritture_multimediali,20).
insegna(taddeo,crossmedia_articolazione_scritture_multimediali).

% Grafica 3D
insegnamento(grafica_3d).
docente(gribaudo).
ore_per_insegnamento(grafica_3d,20).
insegna(gribaudo,grafica_3d).

% Progettazione e sviluppo di applicazioni web su dispositivi mobile I
insegnamento(progettazione_sviluppo_app_web_mobile_i).
docente(schifanella_rossano).
ore_per_insegnamento(progettazione_sviluppo_app_web_mobile_i,10).
insegna(schifanella_rossano,progettazione_sviluppo_app_web_mobile_i).

% Progettazione e sviluppo di applicazioni web su dispositivi mobile II
insegnamento(progettazione_sviluppo_app_web_mobile_ii).
docente(schifanella_claudio).
ore_per_insegnamento(progettazione_sviluppo_app_web_mobile_ii,10).
insegna(schifanella_claudio,progettazione_sviluppo_app_web_mobile_ii).

% La gestione delle risorse umane
insegnamento(gestione_risorse_umane).
docente(lombardo).
ore_per_insegnamento(gestione_risorse_umane,10).
insegna(lombardo,gestione_risorse_umane).

% I vincoli giuridici del progetto: diritto dei media
insegnamento(diritto_media).
docente(travostino).
ore_per_insegnamento(diritto_media,10).
insegna(travostino,diritto_media).

% Corso fittizio: presentazione del master
insegnamento(presentazione_master).
docente(presentatore).
ore_per_insegnamento(presentazione_master,2).
insegna(presentatore,presentazione_master).

% Progettazione di basi di dati
insegnamento(progettazione_basi_dati).
docente(mazzei).
ore_per_insegnamento(progettazione_basi_dati,20).
insegna(mazzei,progettazione_basi_dati).

% ————————————————————————————
% Definizione delle 24 settimane del Master
% ————————————————————————————
settimana(settimana1;settimana2;settimana3;settimana4;settimana5;settimana6;settimana7;settimana8;settimana9;settimana10;settimana11;settimana12;settimana13;settimana14;settimana15;settimana16;settimana17;settimana18;settimana19;settimana20;settimana21;settimana22;settimana23;settimana24).

slot(1..8).
% ————————————————————————————————
% Definizione dei giorni della settimana di lezione del master
% ————————————————————————————————
giorno(lunedi; martedi; mercoledi; giovedi; venerdi; sabato).

giorno_disponibile(S,venerdi) :- settimana(S).
giorno_disponibile(S,sabato) :- settimana(S).
giorno_disponibile(settimana7,G) :-  giorno(G), G != venerdi, G != sabato.
giorno_disponibile(settimana16,G) :- giorno(G), G != venerdi, G != sabato.
cap_giorno(sabato, 6).
cap_giorno(G, 8) :- giorno(G), G != sabato.


% slot ammessi dato (settimana, giorno)
slot_ammissibile(S,G,O) :-
  giorno_disponibile(S,G),
  cap_giorno(G,Cap),
  slot(O), O <= Cap.

prima_lezione(0..1).
ultima_lezione(0..1).

% Generazione lezioni (solo sugli slot ammessi)
H { lezione(I,S,G,D,O,P,U)
    : insegna(D,I),
      slot_ammissibile(S,G,O),
      prima_lezione(P), ultima_lezione(U)
  } H
  :- insegnamento(I), ore_per_insegnamento(I,H), I != presentazione_master,
     I != tecnologie_server_side_web.

% Ore giornaliere per corso — lezioni normali 
ore_lezione_giorno_per_insegnamento(I,S,G,N) :-
  insegnamento(I), giorno_disponibile(S,G),
  N = #count { O : lezione(I,S,G,_,O,_,_) }.

% Ore giornaliere per corso — recuperi start
ore_rec_start_giorno_per_insegnamento(I,S,G,N) :-
  insegnamento(I), giorno_disponibile(S,G),
  N = #count { O : rec_start(I,S,G,_,O) }.

% Ore giornaliere per corso — recuperi end
ore_rec_end_giorno_per_insegnamento(I,S,G,N) :-
  insegnamento(I), giorno_disponibile(S,G),
  N = #count { O : rec_end(I,S,G,_,O) }.

% Somma totale ore (lezioni normali + recuperi start + recuperi end)
ore_giorno_per_insegnamento(I,S,G,N) :-
  ore_lezione_giorno_per_insegnamento(I,S,G,N1),
  ore_rec_start_giorno_per_insegnamento(I,S,G,N2),
  ore_rec_end_giorno_per_insegnamento(I,S,G,N3),
  N = N1 + N2 + N3.

% Ammontare giornaliero ammesso per ciascun corso:
%  - vietato 1
%  - vietato >4
:- ore_giorno_per_insegnamento(I,S,G,1).
:- ore_giorno_per_insegnamento(I,S,G,N), N > 4.

% ogni corso ha esattamente una “prima” lezione
1 { lezione(I,S,G,D,O,1,0) 
    : slot_ammissibile(S,G,O),
      insegna(D,I),
      slot(O)
  } 1 
  :- insegnamento(I).

% ogni corso ha esattamente una “ultima” lezione
1 { lezione(I,S,G,D,O,0,1) 
    : slot_ammissibile(S,G,O),

      insegna(D,I),
      slot(O)
  } 1 
  :- insegnamento(I).

% non può esserci una lezione marcata sia come “prima” che come “ultima” se si ha più di un'ora di insegnamento per quel corso
:- lezione(I, S, G, D, O,  1, 1), ore_per_insegnamento(I,H), H != 1.

% First lesson: nessuna lezione in settimana minore
:- lezione(C,S1,_,_,O1,1,_), lezione(C,S2,_,_,O2,_,_), week_num(S2,N2), week_num(S1,N1), N2 < N1.

% First lesson: nessuna lezione in stesso S ma giorno minore
:- lezione(C,S,G1,_,O1,1,_), lezione(C,S,G2,_,O2,_,_), daynum(G2,D2), daynum(G1,D1), D2 < D1.

% First lesson: nessuna lezione in stesso S,G ma slot minore
:- lezione(C,S,G,_,O1,1,_), lezione(C,S,G,_,O2,_,_), O2 < O1.


% Last lesson: nessuna lezione in settimana maggiore
:- lezione(C,S1,_,_,O1,_,1), lezione(C,S2,_,_,O2,_,_), week_num(S2,N2), week_num(S1,N1), N2 > N1.

% Last lesson: nessuna lezione in stesso S ma giorno maggiore
:- lezione(C,S,G1,_,O1,_,1), lezione(C,S,G2,_,O2,_,_), daynum(G2,D2), daynum(G1,D1), D2 > D1.

% Last lesson: nessuna lezione in stesso S,G ma slot maggiore
:- lezione(C,S,G,_,O1,_,1), lezione(C,S,G,_,O2,_,_), O2 > O1.


% presentazione master
lezione(presentazione_master, settimana1, venerdi, presentatore, 1, 1, 0).
lezione(presentazione_master, settimana1, venerdi, presentatore, 2, 0, 1).

% Integrity constraint: Project Management deve concludersi entro la settimana 7
:- lezione(project_management, S, G, D, O, P, U),
   week_num(S, W),
   W > 7.


% vincolo per settimane diverse usando week_num
:- prereq(P,C),
   lezione(P, WS1, _, _, _,  _, _),
   lezione(C, WS2, _, _, _,  _, _),
   week_num(WS1, N1),
   week_num(WS2, N2),
   N1 > N2.

% vincolo per stessa settimana, ordinamento per giorno
:- prereq(P,C),
   lezione(P, W, Gp, _,  _, _, _),
   lezione(C, W, Gc, _, _, _, _),
   daynum(Gp, Dp),
   daynum(Gc, Dc),
   Dp > Dc.

% vincolo per stesso giorno, ordinamento per slot
:- prereq(P,C),
   lezione(P, W, G, Tp, _, _, _),
   lezione(C, W, G, Tc, _, _, _),
   Tp >= Tc.


% La distanza tra prima e ultima lezione dell’insegnamento I non supera 8 settimane
:- lezione(I,S1,_,_,_,1,0),
   lezione(I,S2,_,_,_,0,1),
   week_num(S1,N1),
   week_num(S2,N2),
   N2 - N1 > 8.

% La prima lezione di A&U deve essere prima dell'ULTIMA di Linguaggi di markup

% (1) settimana: vietato se la prima di A&U è in una settimana successiva all’ultima di LM
:- lezione(accessibilita_usabilita_progettazione_multimediale, S1, _, _, O1, 1, _),
   lezione(linguaggi_markup,S2, _, _, O2, _, 1),
   week_num(S1, N1), week_num(S2, N2), N1 > N2.

% (2) stesso S, giorno: vietato se la prima di A&U è in un giorno successivo all’ultima di LM
:- lezione(accessibilita_usabilita_progettazione_multimediale, S, G1, _, O1,  1, _),
   lezione(linguaggi_markup, S, G2, _, O2,  _, 1),
   daynum(G1, D1), daynum(G2, D2), D1 > D2.

% (3) stesso S e G, slot: vietato se la prima di A&U non è strettamente prima dell’ultima di LM
:- lezione(accessibilita_usabilita_progettazione_multimediale, S, G, _, O1,  1, _),
   lezione(linguaggi_markup, S, G, _, O2, _, 1),
   O1 >= O2.

% seconda settimana full-time
seconda_fulltime(16).

% Crossmedia: la prima lezione deve stare nella settimana 16
:- lezione(crossmedia_articolazione_scritture_multimediali, S, _, _, _, 1, _),
   week_num(S, N), seconda_fulltime(M), N != M.

% Introduzione al social media management: idem
:- lezione(introduzione_social_media_management, S, _, _, _,  1, _),
   week_num(S, N), seconda_fulltime(M), N != M.

lezione(tecnologie_server_side_web,settimana15,sabato,damiano,1,1,0).
lezione(tecnologie_server_side_web,settimana15,sabato,damiano,2,0,0).
lezione(tecnologie_server_side_web,settimana15,sabato,damiano,3,0,0).
lezione(tecnologie_server_side_web,settimana15,sabato,damiano,4,0,0).

lezione(tecnologie_server_side_web,settimana16,sabato,damiano,1,0,0).
lezione(tecnologie_server_side_web,settimana16,sabato,damiano,2,0,0).
lezione(tecnologie_server_side_web,settimana16,sabato,damiano,3,0,0).
lezione(tecnologie_server_side_web,settimana16,sabato,damiano,4,0,0).

lezione(tecnologie_server_side_web,settimana17,sabato,damiano,1,0,0).
lezione(tecnologie_server_side_web,settimana17,sabato,damiano,2,0,0).
lezione(tecnologie_server_side_web,settimana17,sabato,damiano,3,0,0).
lezione(tecnologie_server_side_web,settimana17,sabato,damiano,4,0,0).

lezione(tecnologie_server_side_web,settimana18,sabato,damiano,1,0,0).
lezione(tecnologie_server_side_web,settimana18,sabato,damiano,2,0,0).
lezione(tecnologie_server_side_web,settimana18,sabato,damiano,3,0,0).
lezione(tecnologie_server_side_web,settimana18,sabato,damiano,4,0,0).

lezione(tecnologie_server_side_web,settimana19,sabato,damiano,1,0,0).
lezione(tecnologie_server_side_web,settimana19,sabato,damiano,2,0,0).
lezione(tecnologie_server_side_web,settimana19,sabato,damiano,3,0,0).
lezione(tecnologie_server_side_web,settimana19,sabato,damiano,4,0,1).


% -------------------------------------------------------
% SLOT SUCCESSIVO (stesso S,G, O+1 ammesso)
% -------------------------------------------------------
next_slot(S,G,O,O1) :-
    slot_ammissibile(S,G,O),
    O1 = O + 1,
    slot_ammissibile(S,G,O1).

% -------------------------------------------------------
% RECUPERI: GENERA ESATTAMENTE 3 "START" (Rec=1,P=1,U=0)
% solo su slot non usati da lezioni normali
% -------------------------------------------------------
3 { rec_start(I,S,G,D,O)
    : insegnamento(I),
      insegna(D,I),
      slot_ammissibile(S,G,O),
      not lezione(_,S,G,_,O,_,_)    % evita slot occupati
  } 3 :- insegnamento(I).


% -------------------------------------------------------
% AUTO-FINALE: per ogni start crea il "finale" (Rec=1,P=0,U=1) nello slot successivo
% -------------------------------------------------------
% deve esistere lo slot successivo
:- rec_start(I,S,G,D,O), not next_slot(S,G,O,_).

% lo slot successivo non deve essere occupato da lezioni normali
:- rec_start(I,S,G,D,O), next_slot(S,G,O,O1), lezione(_,S,G,_,O1,_,_).

% genera il "finale" automaticamente
rec_end(I,S,G,D,O1) :-
    rec_start(I,S,G,D,O),
    next_slot(S,G,O,O1).

% -------------------------------------------------------
% CARDINALITÀ “3 e 3”: esattamente 3 start e 3 finali per ogni corso con recupero
% -------------------------------------------------------
:- insegnamento(I),
   3 != #count { S,G,D,O : rec_start(I,S,G,D,O) }.

:- insegnamento(I),
   3 != #count { S,G,D,O : rec_end(I,S,G,D,O) }.

% ============================
% Max 4 ore per docente al giorno (lezioni + recuperi)
% ============================
:- docente(D), settimana(S), giorno_disponibile(S,G),
   5 { lezione(_,S,G,D,O,_,_) : slot_ammissibile(S,G,O);
       rec_start(_,S,G,D,O)     : slot_ammissibile(S,G,O);
       rec_end(_,S,G,D,O)       : slot_ammissibile(S,G,O) }.

% ===================================================
% Al massimo UNA attività per docente nello stesso slot
% (vale per lezione normale e per recuperi start/end)
% ===================================================
:- docente(D), settimana(S), giorno_disponibile(S,G), slot_ammissibile(S,G,O),
   2 { lezione(_,S,G,D,O,_,_);
       rec_start(_,S,G,D,O);
       rec_end(_,S,G,D,O) }.

#show lezione/7.
#show rec_start/5.
#show rec_end/5.