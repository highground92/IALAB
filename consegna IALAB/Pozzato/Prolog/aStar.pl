% Stato rappresentato da nodo(F,G,S,ListaAzioniPerS)

aStar(Soluzione,NPassi,NNodi):-
  iniziale(S),
  breadth([nodo(_,0,S,[])],[],SoluzioneTemp,NNodi),
  reverse(SoluzioneTemp,Soluzione),
  length(Soluzione,NPassi).

breadth([nodo(F,_,S,ListaAzioniPerS)|_], NodiEspansi,ListaAzioniPerS,NNodi):-
  finale(S),write("F totale: "),write(F),
  length(NodiEspansi,NNodi).

breadth([nodo(F,G,S,ListaAzioniPerS)|Frontiera], ListaNodiEspansi, Soluzione,NNodi):-
  \+member(S,ListaNodiEspansi),
  findall(Az,applicabile(Az,S),ListaApplicabili),
  generateSons(nodo(F,G,S,ListaAzioniPerS),ListaApplicabili, [S|ListaNodiEspansi], ListaFigliS),
  append(ListaFigliS, Frontiera, NuovaFrontiera),
  sort(NuovaFrontiera, NuovaFrontieraOrdinata),
  breadth(NuovaFrontieraOrdinata, [S|ListaNodiEspansi], Soluzione,NNodi).

breadth([_|Frontiera], ListaNodiEspansi, Soluzione,NNodi):-
  breadth(Frontiera, ListaNodiEspansi, Soluzione,NNodi).


generateSons(_,[],_,[]).

generateSons(nodo(F_padre,G_padre,S,ListaAzioniPerS), [Azione|AltreAzioni],
             ListaNodiVisitati,[nodo(F,G_nuovo,SNuovo,[Azione|ListaAzioniPerS])|AltriFigli]):-
    trasforma(Azione,S,SNuovo,F,G_padre,G_nuovo),
    \+member(SNuovo,ListaNodiVisitati), !,
    generateSons(nodo(F_padre,G_padre,S,ListaAzioniPerS),AltreAzioni,ListaNodiVisitati,AltriFigli).

%Permette di saltare Azione nel caso in cui essa conduce in uno stato già visitato
generateSons(Nodo,[_|AltreAzioni],ListaStatiVisitati,ListaNodiFigli):-
  generateSons(Nodo,AltreAzioni,ListaStatiVisitati,ListaNodiFigli).
