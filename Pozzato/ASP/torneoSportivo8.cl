squadra(juve;toro;milan;inter;roma;lazio;genoa;napoli).

stadio(juve,juventus_stadium).
stadio(toro,olimpico_torino).
stadio(milan,san_siro).
stadio(inter,san_siro).
stadio(roma,olimpico_roma).
stadio(lazio,olimpico_roma).
stadio(napoli,san_paolo).
stadio(genoa,luigi_ferraris).

giorni(1..14).

% Giornate del campionato
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
} ==1 :- giorni(D).

%Le partite di ritorno vengono fatte alla stessa distanza
:- giornata(D,partita(X1,Y1,_),partita(X2,Y2,_),partita(X3,Y3,_),partita(X4,Y4,_)), not giornata(D+7,partita(Y1,X1,_),partita(Y2,X2,_),partita(Y3,X3,_),partita(Y4,X4,_)), D<8.

giocato_in_casa(Squadra,D):-giornata(D,partita(Squadra,_,_),_,_,_).
giocato_in_casa(Squadra,D):-giornata(D,_,partita(Squadra,_,_),_,_).
giocato_in_casa(Squadra,D):-giornata(D,_,_,partita(Squadra,_,_),_).
giocato_in_casa(Squadra,D):-giornata(D,_,_,_,partita(Squadra,_,_)).
giocato_in_trasferta(Squadra,D):-giornata(D,partita(_,Squadra,_),_,_,_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,partita(_,Squadra,_),_,_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,_,partita(_,Squadra,_),_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,_,_,partita(_,Squadra,_)).

% Ogni partita viene giocata in un'unica giornata e non può essere ripetuta

:- giornata(D1,X,Y,Z,W), giornata(D2,X,Y,Z,W), D1 != D2.

:- giornata(D1,X,_,_,_), giornata(D2,X,_,_,_), D1 != D2.
:- giornata(D1,X,_,_,_), giornata(D2,_,X,_,_), D1 != D2.
:- giornata(D1,X,_,_,_), giornata(D2,_,_,X,_), D1 != D2.
:- giornata(D1,X,_,_,_), giornata(D2,_,_,_,X), D1 != D2.

:- giornata(D1,_,Y,_,_), giornata(D2,Y,_,_,_), D1 != D2.
:- giornata(D1,_,Y,_,_), giornata(D2,_,Y,_,_), D1 != D2.
:- giornata(D1,_,Y,_,_), giornata(D2,_,_,Y,_), D1 != D2.
:- giornata(D1,_,Y,_,_), giornata(D2,_,_,_,Y), D1 != D2.


:- giornata(D1,_,_,Z,_), giornata(D2,Z,_,_,_), D1 != D2.
:- giornata(D1,_,_,Z,_), giornata(D2,_,Z,_,_), D1 != D2.
:- giornata(D1,_,_,Z,_), giornata(D2,_,_,Z,_), D1 != D2.
:- giornata(D1,_,_,Z,_), giornata(D2,_,_,_,Z), D1 != D2.

:- giornata(D1,_,_,_,W), giornata(D2,W,_,_,_), D1 != D2.
:- giornata(D1,_,_,_,W), giornata(D2,_,W,_,_), D1 != D2.
:- giornata(D1,_,_,_,W), giornata(D2,_,_,W,_), D1 != D2.
:- giornata(D1,_,_,_,W), giornata(D2,_,_,_,W), D1 != D2.

% Prima metà campionato
% Vincoli casa
:-giocato_in_casa(Squadra,D),giocato_in_casa(Squadra,D-1),giocato_in_casa(Squadra,D-2).
% Vincoli trasferta
:-giocato_in_trasferta(Squadra,D),giocato_in_trasferta(Squadra,D-1),giocato_in_trasferta(Squadra,D-2).

#show giornata/5.

