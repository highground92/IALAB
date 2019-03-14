numPartita(1..30).
squadra(juve;toro;milan;inter;roma;lazio).
day(1..10).

partite_andata(1..15).
giorni_andata(1..5).
giorni_ritorno(6..10).

% ANDATA
{giornata(D,partita(X1,Y1),partita(X2,Y2),partita(X3,Y3)):
	squadra(X1),squadra(Y1),squadra(X2),squadra(Y2),squadra(X3),squadra(Y3),
	X1!=Y1,X1!=X2,X1!=Y2,X1!=X3,X1!=Y3,
	Y1!=X1,Y1!=X2,Y1!=Y2,Y1!=X3,Y1!=Y3,
	X2!=Y2,X2!=X1,X2!=Y1,X2!=X3,X2!=Y3,
	Y2!=X2,Y2!=X1,Y2!=Y1,Y2!=X3,Y2!=Y3,
	X3!=Y3,X3!=X1,X3!=Y1,X3!=X2,X3!=Y2,
	Y3!=X3,Y3!=X1,Y3!=Y1,Y3!=X2,Y3!=Y2
} ==1 :- giorni_andata(D).

% RITORNO
{giornata_ritorno(D,partita(X1,Y1),partita(X2,Y2),partita(X3,Y3)):
	squadra(X1),squadra(Y1),squadra(X2),squadra(Y2),squadra(X3),squadra(Y3),
	X1!=Y1,X1!=X2,X1!=Y2,X1!=X3,X1!=Y3,
	Y1!=X1,Y1!=X2,Y1!=Y2,Y1!=X3,Y1!=Y3,
	X2!=Y2,X2!=X1,X2!=Y1,X2!=X3,X2!=Y3,
	Y2!=X2,Y2!=X1,Y2!=Y1,Y2!=X3,Y2!=Y3,
	X3!=Y3,X3!=X1,X3!=Y1,X3!=X2,X3!=Y2,
	Y3!=X3,Y3!=X1,Y3!=Y1,Y3!=X2,Y3!=Y2
} ==1 :- giorni_ritorno(D).

% VINCOLI GIORNATE ANDATA/RITORNO
:- giornata(D,partita(X1,Y1),partita(_,_),partita(_,_)), giornata_ritorno(D1,partita(X1,Y1),partita(_,_),partita(_,_)), D!=D1.
:- giornata(D,partita(X1,Y1),partita(_,_),partita(_,_)), giornata_ritorno(D1,partita(_,_),partita(X1,Y1),partita(_,_)), D!=D1.
:- giornata(D,partita(X1,Y1),partita(_,_),partita(_,_)), giornata_ritorno(D1,partita(_,_),partita(_,_),partita(X1,Y1)), D!=D1.

:- giornata(D,partita(_,_),partita(X2,Y2),partita(_,_)), giornata_ritorno(D1,partita(X2,Y2),partita(_,_),partita(_,_)), D!=D1.
:- giornata(D,partita(_,_),partita(X2,Y2),partita(_,_)), giornata_ritorno(D1,partita(_,_),partita(X2,Y2),partita(_,_)), D!=D1.
:- giornata(D,partita(_,_),partita(X2,Y2),partita(_,_)), giornata_ritorno(D1,partita(_,_),partita(_,_),partita(X2,Y2)), D!=D1.

:- giornata(D,partita(_,_),partita(_,_),partita(X3,Y3)), giornata_ritorno(D1,partita(X3,Y3),partita(_,_),partita(_,_)), D!=D1.
:- giornata(D,partita(_,_),partita(_,_),partita(X3,Y3)), giornata_ritorno(D1,partita(_,_),partita(X3,Y3),partita(_,_)), D!=D1.
:- giornata(D,partita(_,_),partita(_,_),partita(X3,Y3)), giornata_ritorno(D1,partita(_,_),partita(_,_),partita(X3,Y3)), D!=D1.

giocato_in_casa(Squadra,D):-giornata(D,partita(Squadra,_),_,_).
giocato_in_casa(Squadra,D):-giornata(D,_,partita(Squadra,_),_).
giocato_in_casa(Squadra,D):-giornata(D,_,_,partita(Squadra,_)).
giocato_in_trasferta(Squadra,D):-giornata(D,partita(_,Squadra),_,_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,partita(_,Squadra),_).
giocato_in_trasferta(Squadra,D):-giornata(D,_,_,partita(_,Squadra)).

% Ogni singola partita viene giocata in una sola giornata, no duplicati (andata e ritorno sono diverse, hanno ordine squadre invertito)
%:- partita(X,Y,S), partita(X,Y,S1), S!=S1.

:- giornata(D1,X,Y,Z), giornata(D2,X,Y,Z), D1 != D2.

