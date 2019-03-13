
applicabile(est,Stato):-
  nth(Stato,PosVuoto,vuoto),
  \+bordosinistro(PosVuoto).
applicabile(ovest,Stato):-
  nth(Stato,PosVuoto,vuoto),
  \+bordodestro(PosVuoto).
applicabile(nord,Stato):-
  nth(Stato,PosVuoto,vuoto),
  \+bordoinferiore(PosVuoto).
applicabile(sud,Stato):-
  nth(Stato,PosVuoto,vuoto),
  \+bordosuperiore(PosVuoto).

trasforma(sud,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto-4,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).
trasforma(ovest,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto+1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).
trasforma(nord,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto+4,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).
trasforma(est,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto-1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).


bordosinistro(Posizione):-Resto is Posizione mod 4,Resto=0.
bordodestro(Posizione):-Resto is Posizione mod 4,Resto=3.
bordoinferiore(Posizione):-Posizione > 11.
bordosuperiore(Posizione):-Posizione < 4.

% Gioco del 15

%    _____________
%    |1 |6 |2 |4 |
%    |9 |5 |3 |8 |
%    |13|10|7 |15|
%    |14|  |12|11|
%


%iniziale([1,6,2,4,9,5,3,8,13,10,7,15,14,vuoto,12,11]). %circa 3 secondi
%iniziale([1,6,2,4,9,vuoto,5,8,13,7,3,15,14,10,12,11]).  %circa minuti 1,40
iniziale([9,6,4,3,2,8,11,5,1,10,7,15,12,vuoto,14,13]).   
finale([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,vuoto]).

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
  nth(Lista,Pos1,X1),
  nth(Lista,Pos2,X2),
  setElement(Lista,Pos2,X1,Temp),
  setElement(Temp,Pos1,X2,NuovaLista).

% setElement(Lista,Posizione,Valore,NuovaLista)

setElement([_|Tail],0,X,[X|Tail]):-!.
setElement([Head|Tail],Pos,X,[Head|NuovaTail]):-
  Pos1 is Pos-1,
  setElement(Tail,Pos1,X,NuovaTail).
