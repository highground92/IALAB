%squadra(juve;toro;milan;inter).
%giorno(1..6).

%1{partita(X,Y,S): squadra(Y)}1:-squadra(X),giorno(S).
%1{partita(X,Y,S): squadra(X)}1:-squadra(Y),giorno(S).

%:- partita(X,X,_).
%:- partita(X,Y,S),giorno(S), partita(X,Y,S+1).
%#show partita/3.

%numPartita(1..12).
%squadra(juve;toro;milan;inter).

%1{partita(X,Y,S): squadra(X),squadra(Y),X!=Y}1 :- numPartita(S).

%:- partita(X,Y,S), partita(X,Y,S1), S!=S1.

%#show partita/3.

numPartita(1..12).
squadra(juve;toro;milan;inter).
day(1..6).


%{partita(X,Y,S): squadra(X),squadra(Y),X!=Y} ==1 :- numPartita(S).
{giornata(partita(X1,Y1),partita(X2,Y2),D):
          %partita(X1,Y1,S1),partita(X2,Y2,S2),
          %S1!=S2,
          squadra(X1),squadra(Y1),squadra(X2),squadra(Y2),
          X1!=X2,X1!=Y2,Y1!=X2,Y1!=Y2
} ==1 :- day(D).


giocato_in_casa(Squadra,D):-giornata(partita(Squadra,_),_,D).
giocato_in_casa(Squadra,D):-giornata(_,partita(Squadra,_),D).
giocato_in_trasferta(Squadra,D):-giornata(partita(_,Squadra),_,D).
giocato_in_trasferta(Squadra,D):-giornata(_,partita(_,Squadra),D).


% Ogni singola partita viene giocata in una sola giornata, no duplicati (andata e ritorno sono diverse, hanno ordine squadre invertito)
%:- partita(X,Y,S), partita(X,Y,S1), S!=S1.
:- giornata(X,X,D).
:- giornata(X,Y,D1), giornata(X,Y,D2), D1 != D2.
:- giornata(X1,Y1,D1), giornata(X1,Y2,D2), D1 != D2.
:- giornata(X1,Y1,D1), giornata(X2,X1,D2), D1 != D2.
:- giornata(X1,Y1,D1), giornata(X2,Y1,D2), D1 != D2.
:- giornata(X1,Y1,D1), giornata(Y1,Y2,D2), D1 != D2.
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
#show giornata/3.
%#show giocato_in_casa/2.
%#show giocato_in_trasferta/2.
