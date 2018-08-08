%persona(a; b; c).
%tipo(onesto; bugiardo).

% Ogni persona ha uno e un solo tipo
%1 { ha_tipo(P,T) : tipo(T) } 1 :- persona(P).

% Informazioni a disposizione
%dice_il_vero(a) :- ha_tipo(b,onesto),ha_tipo(c,onesto).
%dice_il_vero(b) :- ha_tipo(a,bugiardo),ha_tipo(c,onesto).

%:-ha_tipo(P,onesto),not dice_il_vero(P).
%:-ha_tipo(P,bugiardo),dice_il_vero(P).

%cifra(0..9).
%lettera(s; e; n; d; m; o; r; y).

% Assegno ad ogni lettera una cifra
%1 { assegna(L,C) : cifra(C) } 1 :- lettera(L).

% Assegno ad ogni cifra al più una lettera
%{ assegna(L,C) : lettera(L) } 1 :- cifra(C).

%somma :- cifra(S; E; N; D; M; O; R; Y),
%  assegna(s,S),assegna(e,E),assegna(n,N),assegna(d,D),
%  assegna(m,M),assegna(o,O),assegna(r,R),assegna(y,Y),
%  S*1000+E*100+N*10+D+M*1000+O*100+R*10+E==M*10000+O*1000+N*100+E*10+Y,S>0,M>0.

%:-not somma.


%squadra(juve;toro;milan;inter).


%1 {partita(S1,S2): squadra(S2) } 1 :- squadracasa(S1).
%partita(A,B) :- squadra(A), squadra(B), A!=B.
%partita1(A,_) :- 1=#count{squadra(A):partita(A,_)} 2.

%goal:- partita1(A,B).
%:- not goal.
%#show partita/2.

%triple1(TermA, "go:is_a", TermB):- triple(TermA, "go:is_a", TermB), TermA != TermB.
%triple1(TermA, "go:is_a", TermC) :-
%  triple(TermA, "go:is_a", TermB),
%  triple(TermB, "go:is_a", TermC),
%  TermA != TermC.
%triple1(TermA, "go:is_a", TermC) :-
%  triple1(TermA, "go:is_a", TermB),
%  triple1(TermB, "go:is_a", TermC),
%  TermA != TermC.
%triple1nr(X) :- #count{TermA,TermC : triple1(TermA,"go:is_a",TermC)} = X.

%DOMINIO
squadra(juve;toro;milan;inter).
%giorno(1..6).
%REGOLE
%Partite diverse
giornata(partita(X1,Y1),partita(X2,Y2)):-partita(X1,Y1),partita(X2,Y2).
partita(X,Y):-squadra(X),squadra(Y), 1 != #count {partita(X,Y)}.
%1{giornata(partita(X1,Y1),partita(X2,Y2)):partita(X2,Y2)}1:-partita(X1,Y1), 1 != #count {partita(X1,Y1)}.
%1{giornata(partita(X1,Y1),partita(X2,Y2)):partita(X1,Y1)}1:-partita(X2,Y2), 1 != #count {partita(X2,Y2)}.
%giornata(partita(X1,Y1),partita(X2,Y2)):-partita(X1,Y1),partita(X2,Y2).
%1{partita(X,Y):squadra(X)}1:-squadra(Y).
%1{partita(X,Y):squadra(Y)}1:-squadra(X).


%Cosa NON vuoi avere
%:- partita(X,Y), X == Y.
%:- partita(X1,Y1), partita(X2,Y2), X1==Y2, Y1==X2.

:- partita(A,A).
%:- 2 > #count {partita(A,B):squadra(A),squadra(B)}.
%:- giornata(A,A).
:- giornata(partita(A,B),partita(A,C)), B!=C.
:- giornata(partita(A,B),partita(C,A)), B!=C.
:- giornata(partita(A,B),partita(C,B)), B!=C.
:- giornata(partita(A,B),partita(B,C)), A!=C.
%:- 2 < #count {partita(X,Y):squadra(X),squadra(Y)}.


%:- giornata(A,B), giornata(A1,B1), A==A1, A==B1, B==A1,B==B1.


%#show giornata/2.


%-----------------------------
%#const n = 8.

% domain
%number(1..n).

% alldifferent
%1 { q(X,Y) : number(Y) } 1 :- number(X).
%1 { q(X,Y) : number(X) } 1 :- number(Y).

% remove conflicting answers
%:- q(X1,Y1), q(X2,Y2), X1 < X2, Y1 == Y2.
%:- q(X1,Y1), q(X2,Y2), X1 < X2, Y1 + X1 == Y2 + X2.
%:- q(X1,Y1), q(X2,Y2), X1 < X2, Y1 - X1 == Y2 - X2.

%#hide.
%#show q(_,_).
