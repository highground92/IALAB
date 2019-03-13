% stato: [at(Stazione), Location]
% Location può essere in(NomeLinea, Dir) o
%  'ground' se l'agente non è su nessun treno
% Dir può esere 0 o 1


% Azioni:
%  sali(Linea, Dir)
%  scendi(Stazione)
%  vai(Linea, Dir, StazionePartenza, StazioneArrivo)

applicabile(sali(Linea,Dir),[at(Stazione),ground]):-
	fermata(Stazione,Linea), member(Dir,[0,1]).
applicabile(scendi(Stazione),[at(Stazione),in(_,_)]).
applicabile(vai(Linea,Dir,SP,SA),[at(SP),in(Linea,Dir)]):-
	tratta(Linea,Dir,SP,SA).

% Regole con calcolo del costo per salire e scendere usando manhattan
/*trasforma(sali(Linea,Dir),[at(Stazione),ground],[at(Stazione),in(Linea,Dir)],G_padre,G_nuovo):-
 	finale([at(StazioneGoal),_]),
 	manhattan(Stazione,StazioneGoal,G_padre,G_nuovo).
 trasforma(scendi(Stazione),[at(Stazione),in(_,_)],[at(Stazione),ground],G_padre,G_nuovo):-
 	finale([at(StazioneGoal),_]),
 	manhattan(Stazione,StazioneGoal,G_padre,G_nuovo).
 trasforma(vai(Linea,Dir,SP,SA),[at(SP),in(Linea,Dir)],[at(SA),in(Linea,Dir)],G_padre,G_nuovo):-
 	manhattan(SP,SA,G_padre,G_nuovo),
 	tratta(Linea,Dir,SP,SA). */
%___________
% Regole con calcolo del costo per salire e scendere usando euclidea
/*trasforma(sali(Linea,Dir),[at(Stazione),ground],[at(Stazione),in(Linea,Dir)],G_padre,G_nuovo):-
	finale([at(StazioneGoal),_]),
	euclidea(Stazione,StazioneGoal,G_padre,G_nuovo).
trasforma(scendi(Stazione),[at(Stazione),in(_,_)],[at(Stazione),ground],G_padre,G_nuovo):-
	finale([at(StazioneGoal),_]),
	euclidea(Stazione,StazioneGoal,G_padre,G_nuovo).
trasforma(vai(Linea,Dir,SP,SA),[at(SP),in(Linea,Dir)],[at(SA),in(Linea,Dir)],G_padre,G_nuovo):-
	euclidea(SP,SA,G_padre,G_nuovo),
	tratta(Linea,Dir,SP,SA). */
%---------------------------------------------------------------------
% Regole con costo fisso di salire e scendere usando manhattan
/*trasforma(sali(Linea,Dir),[at(Stazione),ground],[at(Stazione),in(Linea,Dir)],F,G_padre,G_nuovo):-
	euclidea2(Stazione,F,G_padre,G_nuovo).
 trasforma(scendi(Stazione),[at(Stazione),in(_,_)],[at(Stazione),ground],F,G_padre,G_nuovo):-
 	euclidea2(Stazione,F,G_padre,G_nuovo).
 trasforma(vai(Linea,Dir,SP,SA),[at(SP),in(Linea,Dir)],[at(SA),in(Linea,Dir)],F,G_padre,G_nuovo):-
 	manhattan(SP,SA,G_padre,G_nuovo),
 	tratta(Linea,Dir,SP,SA). */
%___________
% Regole con costo fisso di salire e scendere usando euclidea
trasforma(sali(Linea,Dir),[at(Stazione),ground],[at(Stazione),in(Linea,Dir)],F,G_padre,G_nuovo):-
	euclidea2(Stazione,F,G_padre,G_nuovo).
 trasforma(scendi(Stazione),[at(Stazione),in(_,_)],[at(Stazione),ground],F,G_padre,G_nuovo):-
	 euclidea2(Stazione,F,G_padre,G_nuovo).
 trasforma(vai(Linea,Dir,SP,SA),[at(SP),in(Linea,Dir)],[at(SA),in(Linea,Dir)],F,G_padre,G_nuovo):-
 	euclidea(SP,SA,F,G_padre,G_nuovo),
 	tratta(Linea,Dir,SP,SA).


% percorso(Linea, Dir, ListaFermate)

percorso(piccadilly,0,['Kings Cross','Holborn','Covent Garden',
	'Leicester Square','Piccadilly Circus','Green Park','South Kensington',
	'Gloucester Road','Earls Court']).
percorso(jubilee,0,['Baker Street','Bond Street','Green Park',
	'Westminster','Waterloo','London Bridge']).
percorso(central,0,['Notting Hill Gate','Bond Street','Oxford Circus',
	'Tottenham Court Road','Holborn','Bank']).
percorso(victoria,0,['Kings Cross','Euston','Warren Street',
	'Oxford Circus','Green Park','Victoria']).
percorso(bakerloo,0,['Paddington','Baker Street','Oxford Circus',
	'Piccadilly Circus','Embankment','Waterloo']).
