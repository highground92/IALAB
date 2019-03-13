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

trasforma(sud,Stato,NuovoStato,F,G):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto-4,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,F,G).
trasforma(ovest,Stato,NuovoStato,F,G):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto+1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,F,G).
trasforma(nord,Stato,NuovoStato,F,G):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto+4,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,F,G).
trasforma(est,Stato,NuovoStato,F,G):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto-1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,F,G).

bordosinistro(Posizione):-Resto is Posizione mod 4,Resto=0.
bordodestro(Posizione):-Resto is Posizione mod 4,Resto=3.
bordoinferiore(Posizione):-Posizione > 11.
bordosuperiore(Posizione):-Posizione < 4.

% Gioco del 15

%    _____________
%    |2 |1 |3 |10|
%    |  |4 |6 |11|
%    |7 |5 |8 |13|
%    |9 |14|12|15|
%
%    _____________
%    |1 |2 |3 |4 |
%    |5 |6 |  |8 |
%    |9 |10|7 |15|
%    |13|14|12|11|
%iniziale([9,6,4,3,2,8,11,5,1,10,7,15,12,vuoto,14,13]).


% Stato -> lista di caselle(numero,x,y)
/*iniziale([casella(10,0,0),casella(4,0,1),casella(8,0,2),casella(9,0,3),          %non termina (out of stack in 6 ore con IDA*)
          casella(1,1,0),casella(15,1,1),casella(vuoto,1,2),casella(7,1,3),
          casella(12,2,0),casella(14,2,1),casella(2,2,2),casella(13,2,3),
          casella(5,3,0),casella(6,3,1),casella(11,3,2),casella(3,3,3)]). */
iniziale([casella(9,0,0),casella(6,0,1),casella(4,0,2),casella(3,0,3),          % dovrebbe terminare
          casella(2,1,0),casella(8,1,1),casella(11,1,2),casella(5,1,3),
          casella(1,2,0),casella(10,2,1),casella(7,2,2),casella(15,2,3),
          casella(12,3,0),casella(vuoto,3,1),casella(14,3,2),casella(13,3,3)]).
/*iniziale([casella(1,0,0),casella(6,0,1),casella(2,0,2),casella(4,0,3),         %circa 30 secondi con IDA*
          casella(9,1,0),casella(vuoto,1,1),casella(5,1,2),casella(8,1,3),
          casella(13,2,0),casella(7,2,1),casella(3,2,2),casella(15,2,3),
          casella(14,3,0),casella(10,3,1),casella(12,3,2),casella(11,3,3)]). */
%iniziale([casella(1,0,0),casella(6,0,1),casella(2,0,2),casella(4,0,3),          %circa 3 secondi con IDA*
%          casella(9,1,0),casella(5,1,1),casella(3,1,2),casella(8,1,3),
%          casella(13,2,0),casella(10,2,1),casella(7,2,2),casella(15,2,3),
%          casella(14,3,0),casella(vuoto,3,1),casella(12,3,2),casella(11,3,3)]).
% Stato finale del Norvig
finale([casella(1,0,0),casella(2,0,1),casella(3,0,2),casella(4,0,3),
          casella(5,1,0),casella(6,1,1),casella(7,1,2),casella(8,1,3),
          casella(9,2,0),casella(10,2,1),casella(11,2,2),casella(12,2,3),
          casella(13,3,0),casella(14,3,1),casella(15,3,2),casella(vuoto,3,3)]).
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
manhattan([casella(N,X1,Y1)|StatoS],[casella(M,X2,Y2)|StatoF],F,C):-
  manhattan1([casella(N,X1,Y1)|StatoS],[casella(M,X2,Y2)|StatoF],F,C),
  F is C.

manhattan1([],[_|_],_,C):-
  C is 0.
manhattan1([casella(N,X1,Y1)|StatoS],[casella(N,X2,Y2)|_],F,C1):-
  calcolo(X1,X2,Y1,Y2,Res),
  finale(StatoF2),
  manhattan1(StatoS,StatoF2,F,C),
  C1 is C + Res.

manhattan1([casella(N,X1,Y1)|StatoP],[_|StatoF],F,C):-
  manhattan1([casella(N,X1,Y1)|StatoP],StatoF,F,C).

calcolo(X1,X2,Y1,Y2,Res):-
  Res is abs(X1-X2)+ abs(Y1-Y2).
