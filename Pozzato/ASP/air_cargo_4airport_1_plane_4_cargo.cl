#const lastlev=5.

livello(0..lastlev).

% INIT
at(c1,sfo,0).
at(c2,jfk,0).
at(c3,jfk,0).
at(c4,man,0).
at(p1,sfo,0).
cargo(c1).
cargo(c2).
cargo(c3).
cargo(c4).
plane(p1).
airport(sfo).
airport(jfk).
airport(los).
airport(man).

-at(c1,jfk,0).
-at(c1,los,0).
-at(c1,man,0).
-at(c2,sfo,0).
-at(c2,los,0).
-at(c2,man,0).
-at(c3,los,0).
-at(c3,sfo,0).
-at(c1,man,0).
-at(c4,los,0).
-at(c4,sfo,0).

-at(p1,jfk,0).
-at(p1,los,0).
-at(p1,man,0).

% ACTIONS

{load(C,P,A,S):cargo(C),plane(P),airport(A);
  unload(C,P,A,S):cargo(C),plane(P),airport(A)}:-livello(S).

0 {fly(P,From,To,S):plane(P),airport(From),airport(To),From != To}1:-livello(S),plane(P).

% EFFECTS
-at(C,A,S+1):-load(C,P,A,S).
in (C,P,S+1):-load(C,P,A,S).

at(C,A,S+1):-unload(C,P,A,S).
-in(C,P,S+1):-unload(C,P,A,S).

-at(P,From,S+1):-fly(P,From,To,S),livello(S).
at(P,To,S+1):-fly(P,From,To,S),livello(S).

% PRECOND
:-load(C,P,A,S),not at(C,A,S).
:-load(C,P,A,S),not at(P,A,S).
:-unload(C,P,A,S),not in(C,P,S).
:-unload(C,P,A,S),not at(P,A,S).
:-fly(P,From,To,S),not at(P,From,S).


% PERSISTENCE
at(C,A,S+1):- at(C,A,S),livello(S),not -at(C,A,S+1).
-at(C,A,S+1):- -at(C,A,S),livello(S),not at(C,A,S+1).

% GOAL
goal:-at(c1,jfk,lastlev+1),at(c2,sfo,lastlev+1),at(c3,los,lastlev+1),at(c4,jfk,lastlev+1).
:-not goal.

#show load/4.
#show fly/4.
#show unload/4.
