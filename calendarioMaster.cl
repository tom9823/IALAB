ore_totali_master(1152).
ore_occupate_master(270).


% ————————————————————————————
% Slot orari (1–8)
% ————————————————————————————
slot(1..8).

% ————————————————————————————
% Insegnamenti, docenti e ore
% ————————————————————————————

% Progettazione di basi di dati
insegnamento(progettazione_basi_dati).
docente(mazzei).
insegna(mazzei,progettazione_basi_dati).

% Progettazione di basi di dati
insegnamento(progettazione_basi_dati).
docente(mazzei).
ore_per_insegnamento(progettazione_basi_dati,20).
insegna(mazzei,progettazione_basi_dati).

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

% ————————————————————————————————
% Definizione dei giorni della settimana di lezione del master
% ————————————————————————————————
giorno(lunedi; martedi; mercoledi; giovedi; venerdi; sabato).
% ————————————————————————————
% Insegnamenti, docenti e ore
% ————————————————————————————

% Progettazione di basi di dati
insegnamento(progettazione_basi_dati).
docente(mazzei).
ore_per_insegnamento(progettazione_basi_dati,20).
insegna(mazzetto,progettazione_basi_dati).

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

% Generazione delle lezioni normali
H { lezione(I,S,G,D,O,Rec) : settimana(S), giorno_disponibile(S,G), insegna(D,I), slot(O), recupero(0) } H :- insegnamento(I), ore_per_insegnamento(I,H).

% Esempio di presentazione master
lezione(presentazione_master,settimana1,venerdi,presentatore,1,0).
lezione(presentazione_master,settimana1,venerdi,presentatore,2,0).

% Vincoli: fino a 4 ore per docente al giorno (normali o recupero)
0 { lezione(I,S,G,Docente,O,Rec) : settimana(S), insegna(Docente,I), slot(O), recupero(Rec) } 4 :- giorno_disponibile(S,G), docente(Docente).

% Vincoli: tra 2 e 4 ore per insegnamento al giorno (normali o recupero)
2 { lezione(I,S,G,D,O,Rec) : settimana(S), giorno_disponibile(S,G), docente(D), slot(O), recupero(Rec) } 4 :- giorno_disponibile(S,G), insegnamento(I).

% Non sovrapposizione oraria
:- lezione(I1,S,G,D,O,Rec1), lezione(I2,S,G,D,O,Rec2), I1 < I2.


#show lezione/6.