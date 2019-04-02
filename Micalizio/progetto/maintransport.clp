(defmodule MAINTRANSPORT (import NEWSTATE ?ALL) (export ?ALL))

(defrule is_goal (declare (salience 100))
  (current (id_current ?id_current))
  (city (id_state ?id_current)(id_city Torino) (requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Milano) (requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Bologna)(requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Genova) (requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Venezia)(requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Firenze)(requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Reggio) (requested_goods_quantity 0))
  (city (id_state ?id_current)(id_city Roma) (requested_goods_quantity 0))

=>
  (assert (stampa 0))
  (pop-focus)
  (pop-focus)
)

(defrule find_new_ship_state (declare (salience 50))
  (next_trans(id_trans ?id_ship)(type_trans Ship))
=>
  (assert (state_planning(id_transport ?id_ship)(transport_type Ship)
                         (weight 99999999)(total_distance 99999999))) ; stubby che verrà rimpiazzato subito
  (focus LOAD)
)

(defrule find_new_plane_state (declare (salience 50))
  (next_trans(id_trans ?id_plane)(type_trans Plane))
=>
  (assert (state_planning(id_transport ?id_plane)(transport_type Plane)
                         (weight 99999999)(total_distance 99999999)))
  (focus LOAD)
)

(defrule find_new_truck_state (declare (salience 50))
  (next_trans(id_trans ?id_truck)(type_trans Truck))
=>
  (assert (state_planning(id_transport ?id_truck)(transport_type Truck)
                         (weight 99999999)(total_distance 99999999)))
  (focus LOAD)
)
