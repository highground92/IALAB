iterativeDeepening(Soluzione,NPassi,NNodi):-
    iniziale(S), N is 0,
    assert(numeroNodi(0)), assert(nodiIterative(0,S)),
    ric_prof(S, Soluzione, [S], N, NPassi),
    numeroNodi(NNoditemp),
  	length(Soluzione,Npassi),
  	NNodi is NNoditemp + Npassi,
  	retractall(numeroNodi(_)).

ric_prof(S, Soluzione, [S], N, NPassi):-
    ric_prof_ot(S, Soluzione, [S], N, NPassi);
    N1 is N+1,
    findall(Num, nodiIterative(Num,_), ListaNumNodi),
  	length(ListaNumNodi,Ntemp),
  	numeroNodi(Numero),
  	NewNum is Numero + Ntemp,
  	retractall(numeroNodi(_)),
    retractall(nodiIterative(_,_)),
  	assert(numeroNodi(NewNum)),
    ric_prof(S, Soluzione, [S], N1, NPassi).


ric_prof_ot(S,[],_,_,0):-
  finale(S).

ric_prof_ot(S,[Azione|ListaAzioni],Visitati,N,NPassi):-
    N>0, applicabile(Azione,S),trasforma(Azione,S,SNuovo),\+member(SNuovo,Visitati),
    assert(nodiIterative(N,S)),
    N1 is N-1, ric_prof_ot(SNuovo,ListaAzioni,[SNuovo|Visitati],N1,Np), NPassi is Np+1.
