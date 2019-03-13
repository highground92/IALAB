% ricerca in profonditá limitata

idaStar(Soluzione,NPassi,NNodi):-
	iniziale(S),
	assert(numeroNodi(0)),
	ric_prof_pl(nodo(0,0,S,_),Soluzione,[],0),
	length(Soluzione,NPassi),
	numeroNodi(NNodi).


ric_prof_pl(nodo(F,G,S,_),Soluzione,Visitati,Threshold):-
	ric_prof_pl_ot(nodo(F,G,S,_),Soluzione, Visitati,Threshold),

	length(Visitati, NNodiTemp),
	numeroNodi(N),
	NewNum is N + NNodiTemp,
	retractall(numeroNodi(_)),
	assert(numeroNodi(NewNum));

	findall(Cost, nodoIda(Cost,_), ListaAssert),
	sort(ListaAssert,ListaAssertOrdinata),
	findNextThreshold(Threshold, ListaAssertOrdinata, NewTreshold),
	retractall(nodoIda(_,_)),
	ric_prof_pl([nodo(F,G,S,ListaAzioniPerS)|Soluzione],Visitati,NewTreshold).


ric_prof_pl_ot([nodo(_,_,S,_)],_,_):-
	finale(S).

ric_prof_pl_ot([nodo(_,G_padre,S,ListaAzioniPerS)| Soluzione], Visitati, Threshold):-
	applicabile(Azione,S),
	trasforma(Azione,S,SNuovo,F_nuovo,G_padre,G_nuovo),
	\+member(SNuovo,Visitati),
	assert(nodoIda(F_nuovo,SNuovo)),
	F_nuovo=<Threshold,
	ric_prof_pl_ot([nodo(F_nuovo,G_nuovo,SNuovo,[Azione|ListaAzioniPerS])|Soluzione],[SNuovo|Visitati],Threshold).

%Scelgo il nuovo threshold tra i vari costi salvati
findNextThreshold(_,[],_).

findNextThreshold(OldThreshold,[ Cost | _ ], NewTreshold):-
	Cost>OldThreshold,
	NewTreshold = Cost.

findNextThreshold(OldThreshold,[ _ | ListaAssert], NewTreshold):-
	findNextThreshold(OldThreshold, ListaAssert, NewTreshold).


%%
