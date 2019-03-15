% ricerca in profonditá limitata

idaStar(Soluzione,Npassi,NNodi):-
	iniziale(S),
	assert(numeroNodi(0)),
	ric_prof(S,0,Soluzione,[S],0),
	numeroNodi(NNoditemp),
	length(Soluzione,Npassi),
	NNodi is NNoditemp + Npassi,
	retractall(numeroNodi(V)).


ric_prof(S,G,Soluzione,Visitati,Threshold):-
	ric_prof2(S,G,Soluzione,Visitati,Threshold);

	findall(Cost, nodoIda(Cost,_), ListaAssert),
	length(ListaAssert,Ntemp),
	numeroNodi(N),
	NewNum is N + Ntemp,
	retractall(numeroNodi(N)),
	assert(numeroNodi(NewNum)),

	sort(ListaAssert,ListaAssert2),
	findNextThreshold(Threshold, ListaAssert2, NewTreshold),
	retractall(nodoIda(_,_)),
	ric_prof(S,G,Soluzione,Visitati,NewTreshold).

ric_prof2(S,_,[],_,_):-finale(S).

ric_prof2(S,G,[Azione|ListaAzioni],Visitati,Threshold):-
	applicabile(Azione,S),
	trasforma(Azione,S,SNuovo,F,G,G_nuovo),
	%write(G_nuovo),write("---"),   % write della G totale, si deve leggere solo l'ultima scrittura
	\+member(SNuovo,Visitati),
	assert(nodoIda(F,SNuovo)),
	F=<Threshold,
	ric_prof2(SNuovo,G_nuovo,ListaAzioni,[SNuovo|Visitati],Threshold).

%Scelgo il nuovo threshold tra i vari costi salvati
findNextThreshold(_,[],_).
findNextThreshold(OldThreshold,[ Cost | _], NewTreshold):-
	Cost>OldThreshold,
	%write("Il Cost vale: "), write(Cost), write(" "),
	NewTreshold = Cost.
findNextThreshold(OldThreshold,[ _ | ListaAssert], NewTreshold):-
	findNextThreshold(OldThreshold, ListaAssert, NewTreshold).
