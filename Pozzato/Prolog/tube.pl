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

trasforma(sali(Linea,Dir),[at(Stazione),ground],[at(Stazione),in(Linea,Dir)]).
trasforma(scendi(Stazione),[at(Stazione),in(_,_)],[at(Stazione),ground]).
trasforma(vai(Linea,Dir,SP,SA),[at(SP),in(Linea,Dir)],[at(SA),in(Linea,Dir)]):-
	tratta(Linea,Dir,SP,SA).

uguale(S,S).

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
	'Gloucester Road','Notting Hill Gate','Bayswater','Paddington','Edgware Road',
	'Baker Street','Great Portland','Kings Cross']).

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
stazione('Westminster',4.5,1.0). %


fermata(Stazione,Linea):- percorso(Linea,0,P), member(Stazione,P).


iniziale([at('Bayswater'),ground]).

finale([at('Covent Garden'),ground]).