percorso(circle,0,['Embankment','Westminster','Victoria','South Kensington',
	'Gloucester Road','Notting Hill Gate','Bayswater','Paddington',
	'Baker Street','Kings Cross']).

percorso(Linea,1,LR):- percorso(Linea,0,L), reverse(L,LR).

% tratta(NomeLinea, Dir, StazionePartenza, StazioneArrivo)

tratta(Linea,Dir,SP,SA):- percorso(Linea,Dir,LF), member_pair(SP,SA,LF).

member_pair(X,Y,[X,Y|_]).
member_pair(X,Y,[_,Z|Rest]):- member_pair(X,Y,[Z|Rest]).


% stazione(Stazione, Coord1, Coord2)

stazione('Baker Street',3.0,5.0). %
stazione('Bank',7.5,2.8). %
stazione('Bayswater',0.5,3.2). %
stazione('Bond Street',2.5,3.3). %
stazione('Covent Garden',5.8,2.9). %
stazione('Earls Court',0.0,1.0).   %
stazione('Embankment',5.5,1.0). %
stazione('Euston',5.7,5.2). %
stazione('Gloucester Road',1.0,1.0). %
stazione('Green Park',2.5,2.7). %
stazione('Holborn',6.0,3.3). %
stazione('Kings Cross',7.0,5.0). %
stazione('Leicester Square',5.5,2.7). %
stazione('London Bridge',7.5,0.8). %
stazione('Notting Hill Gate',0.5,2.8). %
stazione('Oxford Circus',3.5,3.3). %
stazione('Paddington',0.5,5.0). %
stazione('Piccadilly Circus',4.5,2.7). %
stazione('South Kensington',1.5,1.0). %
stazione('Tottenham Court Road',5.5,3.3). %
stazione('Victoria',2.5,1.0). %
stazione('Warren Street',5.5,5). %
stazione('Waterloo',5.5,0). %
stazione('Westminster',4.5,1.0).
/* Dati di fetch */
/*
stazione('Baker Street',4.5,5.6).
stazione('Bank',12,4).
stazione('Bayswater',1,3.7).
stazione('Bond Street',5.4,4.1).
stazione('Covent Garden',8,4).
stazione('Earls Court',0,0).
stazione('Embankment',8.2,3).
stazione('Euston',7.1,6.6).
stazione('Gloucester Road',1.6,0.6).
stazione('Green Park',6,2.8).
stazione('Holborn',8.6,4.8).
stazione('Kings Cross',8.2,7.1).
stazione('Leicester Square',7.6,3.6).
stazione('London Bridge',0,0).
stazione('Notting Hill Gate',0,3.2).
stazione('Oxford Circus',6.2,4.3).
stazione('Paddington',2.4,4.2).
stazione('Piccadilly Circus',7,3.3).
stazione('South Kensington',2.6,0.5).
stazione('Tottenham Court Road',7.4,4.5).
stazione('Victoria',5.8,1).
stazione('Warren Street',6.5,6).
stazione('Waterloo',9.2,2.4).
stazione('Westminster',8,1.8). */

fermata(Stazione,Linea):- percorso(Linea,0,P), member(Stazione,P).

% ('Paddington')->('Covent Garden’)
iniziale([at('Bayswater'),ground]).

finale([at('Covent Garden'),ground]).


% euristiche per azioni
manhattan(StazioneP,StazioneA,F,G_padre,G_nuovo):-
	stazione(StazioneP,X,Y),
	stazione(StazioneA,X1,Y1),
	finale([at(StazioneFinale),ground]),
	stazione(StazioneFinale,X2,Y2),
	calcolo(X,X1,Y,Y1,G1),
	calcolo(X1,X2,Y1,Y2,H),
	G_nuovo is G_padre + G1,
	sum(G_nuovo,H,F).

calcolo(X1,X2,Y1,Y2,Res):-
	Res is abs(X1-X2)+ abs(Y1-Y2).

sum(A,B,Res):-
	Res is A + B.

euclidea(StazioneP,StazioneA,F,G_padre,G_nuovo):-
	stazione(StazioneP,X,Y),
	stazione(StazioneA,X1,Y1),
	finale([at(StazioneFinale),ground]),
	stazione(StazioneFinale,X2,Y2),
	calcolo2(X,X1,Y,Y1,G1),
	calcolo2(X1,X2,Y1,Y2,H),
	G_nuovo is G_padre + G1,
	sum(G_nuovo,H,F).

euclidea2(StazioneA,F,G_padre,G_nuovo):-
	stazione(StazioneA,X1,Y1),
	finale([at(StazioneFinale),ground]),
	stazione(StazioneFinale,X2,Y2),
	calcolo2(X1,X2,Y1,Y2,H),
	G_nuovo is G_padre + 0.1,
	sum(G_nuovo,H,F).

calcolo2(X1,X2,Y1,Y2,Res):-
	Xt is abs(X1-X2),
	Yt is abs(Y1-Y2),
	C is Xt*Xt + Yt*Yt,
	sqrt(C,Res).


	%write("Il Res vale: "),write(Res).
