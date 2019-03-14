applicabile(est,Stato):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  \+bordosinistro(PosVuoto).
applicabile(ovest,Stato):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  \+bordodestro(PosVuoto).
applicabile(nord,Stato):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  \+bordoinferiore(PosVuoto).
applicabile(sud,Stato):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  \+bordosuperiore(PosVuoto).

trasforma(sud,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto-3,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),write("01"),
  finale(StatoF),
  manhattan(Stato,NuovoStato,StatoF,F,G_padre,G_nuovo).

trasforma(ovest,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto+1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),write("02"),
  manhattan(Stato,NuovoStato,F,G_padre,G_nuovo).

trasforma(nord,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto+3,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),write("03"),
  manhattan(Stato,NuovoStato,F,G_padre,G_nuovo).

trasforma(est,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto-1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),write("04"),
  finale(StatoF),
  manhattan(Stato,NuovoStato,StatoF,F,G_padre,G_nuovo).

bordosinistro(Posizione):-Resto is Posizione mod 3,Resto=0.
bordodestro(Posizione):-Resto is Posizione mod 3,Resto=2.
bordoinferiore(Posizione):-Posizione > 5.
bordosuperiore(Posizione):-Posizione < 3.

% Gioco dell'otto'

%    _______
%    |1|2|3|
%    |4|5|6|
%    |7|8| |
%

% Stato -> lista di caselle(numero,x,y)
%iniziale([casella(vuoto,0,0),casella(8,0,1),casella(7,0,2),casella(6,1,0),casella(5,1,1),
%          casella(4,1,2),casella(3,2,0),casella(2,2,1),casella(1,2,2)]).
%iniziale([casella(1,0,0),casella(2,0,1),casella(3,0,2),casella(4,1,0),casella(5,1,1),
%        casella(6,1,2),casella(7,2,0),casella(8,2,1),casella(vuoto,2,2)]).
%iniziale([casella(2,0,0),casella(8,0,1),casella(5,0,2),casella(6,1,0),casella(vuoto,1,1),
%        casella(1,1,2),casella(3,2,0),casella(7,2,1),casella(4,2,2)]).
%iniziale([casella(1,0,0),casella(6,0,1),casella(4,0,2),casella(vuoto,1,0),casella(8,1,1),
%        casella(3,1,2),casella(5,2,0),casella(2,2,1),casella(7,2,2)]).
iniziale([casella(8,0,0),casella(5,0,1),casella(2,0,2),casella(1,1,0),casella(4,1,1),
        casella(6,1,2),casella(3,2,0),casella(7,2,1),casella(vuoto,2,2)]).
%iniziale([casella(7,0,0),casella(8,0,1),casella(3,0,2),casella(1,1,0),casella(5,1,1),
%        casella(6,1,2),casella(2,2,0),casella(vuoto,2,1),casella(4,2,2)]).

% Stato iniziale del Norvig
%iniziale([casella(7,0,0),casella(2,0,1),casella(4,0,2),casella(5,1,0),casella(vuoto,1,1),
%          casella(6,1,2),casella(8,2,0),casella(3,2,1),casella(1,2,2)]).
%iniziale([casella(7,0,0),casella(4,0,1),casella(3,0,2),casella(2,1,0),casella(1,1,1),
%          casella(8,1,2),casella(vuoto,2,0),casella(5,2,1),casella(6,2,2)]).

% Stato finale
finale([casella(1,0,0),casella(2,0,1),casella(3,0,2),casella(4,1,0),casella(5,1,1),
        casella(6,1,2),casella(7,2,0),casella(8,2,1),casella(vuoto,2,2)]).
% Stato finale del Norvig
%finale([casella(vuoto,0,0),casella(1,0,1),casella(2,0,2),casella(3,1,0),casella(4,1,1),
%        casella(5,1,2),casella(6,2,0),casella(7,2,1),casella(8,2,2)]).

% nth(Lista,Posizione,Valore)
nth([Head|_],0,Head):-!.
nth([_|Tail],Pos,X):-
    nonvar(Pos),!,
    Pos1 is Pos-1,
    nth(Tail,Pos1,X).
nth([_|Tail],Pos,X):-
    nth(Tail,Pos1,X),
    Pos is Pos1+1.

% swap(Lista,Pos1,Pos2,NuovaLista)

swap(Lista,Pos1,Pos2,NuovaLista):-
  nth(Lista,Pos1,casella(N,X1,Y1)),
  nth(Lista,Pos2,casella(M,X2,Y2)),
  setElement(Lista,Pos2,casella(N,X1,Y1),Temp),
  setElement(Temp,Pos1,casella(M,X2,Y2),NuovaLista).

% setElement(Lista,Posizione,Valore,NuovaLista)

setElement([casella(_,X1,Y1)|Tail],0,casella(M,_,_),[casella(M,X1,Y1)|Tail]):-!.
setElement([Head|Tail],Pos,casella(N,X,Y),[Head|NuovaTail]):-
  Pos1 is Pos-1,
  setElement(Tail,Pos1,casella(N,X,Y),NuovaTail).

% euristica per azioni


manhattan([casella(N,X,Y)|_],[casella(_,X1,Y1)|_],[casella(N,X2,Y2)|_],F,G_padre,G_nuovo):-
  write("11"),
	calcolo(X,X1,Y,Y1,G1),
	calcolo(X1,X2,Y1,Y2,H),
	G_nuovo is G_padre + G1,
	sum(G_nuovo,H,F).

manhattan(casella(N,X,Y),casella(N1,X1,Y1),[_|StatoF],F,G_padre,G_nuovo):-
  write("22"),
  manhattan(casella(N,X,Y),casella(N1,X1,Y1),StatoF,F,G_padre,G_nuovo).

calcolo(X1,X2,Y1,Y2,Res):-
	Res is abs(X1-X2)+ abs(Y1-Y2).

sum(A,B,Res):-
	Res is A + B.
