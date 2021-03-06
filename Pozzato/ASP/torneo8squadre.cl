numPartita(1..56).
squadra(juve;toro;milan;inter;roma;lazio;genoa;napoli).
day(1..14).

stadio(juve,juventus_stadium).
stadio(toro,olimpico_torino).
stadio(milan,san_siro).
stadio(inter,san_siro).
stadio(roma,olimpico_roma).
stadio(lazio,olimpico_roma).
stadio(napoli,san_paolo).
stadio(genoa,luigi_ferraris).

giorni_a(1..7).
giorni_b(8..14).

% Giornate Prima Metà Campionato
{giornata(D,partita(X1,Y1,S1),partita(X2,Y2,S2),partita(X3,Y3,S3),partita(X4,Y4,S4)):
	squadra(X1),squadra(Y1),squadra(X2),squadra(Y2),squadra(X3),squadra(Y3),squadra(X4),squadra(Y4),
	stadio(X1,S1),stadio(X2,S2),stadio(X3,S3),stadio(X4,S4),
	X1!=Y1,X1!=X2,X1!=Y2,X1!=X3,X1!=Y3,X1!=X4,X1!=Y4,
	Y1!=X1,Y1!=X2,Y1!=Y2,Y1!=X3,Y1!=Y3,Y1!=X4,Y1!=Y4,
	X2!=Y2,X2!=X1,X2!=Y1,X2!=X3,X2!=Y3,X2!=X4,X2!=Y4,
	Y2!=X2,Y2!=X1,Y2!=Y1,Y2!=X3,Y2!=Y3,Y2!=X4,Y2!=Y4,
	X3!=Y3,X3!=X1,X3!=Y1,X3!=X2,X3!=Y2,X3!=X4,Y3!=Y4,
	Y3!=X3,Y3!=X1,Y3!=Y1,Y3!=X2,Y3!=Y2,Y3!=X4,Y3!=Y4,
	X4!=Y4,X4!=X1,X4!=Y1,X4!=X2,X4!=Y2,X4!=X3,X4!=Y3,
	Y4!=X4,Y4!=X1,Y4!=Y1,Y4!=X2,Y4!=Y2,Y4!=X3,Y4!=Y3
} ==1 :- giorni_a(D).

% Giornate Seconda Metà Campionato
{giornata_b(D,partita(X1,Y1,S1),partita(X2,Y2,S2),partita(X3,Y3,S3),partita(X4,Y4,S4)):
	squadra(X1),squadra(Y1),squadra(X2),squadra(Y2),squadra(X3),squadra(Y3),squadra(X4),squadra(Y4),
	stadio(X1,S1),stadio(X2,S2),stadio(X3,S3),stadio(X4,S4),
	X1!=Y1,X1!=X2,X1!=Y2,X1!=X3,X1!=Y3,X1!=X4,X1!=Y4,
	Y1!=X1,Y1!=X2,Y1!=Y2,Y1!=X3,Y1!=Y3,Y1!=X4,Y1!=Y4,
	X2!=Y2,X2!=X1,X2!=Y1,X2!=X3,X2!=Y3,X2!=X4,X2!=Y4,
	Y2!=X2,Y2!=X1,Y2!=Y1,Y2!=X3,Y2!=Y3,Y2!=X4,Y2!=Y4,
	X3!=Y3,X3!=X1,X3!=Y1,X3!=X2,X3!=Y2,X3!=X4,Y3!=Y4,
	Y3!=X3,Y3!=X1,Y3!=Y1,Y3!=X2,Y3!=Y2,Y3!=X4,Y3!=Y4,
	X4!=Y4,X4!=X1,X4!=Y1,X4!=X2,X4!=Y2,X4!=X3,X4!=Y3,
	Y4!=X4,Y4!=X1,Y4!=Y1,Y4!=X2,Y4!=Y2,Y4!=X3,Y4!=Y3
} ==1 :- giorni_b(D).

