% ampiezza(Soluzione)
% stato rappresentato da nodo(S,ListaAzioniPerS)

ampiezza(Soluzione):-
  iniziale(S),
  depth([nodo(_,_,S,[])],[],SoluzioneTemp),
  reverse(SoluzioneTemp,Soluzione).

% depth(CodaNodiDaEsplorare,NodiEspansi,Soluzione)
depth([nodo(_,_,S,ListaAzioniPerS)|_],_,ListaAzioniPerS):-
  finale(S).
depth([nodo(F,G,S,ListaAzioniPerS)|Frontiera], NodiEspansi,Soluzione):-
  findall(Az,applicabile(Az,S),ListaApplicabili),
  visitati([nodo(F,G,S,ListaAzioniPerS)|Frontiera],NodiEspansi,ListaStatiVisitati),
  generateSons(nodo(F,G,S,ListaAzioniPerS),ListaApplicabili, ListaStatiVisitati,ListaFigliS),
  append(Frontiera,ListaFigliS,NuovaFrontiera),
  sort(NuovaFrontiera,NuovaFrontieraOrdinata),
  depth(NuovaFrontieraOrdinata,[S|NodiEspansi],Soluzione).

% visitati(Frontiera,NodiEspansi,ListaStatiVisitati)
visitati(Frontiera,NodiEspansi,ListaStatiVisitati):-
  estraiStato(Frontiera,StatiFrontiera),
  append(StatiFrontiera,NodiEspansi,ListaStatiVisitati).

% estraiStato(Frontiera,ListaDiStati)
estraiStato([],[]).
estraiStato([nodo(_,_,S,_)|Frontiera],[S|StatiFrontiera]):-
  estraiStato(Frontiera,StatiFrontiera).

% generateSons(Nodo,ListaApplicabili,
%	  ListaStatiVisitati,ListaNodiFigli)
generateSons(_,[],_,[]).

generateSons(nodo(F_padre,G_padre,S,ListaAzioniPerS),[Azione|AltreAzioni],ListaStatiVisitati,[nodo(F,G,SNuovo,[Azione|ListaAzioniPerS])|AltriFigli]):-
    trasforma(Azione,S,SNuovo,F,G),
    \+member(SNuovo,ListaStatiVisitati),!,
    generateSons(nodo(F_padre,G_padre,S,ListaAzioniPerS),AltreAzioni,ListaStatiVisitati,AltriFigli).

generateSons(Nodo,[_|AltreAzioni],ListaStatiVisitati,ListaNodiFigli):-
  generateSons(Nodo,AltreAzioni,ListaStatiVisitati,ListaNodiFigli).
