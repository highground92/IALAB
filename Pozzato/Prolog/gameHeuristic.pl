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
  PosTessera is PosVuoto-3,
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
  PosTessera is PosVuoto+3,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,F,G).
trasforma(est,Stato,NuovoStato,F,G):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto-1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,F,G).

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
iniziale([casella(2,0,0),casella(4,0,1),casella(3,0,2),casella(7,1,0),casella(1,1,1),casella(6,1,2),casella(vuoto,2,0),casella(5,2,1),casella(8,2,2)]).
finale([casella(1,0,0),casella(2,0,1),casella(3,0,2),casella(4,1,0),casella(5,1,1),casella(6,1,2),casella(7,2,0),casella(8,2,1),casella(vuoto,2,2)]).

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