(defmodule MAINTRANSPORT (import NEWSTATE ?ALL) (export ?ALL))

(defrule is_goal (declare (salience 100))
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

(defrule find_new_ship_state (declare (salience 50))
  (next_trans(id_trans ?id_ship)(type_trans Ship))
=>
  (printout t "changed ship to " ?id_ship crlf)
  (assert (state_planning(id_transport ?id_ship)(transport_type Ship)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus LOAD)
)

(defrule find_new_plane_state (declare (salience 50))
  (next_trans(id_trans ?id_plane)(type_trans Plane))
=>
  (printout t "changed plane to " ?id_plane crlf)
  (assert (state_planning(id_transport ?id_plane)(transport_type Plane)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus LOAD)
)

(defrule find_new_truck_state (declare (salience 50))
  (next_trans(id_trans ?id_truck)(type_trans Truck))
  ;?sp<-(state_planning(id_transport ?id_truck))
=>
  (printout t "changed truck to " ?id_truck crlf)
  (assert (state_planning(id_transport ?id_truck)(transport_type Truck)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus LOAD) ;valuto tutte le possibili azioni per un truck e scelgo la migliore
   ;in base all'azione scelta, aggiorno lo stato delle città e delle merci
   ;incremento il contatore per il prossimo truck da valutare
)
