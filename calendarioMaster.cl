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


% ————————————————————————————
% Insegnamenti, docenti e ore
% ————————————————————————————

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
giorno_disponibile(settimana7,G) :-  giorno(G).
giorno_disponibile(settimana16,G) :- giorno(G).

recupero(0..1).
prima_lezione(0..1).
ultima_lezione(0..1).

% Generazione delle lezioni normali
H { lezione(I,S,G,D,O,0,P,U) 
    : settimana(S),
      giorno_disponibile(S,G),
      insegna(D,I),
      slot(O),
      prima_lezione(P),
      ultima_lezione(U)
  } H 
  :- insegnamento(I), 
     ore_per_insegnamento(I,H).
% ogni corso ha esattamente una “prima” lezione
1 { lezione(I,S,G,D,O,0,1,0) 
    : settimana(S),
      giorno_disponibile(S,G),
      insegna(D,I),
      slot(O)
  } 1 
  :- insegnamento(I).
  % ogni corso ha esattamente una “ultima” lezione
1 { lezione(I,S,G,D,O,0,0,1) 
    : settimana(S),
      giorno_disponibile(S,G),
      insegna(D,I),
      slot(O)
  } 1 
  :- insegnamento(I).

% ———————————————————————————————
% non può esserci una lezione marcata sia come “prima” che come “ultima”
% ———————————————————————————————
:- lezione(I, S, G, D, O, Rec, 1, 1).

% —————————————————————————————
% First lesson: nessuna lezione in settimana minore
% —————————————————————————————
:- lezione(C,S1,_,_,O1,_,1,_), lezione(C,S2,_,_,O2,_,_,_), week_num(S2,N2), week_num(S1,N1), N2 < N1.

% First lesson: nessuna lezione in stesso S ma giorno minore
:- lezione(C,S,G1,_,O1,_,1,_), lezione(C,S,G2,_,O2,_,_,_), daynum(G2,D2), daynum(G1,D1), D2 < D1.

% First lesson: nessuna lezione in stesso S,G ma slot minore
:- lezione(C,S,G,_,O1,_,1,_), lezione(C,S,G,_,O2,_,_,_), O2 < O1.

% —————————————————————————————
% Last lesson: nessuna lezione in settimana maggiore
% —————————————————————————————
:- lezione(C,S1,_,_,O1,_,_,1), lezione(C,S2,_,_,O2,_,_,_), week_num(S2,N2), week_num(S1,N1), N2 > N1.

% Last lesson: nessuna lezione in stesso S ma giorno maggiore
:- lezione(C,S,G1,_,O1,_,_,1), lezione(C,S,G2,_,O2,_,_,_), daynum(G2,D2), daynum(G1,D1), D2 > D1.

% Last lesson: nessuna lezione in stesso S,G ma slot maggiore
:- lezione(C,S,G,_,O1,_,_,1), lezione(C,S,G,_,O2,_,_,_), O2 > O1.


% Esempio di presentazione master
lezione(presentazione_master, settimana1, venerdi, presentatore, 1, 0, 1, 0).
lezione(presentazione_master, settimana1, venerdi, presentatore, 2, 0, 0, 1).


% Vincolo: massimo 4 ore (normali o recupero) per docente D in ciascuna (S,G)
0 { lezione(I, S, G, D, O, Rec, P, U)
  : settimana(S),
    giorno_disponibile(S, G),
    insegna(D, I),
    slot(O),
    recupero(Rec),
    prima_lezione(P),
    ultima_lezione(U)
} 4
  :- docente(D), giorno_disponibile(S, G).

% al massimo una lezione per docente D in ciascuna (settimana S, giorno G, slot O)
0 { lezione(I, S, G, D, O, Rec, P, U)
  : insegna(D, I),
    recupero(Rec),
    prima_lezione(P),
    ultima_lezione(U)
} 1
  :- settimana(S), giorno_disponibile(S, G), slot(O).



% Integrity constraint: Project Management deve concludersi entro la settimana 9
:- lezione(project_management, S, G, D, O, Rec, P, U),
   week_num(S, W),
   W > 9.


% vincolo per settimane diverse usando week_num
:- prereq(P,C),
   lezione(P, WS1, _, _, _, _, _, _),
   lezione(C, WS2, _, _, _, _, _, _),
   week_num(WS1, N1),
   week_num(WS2, N2),
   N1 > N2.

% vincolo per stessa settimana, ordinamento per giorno
:- prereq(P,C),
   lezione(P, W, Gp, _, _, _, _, _),
   lezione(C, W, Gc, _, _, _, _, _),
   daynum(Gp, Dp),
   daynum(Gc, Dc),
   Dp > Dc.

% vincolo per stesso giorno, ordinamento per slot
:- prereq(P,C),
   lezione(P, W, G, Tp, _, _, _, _),
   lezione(C, W, G, Tc, _, _, _, _),
   Tp >= Tc.


0 { lezione(I,S,G,D,O,Rec,P,U)
    : insegnamento(I),
      insegna(D,I),
      recupero(Rec),
      prima_lezione(P),
      ultima_lezione(U)
  } 1
  :- docente(D), settimana(S), giorno_disponibile(S,G), slot(O).

% al massimo una lezione per docente D in ciascuna (settimana S, giorno G, slot O)
0 { lezione(I, S, G, D, O, Rec, P, U)
  : insegnamento(I),
    insegna(D, I),
    slot(O),
    recupero(Rec),
    prima_lezione(P),
    ultima_lezione(U)
} 1
  :- docente(D), settimana(S), giorno_disponibile(S, G), slot(O).

% vincolo: per ogni insegnamento I, settimana S e giorno G
% devono esserci tra 2 e 4 lezioni (normali o recupero)
2 { lezione(I, S, G, D, O, Rec, P, U) :
      insegna(D, I),
      slot(O),
      recupero(Rec),
      prima_lezione(P),
      ultima_lezione(U)
  } 4
  :- insegnamento(I), settimana(S), day(G).
#show lezione/8.