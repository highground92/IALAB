(defmodule MAIN (export ?ALL))

(deftemplate furgone (slot id) (slot posizione))

(deftemplate tratta (slot partenza) (slot arrivo) (slot costo))

(deftemplate spostamento (slot id_mezzo) (slot partenza) (slot arrivo) (slot costo))

(deftemplate combinazione (slot furgone1_partenza) (slot furgone1_arrivo)
                          (slot furgone2_partenza) (slot furgone2_arrivo) (slot costo)
                          (slot id) (slot padre))

(deftemplate best_state (slot best_cost) (slot best_id))

(deftemplate current (slot id_current))

(deffacts domain
        (furgone (id 1) (posizione Torino))
        (furgone (id 2) (posizione Milano))
        (tratta (partenza Torino) (arrivo Milano)  (costo 5))
        (tratta (partenza Torino) (arrivo Genova)  (costo 15))
        (tratta (partenza Torino) (arrivo Firenze) (costo 10))
        (tratta (partenza Genova) (arrivo Bologna) (costo 20))
        (tratta (partenza Milano) (arrivo Torino)  (costo 25))
        (tratta (partenza Milano) (arrivo Firenze) (costo 10))
        (tratta (partenza Firenze) (arrivo Genova) (costo 10))
        (tratta (partenza Firenze) (arrivo Bologna) (costo 15))
        (tratta (partenza Bologna) (arrivo Firenze) (costo 15))
        (tratta (partenza Bologna) (arrivo Genova) (costo 20))
        (best_state (best_cost 999) (best_id 0)) ; É l'area di memoria dove salvo il nodo migliore
        (setgen 0)                               ; che andró ad aprire. Lo uso in defrule select
        (current (id_current(gensym*)))
        )


(defrule start

=>
  (focus EXPAND)

)


(defmodule EXPAND (import MAIN ?ALL) (export ?ALL))

(defrule combinazioni
=>
  ; Cerco tutti gli spostamenti possibili di ogni furgone
  (do-for-all-facts ((?f furgone)) TRUE
    (do-for-all-facts ((?t tratta)) (eq ?t:partenza ?f:posizione)
      (assert (spostamento(id_mezzo ?f:id) (partenza ?t:partenza) (arrivo ?t:arrivo)
                          (costo ?t:costo)
              )
      )
    )
  )
  ; Creo tutte le combinazioni (stati) possibili
  (do-for-all-facts ((?s1 spostamento) (?s2 spostamento) (?ft current)) (< ?s1:id_mezzo ?s2:id_mezzo)
    (assert (combinazione (furgone1_partenza ?s1:partenza) (furgone1_arrivo ?s1:arrivo)
                          (furgone2_partenza ?s2:partenza) (furgone2_arrivo ?s2:arrivo)
                          (costo (+ ?s1:costo ?s2:costo))
                          (id (gensym*)) (padre ?ft:id_current)
            )
    )
  )
  (focus SELECT)
)

(defmodule SELECT (import EXPAND ?ALL) (export ?ALL))

(defrule isgoal (declare (salience 100)) ; controllo se il costo ha superato 100, in quel caso ho raggiunto il goal

=>
  (do-for-all-facts ((?comb combinazione)) (> ?comb:costo 100)
    (printout t "GOAL RAGGIUNTO" crlf)
    (halt)
  )
)

(defrule selezione (declare (salience 50)); Seleziona il nodo migliore. (NOTA Salva l'ultimo migliore)
  ?d1<-(best_state (best_cost ?bestcost)(best_id ?best_id))
=>
  (do-for-all-facts ((?comb combinazione)) (< ?comb:costo ?bestcost)
    (printout t "Il costo migliore é " ?comb:costo " " ?bestcost crlf)
    (modify ?d1 (best_cost ?comb:costo) (best_id ?comb:id))
    (printout t "I focus sugli stack sono " (list-focus-stack) crlf)
  )
  (pop-focus); dovrebbe tornare ad eseguire EXPAND, PROBLEMA non continua con l'espansione dei nodi
  (printout t "IL focus finale sullo stack é " (list-focus-stack) crlf)
)

;TODo capire come ripartire con l'espansione del nodo scelto (l'id del nodo é salvato in best_state).
; Fare la modify dei fatti "furgone" aggiornando la posizione? (Io penso di si,
; probabilmente prima di fare la pop a riga 88)
;TODo2 mettere un vincolo che un furgone non possa rivisitare la cittá precedente
; (altrimenti continuano a fare avanti e indietro tra le solite due)
;;;
