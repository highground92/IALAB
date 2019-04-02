% ricerca in profonditá limitata

idaStar(Soluzione,Npassi,NNodi):-
	iniziale(S),
	assert(numeroNodi(0)),
	depth(S,0,Soluzione,[S],0),
	numeroNodi(NNoditemp),
	length(Soluzione,Npassi),
	NNodi is NNoditemp + Npassi,
	retractall(numeroNodi(_)),
	valore(G),
	write("F totale: "),
	write(G),
	retractall(valore(_)).


depth(S,G,Soluzione,Visitati,Threshold):-
	depth_ot(S,G,Soluzione,Visitati,Threshold);
	findall(Cost, nodoIda(Cost,_), ListaAssert),
	length(ListaAssert,Ntemp),
	numeroNodi(N),
	NewNum is N + Ntemp,
	retractall(numeroNodi(N)),
	assert(numeroNodi(NewNum)),
	sort(ListaAssert,ListaAssert2),
	findNextThreshold(Threshold, ListaAssert2, NewTreshold),
	retractall(nodoIda(_,_)),
	depth(S,G,Soluzione,Visitati,NewTreshold).


depth_ot(S,G,[],_,_):-finale(S), assert(valore(G)).

depth_ot(S,G,[Azione|ListaAzioni],Visitati,Threshold):-
	applicabile(Azione,S),
	trasforma(Azione,S,SNuovo,F,G,G_nuovo),
	\+member(SNuovo,Visitati),
	assert(nodoIda(F,SNuovo)),
	F=<Threshold,
	depth_ot(SNuovo,G_nuovo,ListaAzioni,[SNuovo|Visitati],Threshold).

%Scelgo il nuovo threshold tra i vari costi salvati
findNextThreshold(_,[],_).
findNextThreshold(OldThreshold,[ Cost | _], NewTreshold):-
	Cost>OldThreshold,
	%write("Il Cost vale: "), write(Cost), write(" "),
	NewTreshold = Cost.
findNextThreshold(OldThreshold,[ _ | ListaAssert], NewTreshold):-
	findNextThreshold(OldThreshold, ListaAssert, NewTreshold).
