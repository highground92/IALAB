% Iterative Deepening
% La ricerca in profonditá conta sia il numero di stazioni che le azioni di salire e scendere

iterative_deepening_search(NPassi, Soluzione):-
    iniziale(S), N is 0, ric_prof(S, Soluzione, [S], N, NPassi).

ric_prof(S, Soluzione, [S], N, NPassi):-
    ric_prof_ot(S, Soluzione, [S], N, NPassi); N1 is N+1,
    ric_prof(S, Soluzione, [S], N1, NPassi).

ric_prof_ot(S,[],_,_,0):-finale(S).
ric_prof_ot(S,[Azione|ListaAzioni],Visitati,N,NPassi):-
    N>0, applicabile(Azione,S),trasforma(Azione,S,SNuovo),\+member(SNuovo,Visitati),
    N1 is N-1, ric_prof_ot(SNuovo,ListaAzioni,[SNuovo|Visitati],N1,Np), NPassi is Np+1.
