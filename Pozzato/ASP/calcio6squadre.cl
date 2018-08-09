numPartita(1..30).
squadra(juve;toro;milan;inter;roma;lazio).
day(1..10).


{partita(X,Y,S): squadra(X),squadra(Y),X!=Y} ==1 :- numPartita(S).
{giornata(partita(X1,Y1),partita(X2,Y2),partita(X3,Y3),D): partita(X1,Y1,S1),partita(X2,Y2,S2),partita(X3,Y3,S3),S1!=S2,
	X1!=X2,X1!=Y2,X1!=X3,
	X2!=X3,X2!=Y3,
	Y1!=X2,Y1!=Y2,Y1!=Y3} ==1 :- day(D).

giocato_in_casa(Squadra,D):-giornata(partita(Squadra,_),_,_,D).
giocato_in_casa(Squadra,D):-giornata(_,partita(Squadra,_),_,D).
giocato_in_casa(Squadra,D):-giornata(_,_,partita(Squadra,_),D).
giocato_in_trasferta(Squadra,D):-giornata(partita(_,Squadra),_,_,D).
giocato_in_trasferta(Squadra,D):-giornata(_,partita(_,Squadra),_,D).
giocato_in_trasferta(Squadra,D):-giornata(_,_,partita(_,Squadra),D).

% Ogni singola partita viene giocata in una sola giornata, no duplicati (andata e ritorno sono diverse, hanno ordine squadre invertito)
%:- partita(X,Y,S), partita(X,Y,S1), S!=S1.

:- giornata(X,Y,Z,D1), giornata(X,Y,Z,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X1,Y2,Z2,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X2,X1,Z2,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X2,Y2,X1,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(Y1,Y2,Z2,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X2,Y1,Z2,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X2,Y2,Y1,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(Z1,Y2,Z2,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X2,Z1,Z2,D2), D1 != D2.
:- giornata(X1,Y1,Z1,D1), giornata(X2,Y2,Z1,D2), D1 != D2.

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
#show giornata/4.
%#show giocato_in_casa/2.
%#show giocato_in_trasferta/2.