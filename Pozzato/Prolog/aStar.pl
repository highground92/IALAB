% stato rappresentato da nodo(F,G,S,ListaAzioniPerS)

aStar(Soluzione,NPassi,NNodiAperti):-
  iniziale(S),
  depth([nodo(_,0,S,[])],[],SoluzioneTemp,NNodiAperti),
  reverse(SoluzioneTemp,Soluzione),
  length(Soluzione,NPassi).

% depth(CodaNodiDaEsplorare,NodiEspansi,Soluzione)
depth([nodo(F,_,S,ListaAzioniPerS)|_], NodiEspansi,ListaAzioniPerS,NNodiAperti):-
  finale(S),write(F),write("---"),
  length(NodiEspansi,NNodiAperti).

depth([nodo(F,G,S,ListaAzioniPerS)|Frontiera], ListaNodiEspansi, Soluzione,NNodiAperti):-
  findall(Az,applicabile(Az,S),ListaApplicabili),
  generateSons(nodo(F,G,S,ListaAzioniPerS),ListaApplicabili, [S|ListaNodiEspansi], ListaFigliS),
  append(ListaFigliS, Frontiera, NuovaFrontiera),
  sort(NuovaFrontiera, NuovaFrontieraOrdinata),
  depth(NuovaFrontieraOrdinata, [S|ListaNodiEspansi], Soluzione,NNodiAperti).


generateSons(_,[],_,[]).

generateSons(nodo(F_padre,G_padre,S,ListaAzioniPerS), [Azione|AltreAzioni],
             ListaNodiVisitati,[nodo(F,G_nuovo,SNuovo,[Azione|ListaAzioniPerS])|AltriFigli]):-
    trasforma(Azione,S,SNuovo,F,G_padre,G_nuovo),
    \+member(SNuovo,ListaNodiVisitati), !,
    generateSons(nodo(F_padre,G_padre,S,ListaAzioniPerS),AltreAzioni,ListaNodiVisitati,AltriFigli).

%Permette di saltare Azione nel caso in cui essa conduce in uno stato già visitato
generateSons(Nodo,[_|AltreAzioni],ListaStatiVisitati,ListaNodiFigli):-
  generateSons(Nodo,AltreAzioni,ListaStatiVisitati,ListaNodiFigli).
