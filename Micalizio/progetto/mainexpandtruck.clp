(defmodule MAINEXPANDTRUCK (import EXPAND ?ALL) (export ?ALL))

(defrule find_new_truck_state (declare (salience 100))
  (next_truck(id_truck ?id_truck))
  ;?sp<-(state_planning(id_transport ?id_truck))
=>
  (printout t "changed truck to " ?id_truck crlf)
  (assert (state_planning(id_transport ?id_truck)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus LOADTRANSPORT) ;valuto tutte le possibili azioni per un truck e scelgo la migliore
   ;in base all'azione scelta, aggiorno lo stato delle città e delle merci
   ;incremento il contatore per il prossimo truck da valutare
)

(defrule is_goal (declare (salience 10))
  (city (id_city Torino) (requested_goods_quantity 0))
  (city (id_city Milano) (requested_goods_quantity 0))
  (city (id_city Bologna)(requested_goods_quantity 0))
  (city (id_city Genova) (requested_goods_quantity 0))
  (city (id_city Venezia)(requested_goods_quantity 0))
  (city (id_city Firenze)(requested_goods_quantity 0))
=>
  (assert (stampa 0))
  (pop-focus)
  (pop-focus)
)

(defrule not_yet_goal (declare (salience 9))
=>
  (assert (stampa 0))
  (pop-focus)
)
