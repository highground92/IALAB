(deftemplate furgone (slot id) (slot posizione))

(deftemplate citta (slot nome))

(deftemplate tratta (slot partenza) (slot arrivo) (slot costo))

(deftemplate spostamento (slot id_mezzo) (slot partenza) (slot arrivo) (slot costo))

(deftemplate combinazione(slot furgone1_partenza) (slot furgone1_arrivo) (slot furgone2_partenza) (slot furgone2_arrivo) (slot costo))


(deffacts domain
        (furgone (id 1) (posizione Torino))
        (furgone (id 2) (posizione Milano))
        (tratta (partenza Torino) (arrivo Milano)  (costo 5))
        (tratta (partenza Torino) (arrivo Genova)  (costo 15))
        (tratta (partenza Torino) (arrivo Firenza) (costo 5))
        (tratta (partenza Genova) (arrivo Bologna) (costo 20))
        (tratta (partenza Milano) (arrivo Torino)  (costo 25))
        (tratta (partenza Milano) (arrivo Firenze) (costo 10))
        )

(defrule start

     =>
     (do-for-all-facts ((?f furgone)) TRUE
        (do-for-all-facts ((?t tratta)) (eq ?t:partenza ?f:posizione) 
                (assert (spostamento(id_mezzo ?f:id) (partenza ?t:partenza) (arrivo ?t:arrivo) (costo ?t:costo))
                        )
                )

        )
     )


(defrule combinazioni 

    =>
        (do-for-all-facts ((?s1 spostamento) (?s2 spostamento)) (< ?s1:id_mezzo ?s2:id_mezzo)
                (assert (combinazione (furgone1_partenza ?s1:partenza) (furgone1_arrivo ?s1:arrivo) 
                  (furgone2_partenza ?s2:partenza) (furgone2_arrivo ?s2:arrivo) (costo (+ ?s1:costo ?s2:costo))
                        )
                )

        )

)