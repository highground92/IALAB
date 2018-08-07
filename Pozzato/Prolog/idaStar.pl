% ricerca in profonditá limitata

idaStar(Soluzione):-
	iniziale(S),
	ric_prof_pl(S,Soluzione,[S],0,0).

ric_prof_pl(S,Soluzione,Visitati,Threshold,TempCost):-
	ric_prof_pl2(S,Soluzione,Visitati,Threshold,TempCost);
	findall(Cost, nodoIda(Cost,_), ListaAssert),
	sort(ListaAssert,ListaAssert2),
	findNextThreshold(Threshold, ListaAssert2, NewTreshold),
	retract(nodoIda(_,_)),
	ric_prof_pl(S,Soluzione,Visitati,NewTreshold,0).

ric_prof_pl2(S,[],_,_,_):-finale(S).
ric_prof_pl2(S,[Azione|ListaAzioni],Visitati,Threshold,TempCost):-
	applicabile(Azione,S),
	trasforma(Azione,S,SNuovo,F,_),
	\+member(SNuovo,Visitati),
	NewTempCost is F + TempCost,
	assert(nodoIda(NewTempCost,SNuovo)),
	NewTempCost=<Threshold,
	ric_prof_pl2(SNuovo,ListaAzioni,[SNuovo|Visitati],Threshold,NewTempCost).

%Scelgo il nuovo threshold tra i vari costi salvati
findNextThreshold(_,[],_).
findNextThreshold(OldThreshold,[ Cost | _], NewTreshold):-
	Cost>OldThreshold,
	%write("Il Cost vale: "), write(Cost), write(" "),
	NewTreshold = Cost.
findNextThreshold(OldThreshold,[ _ | ListaAssert], NewTreshold):-
	findNextThreshold(OldThreshold, ListaAssert, NewTreshold).


% ricerca in profonditá limitata

ricercaProfonditaN(N, Soluzione):-
  iniziale(S),
  ric_prof_pl(S,Soluzione,[S],N).

ric_prof_pl(S,[],_,_):-finale(S).
ric_prof_pl(S,[Azione|ListaAzioni],Visitati,N):-
  N>0, applicabile(Azione,S),trasforma(Azione,S,SNuovo),\+member(SNuovo,Visitati),
  N1 is N-1, ric_prof_pl(SNuovo,ListaAzioni,[SNuovo|Visitati],N1).



% ricerca in profonditá limitata ottima

ricercProfOtt(NPassi, Soluzione):-
  iniziale(S), N is 0, ric_prof_ot(S, Soluzione, [S], N, NPassi).

ric_prof_ot(S, Soluzione, [S], N, NPassi):-
  ric_prof_ot2(S, Soluzione, [S], N, NPassi); N1 is N+1,
  ric_prof_ot(S, Soluzione, [S], N1, NPassi).

ric_prof_ot2(S,[],_,_,0):-finale(S).
ric_prof_ot2(S,[Azione|ListaAzioni],Visitati,N,NPassi):-
  N>0, applicabile(Azione,S),trasforma(Azione,S,SNuovo),\+member(SNuovo,Visitati),
  N1 is N-1, ric_prof_ot2(SNuovo,ListaAzioni,[SNuovo|Visitati],N1,Np), NPassi is Np+1.