% VINCOLI GIORNATE (NO DUPLICATI TRA PRIMA E SECONDA META' CAMPIONATO)
%:- giornata(D,partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(Y1,X1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), D1!=D+7.
%:- giornata(D,partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(Y1,X1,_),partita(_,_,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(Y1,X1,_),partita(_,_,_)), D1!=D+7.
%:- giornata(D,partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y1,X1,_)), D1!=D+7.

%:- giornata(D,partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(Y2,X2,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(Y2,X2,_),partita(_,_,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(Y2,X2,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y2,X2,_)),  D1!=D+7.

%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata_b(D1,partita(Y3,X3,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(Y3,X3,_),partita(_,_,_),partita(_,_,_)), D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(Y3,X3,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y3,X3,_)),  D1!=D+7.

%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata_b(D1,partita(Y4,X4,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata_b(D1,partita(_,_,_),partita(Y4,X4,_),partita(_,_,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(Y4,X4,_),partita(_,_,_)),  D1!=D+7.
%:- giornata(D,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata_b(D1,partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y4,X4,_)),  D1!=D+7.
:- giornata(D,partita(X1,Y1,_),partita(X2,Y2,_),partita(X3,Y3,_),partita(X4,Y4,_)), not giornata_b(D+7,partita(Y1,X1,_),partita(Y2,X2,_),partita(Y3,X3,_),partita(Y4,X4,_)).

giocato_in_casa(Squadra,D):-giornata(D,partita(Squadra,_,_),_,_,_).
giocato_in_casa(Squadra,D):-giornata(D,_,partita(Squadra,_,_),_,_).
giocato_in_casa(Squadra,D):-giornata(D,_,_,partita(Squadra,_,_),_).
giocato_in_casa(Squadra,D):-giornata(D,_,_,_,partita(Squadra,_,_)).
giocato_in_trasferta(Squadra,D):-giornata(D,partita(_,Squadra,_),_,_,_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,partita(_,Squadra,_),_,_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,_,partita(_,Squadra,_),_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,_,_,partita(_,Squadra,_)).

giocato_in_casa_b(Squadra,D):-giornata(D,partita(Squadra,_,_),_,_,_).
giocato_in_casa_b(Squadra,D):-giornata(D,_,partita(Squadra,_,_),_,_).
giocato_in_casa_b(Squadra,D):-giornata(D,_,_,partita(Squadra,_,_),_).
giocato_in_casa_b(Squadra,D):-giornata(D,_,_,_,partita(Squadra,_,_)).
giocato_in_trasferta_b(Squadra,D):-giornata(D,partita(_,Squadra,_),_,_,_).
giocato_in_trasferta_b(Squadra,D):-giornata(D,_,partita(_,Squadra,_),_,_).
giocato_in_trasferta_b(Squadra,D):-giornata(D,_,_,partita(_,Squadra,_),_).
giocato_in_trasferta_b(Squadra,D):-giornata(D,_,_,_,partita(_,Squadra,_)).

% Ogni singola partita viene giocata in una sola giornata, no duplicati (andata e ritorno sono diverse, hanno ordine squadre invertito)

:- giornata(D1,X,Y,Z,W), giornata(D2,X,Y,Z,W), D1 != D2.

:- giornata(D1,X1,_,_,_), giornata(D2,X1,_,_,_), D1 != D2.
:- giornata(D1,X1,_,_,_), giornata(D2,_,X1,_,_), D1 != D2.
:- giornata(D1,X1,_,_,_), giornata(D2,_,_,X1,_), D1 != D2.
:- giornata(D1,X1,_,_,_), giornata(D2,_,_,_,X1), D1 != D2.

:- giornata(D1,_,Y1,_,_), giornata(D2,Y1,_,_,_), D1 != D2.
:- giornata(D1,_,Y1,_,_), giornata(D2,_,Y1,_,_), D1 != D2.
:- giornata(D1,_,Y1,_,_), giornata(D2,_,_,Y1,_), D1 != D2.
:- giornata(D1,_,Y1,_,_), giornata(D2,_,_,_,Y1), D1 != D2.


:- giornata(D1,_,_,Z1,_), giornata(D2,Z1,_,_,_), D1 != D2.
:- giornata(D1,_,_,Z1,_), giornata(D2,_,Z1,_,_), D1 != D2.
:- giornata(D1,_,_,Z1,_), giornata(D2,_,_,Z1,_), D1 != D2.
:- giornata(D1,_,_,Z1,_), giornata(D2,_,_,_,Z1), D1 != D2.

:- giornata(D1,_,_,_,W1), giornata(D2,W1,_,_,_), D1 != D2.
:- giornata(D1,_,_,_,W1), giornata(D2,_,W1,_,_), D1 != D2.
:- giornata(D1,_,_,_,W1), giornata(D2,_,_,W1,_), D1 != D2.
:- giornata(D1,_,_,_,W1), giornata(D2,_,_,_,W1), D1 != D2.

% no partite duplicate per seconda metà campionato

%:- giornata_b(D1,X,Y,Z,W), giornata_b(D2,X,Y,Z,W), D1 != D2.

%:- giornata_b(D1,X1,_,_,_), giornata_b(D2,X1,_,_,_), D1 != D2.
%:- giornata_b(D1,X1,_,_,_), giornata_b(D2,_,X1,_,_), D1 != D2.
%:- giornata_b(D1,X1,_,_,_), giornata_b(D2,_,_,X1,_), D1 != D2.
%:- giornata_b(D1,X1,_,_,_), giornata_b(D2,_,_,_,X1), D1 != D2.
%:- giornata_b(D1,X1,_,_,_), not giornata_b(D1,X1,_,_,_).

%:- giornata_b(D1,_,Y1,_,_), giornata_b(D2,Y1,_,_,_), D1 != D2.
%:- giornata_b(D1,_,Y1,_,_), giornata_b(D2,_,Y1,_,_), D1 != D2.
%:- giornata_b(D1,_,Y1,_,_), giornata_b(D2,_,_,Y1,_), D1 != D2.
%:- giornata_b(D1,_,Y1,_,_), giornata_b(D2,_,_,_,Y1), D1 != D2.
%:- giornata_b(D1,_,Y1,_,_), not giornata_b(D1,_,Y1,_,_).


%:- giornata_b(D1,_,_,Z1,_), giornata_b(D2,Z1,_,_,_), D1 != D2.
%:- giornata_b(D1,_,_,Z1,_), giornata_b(D2,_,Z1,_,_), D1 != D2.
%:- giornata_b(D1,_,_,Z1,_), giornata_b(D2,_,_,Z1,_), D1 != D2.
%:- giornata_b(D1,_,_,Z1,_), giornata_b(D2,_,_,_,Z1), D1 != D2.
%:- giornata_b(D1,_,_,Z1,_), not giornata_b(D1,_,_,Z1,_).

%:- giornata_b(D1,_,_,_,W1), giornata_b(D2,W1,_,_,_), D1 != D2.
%:- giornata_b(D1,_,_,_,W1), giornata_b(D2,_,W1,_,_), D1 != D2.
%:- giornata_b(D1,_,_,_,W1), giornata_b(D2,_,_,W1,_), D1 != D2.
%:- giornata_b(D1,_,_,_,W1), giornata_b(D2,_,_,_,W1), D1 != D2.
%:- giornata_b(D1,_,_,_,W1), not giornata_b(D1,_,_,_,W1).

% Vincoli per non avere andata e ritorno nella prima metà del campionato
:-giornata(D1, partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(Y1,X1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(Y1,X1,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(Y1,X1,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(X1,Y1,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y1,X1,_)), D1 != D2.

:-giornata(D1, partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(Y2,X2,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(Y2,X2,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(Y2,X2,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(X2,Y2,_),partita(_,_,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y2,X2,_)), D1 != D2.

:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata(D2, partita(Y3,X3,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(Y3,X3,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(Y3,X3,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(X3,Y3,_),partita(_,_,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(Y3,X3,_)), D1 != D2.

:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata(D2, partita(X4,Y4,_),partita(_,_,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata(D2, partita(_,_,_),partita(X4,Y4,_),partita(_,_,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(X4,Y4,_),partita(_,_,_)), D1 != D2.
:-giornata(D1, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), giornata(D2, partita(_,_,_),partita(_,_,_),partita(_,_,_),partita(X4,Y4,_)), D1 != D2.

% Prima metà campionato
% Vincoli casa
:-giocato_in_casa(Squadra,D),giocato_in_casa(Squadra,D-1),giocato_in_casa(Squadra,D-2).
% Vincoli trasferta
:-giocato_in_trasferta(Squadra,D),giocato_in_trasferta(Squadra,D-1),giocato_in_trasferta(Squadra,D-2).

% Seconda metà campionato
% Vincoli casa
:-giocato_in_casa_b(Squadra,D),giocato_in_casa_b(Squadra,D-1),giocato_in_casa_b(Squadra,D-2).
% Vincoli trasferta
:-giocato_in_trasferta_b(Squadra,D),giocato_in_trasferta_b(Squadra,D-1),giocato_in_trasferta_b(Squadra,D-2).



#show giornata_b/5.
#show giornata/5.

