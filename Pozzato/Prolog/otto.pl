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
  PosTessera is PosVuoto-3,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).
trasforma(ovest,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto+1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).
trasforma(nord,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto+3,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).
trasforma(est,Stato,NuovoStato):-
  nth(Stato,PosVuoto,vuoto),
  PosTessera is PosVuoto-1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato).


bordosinistro(Posizione):-Resto is Posizione mod 3,Resto=0.
bordodestro(Posizione):-Resto is Posizione mod 3,Resto=2.
bordoinferiore(Posizione):-Posizione > 5.
bordosuperiore(Posizione):-Posizione < 3.

%    _______
%    |2|4|3|
%    |7|1|6|
%    | |5|8|
%
%iniziale([3,8,vuoto,1,2,5,4,7,6]). % stato ok
iniziale([2,8,5,6,1,vuoto,3,7,4]). % stato incasinato
%iniziale([7,4,3,2,1,8,vuoto,5,6]). % prova cesare
%iniziale([2,4,3,7,1,6,vuoto,5,8]). %stato iniziale del prof
finale([1,2,3,4,5,6,7,8,vuoto]).

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
