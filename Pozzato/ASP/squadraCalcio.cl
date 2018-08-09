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
giorno(1..12).
%REGOLE
%Partite diverse
%1{giornata(data(N),partita(X1,Y1),partita(X2,Y2)):squadra(X2),squadra(Y2)}1:-partita(X1,Y1),giorno(N).
%1{giornata(data(N),partita(X1,Y1),partita(X2,Y2)):squadra(X1),squadra(Y1)}1:-partita(X2,Y2),giorno(N).
%1{campionato(giornata(X1,Y1)):giornata(X1,Y)}12:-giornata(X1,Y1).
%1{campionato(giornata(X1,Y1)):giornata(X,Y1)}12:-giornata(X1,Y1).

1{giornata(partita(X1,Y1),partita(X2,Y2)):squadra(X2),squadra(Y2)}1:-2>#count{partita(X1,Y1)},partita(X1,Y1).
1{giornata(partita(X1,Y1),partita(X2,Y2)):squadra(X1),squadra(Y1)}1:-2>#count{partita(X2,Y2)},partita(X2,Y2).
1{partita(X,Y):squadra(Y)}3:-squadra(X).
1{partita(X,Y):squadra(X)}3:-squadra(Y).


%Cosa NON vuoi avere
%:- partita(A,A).
%:- partita(A,B), 1==#count{partita(A,B)}.
:- giornata(A,A).
%:- giornata(N,_,_), giornata(N,_,_).
%:- giornata(data(N),partita(A,B),partita(C,D)),giornata(data(N+1),partita(A,B),partita(C1,D1)).
:- giornata(partita(A,A),partita(C,D)).% Le squadre non possono affrontare se stesse
:- giornata(partita(A,B),partita(C,C)).% Le squadre non possono affrontare se stesse
:- giornata(partita(A,B),partita(A,D)).% Una squadra non puó giocare due partite lo stesso giorno
:- giornata(partita(A,B),partita(C,A)).% Una squadra non puó giocare due partite lo stesso giorno
:- giornata(partita(A,B),partita(B,D)).% Una squadra non puó giocare due partite lo stesso giorno
:- giornata(partita(A,B),partita(C,B)).% Una squadra non puó giocare due partite lo stesso giorno
%:- giornata(data(N),partita(A,B),partita(C,D)), giornata(data(N+1),partita(A,B),partita(E,F)).% Una partita non puó piú essere ripetuta

#show giornata/2.
%#show campionato/1.

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