:- giornata(D1,X1,_,_), giornata(D2,X1,_,_), D1 != D2.
:- giornata(D1,X1,_,_), giornata(D2,_,X1,_), D1 != D2.
:- giornata(D1,X1,_,_), giornata(D2,_,_,X1), D1 != D2.

:- giornata(D1,_,Y1,_), giornata(D2,Y1,_,_), D1 != D2.
:- giornata(D1,_,Y1,_), giornata(D2,_,Y1,_), D1 != D2.
:- giornata(D1,_,Y1,_), giornata(D2,_,_,Y1), D1 != D2.

:- giornata(D1,_,_,Z1), giornata(D2,Z1,_,_), D1 != D2.
:- giornata(D1,_,_,Z1), giornata(D2,_,Z1,_), D1 != D2.
:- giornata(D1,_,_,Z1), giornata(D2,_,_,Z1), D1 != D2.

% STESSA COSA MA PER RITORNO

:- giornata_ritorno(D1,X,Y,Z), giornata_ritorno(D2,X,Y,Z), D1 != D2.

:- giornata_ritorno(D1,X1,_,_), giornata_ritorno(D2,X1,_,_), D1 != D2.
:- giornata_ritorno(D1,X1,_,_), giornata_ritorno(D2,_,X1,_), D1 != D2.
:- giornata_ritorno(D1,X1,_,_), giornata_ritorno(D2,_,_,X1), D1 != D2.

:- giornata_ritorno(D1,_,Y1,_), giornata_ritorno(D2,Y1,_,_), D1 != D2.
:- giornata_ritorno(D1,_,Y1,_), giornata_ritorno(D2,_,Y1,_), D1 != D2.
:- giornata_ritorno(D1,_,Y1,_), giornata_ritorno(D2,_,_,Y1), D1 != D2.

:- giornata_ritorno(D1,_,_,Z1), giornata(D2,Z1,_,_), D1 != D2.
:- giornata_ritorno(D1,_,_,Z1), giornata_ritorno(D2,_,Z1,_), D1 != D2.
:- giornata_ritorno(D1,_,_,Z1), giornata_ritorno(D2,_,_,Z1), D1 != D2.

% Vincoli per non avere andata e ritorno nella prima metà del campionato
:-giornata(D1, partita(X1,Y1),partita(_,_),partita(_,_)), giornata(D2, partita(Y1,X1),partita(_,_),partita(_,_)), D1 != D2.
:-giornata(D1, partita(X1,Y1),partita(_,_),partita(_,_)), giornata(D2, partita(_,_),partita(Y1,X1),partita(_,_)), D1 != D2.
:-giornata(D1, partita(X1,Y1),partita(_,_),partita(_,_)), giornata(D2, partita(_,_),partita(_,_),partita(Y1,X1)), D1 != D2.

:-giornata(D1, partita(_,_),partita(X2,Y2),partita(_,_)), giornata(D2, partita(Y2,X2),partita(_,_),partita(_,_)), D1 != D2.
:-giornata(D1, partita(_,_),partita(X2,Y2),partita(_,_)), giornata(D2, partita(_,_),partita(Y2,X2),partita(_,_)), D1 != D2.
:-giornata(D1, partita(_,_),partita(X2,Y2),partita(_,_)), giornata(D2, partita(_,_),partita(_,_),partita(Y2,X2)), D1 != D2.

:-giornata(D1, partita(_,_),partita(_,_),partita(X3,Y3)), giornata(D2, partita(Y3,X3),partita(_,_),partita(_,_)), D1 != D2.
:-giornata(D1, partita(_,_),partita(_,_),partita(X3,Y3)), giornata(D2, partita(_,_),partita(Y3,X3),partita(_,_)), D1 != D2.
:-giornata(D1, partita(_,_),partita(_,_),partita(X3,Y3)), giornata(D2, partita(_,_),partita(_,_),partita(Y3,X3)), D1 != D2.

% Ogni squadra gioca una sola volta per giornata
%:- giornata(partita(X1,Y1),partita(X1,Y2),D).
%:- giornata(partita(X1,Y1),partita(X2,X1),D).
%:- giornata(partita(X1,Y1),partita(Y1,Y2),D).
%:- giornata(partita(X1,Y1),partita(X2,Y1),D).
% Vincoli casa
:-giocato_in_casa(Squadra,D),giocato_in_casa(Squadra,D-1),giocato_in_casa(Squadra,D-2).
% Vincoli trasferta
:-giocato_in_trasferta(Squadra,D),giocato_in_trasferta(Squadra,D-1),giocato_in_trasferta(Squadra,D-2).



%#show partita/3.
#show giornata_ritorno/4.
#show giornata/4.
%#show giocato_in_casa/2.
%#show giocato_in_trasferta/2.
