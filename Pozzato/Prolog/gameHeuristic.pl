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
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,H),
  sum(1,G_padre,G_nuovo),
  sum(G_nuovo,H,F).

trasforma(ovest,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto+1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,H),
  sum(1,G_padre,G_nuovo),
  sum(G_nuovo,H,F).

trasforma(nord,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto+3,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,H),
  sum(1,G_padre,G_nuovo),
  sum(G_nuovo,H,F).

trasforma(est,Stato,NuovoStato,F,G_padre,G_nuovo):-
  nth(Stato,PosVuoto,casella(vuoto,_,_)),
  PosTessera is PosVuoto-1,
  swap(Stato,PosVuoto,PosTessera,NuovoStato),
  finale(StatoF),
  manhattan(NuovoStato,StatoF,H),
  sum(1,G_padre,G_nuovo),
  sum(G_nuovo,H,F).

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

% Stato -> lista di caselle(numero,x,y)  %[vuoto,8,7,6,5,4,3,2,1]
%iniziale([casella(vuoto,0,0),casella(8,0,1),casella(7,0,2),casella(6,1,0),casella(5,1,1),
%          casella(4,1,2),casella(3,2,0),casella(2,2,1),casella(1,2,2)]).
%iniziale([casella(1,0,0),casella(2,0,1),casella(3,0,2),casella(4,1,0),casella(5,1,1),
%        casella(6,1,2),casella(7,2,0),casella(8,2,1),casella(vuoto,2,2)]).
iniziale([casella(2,0,0),casella(8,0,1),casella(5,0,2),casella(6,1,0),casella(vuoto,1,1),
        casella(1,1,2),casella(3,2,0),casella(7,2,1),casella(4,2,2)]).
%iniziale([casella(1,0,0),casella(6,0,1),casella(4,0,2),casella(vuoto,1,0),casella(8,1,1),
%        casella(3,1,2),casella(5,2,0),casella(2,2,1),casella(7,2,2)]).
%iniziale([casella(8,0,0),casella(5,0,1),casella(2,0,2),casella(1,1,0),casella(4,1,1),
%        casella(6,1,2),casella(3,2,0),casella(7,2,1),casella(vuoto,2,2)]).
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

% Euristica per azioni
% Ho scorso tutta la lista dei miei stati
manhattan([],_,H):-
  H is 0.

%Scorro lista dello stato finale, sto cercando la casella giusta
manhattan([casella(N,X1,Y1)|StatoS],[casella(M,_,_)|StatoF],H):-
  M \= N,
  manhattan([casella(N,X1,Y1)|StatoS],StatoF,H).

% Ho trovato la casella giusta, calcolo il costo e scorro la lista dei miei
% stati e reinizializzo quella dello stato finale
manhattan([casella(N,X1,Y1)|StatoS],[casella(N,X2,Y2)|_],H):-
  norma1(X1,X2,Y1,Y2,Res),
  finale(StatoFinale),
  manhattan(StatoS,StatoFinale,H1),
  H is H1 + Res.

norma1(X1,X2,Y1,Y2,Res):-
  Res is abs(X1-X2)+ abs(Y1-Y2).

sum(A,B,Res):-
	Res is A + B.
