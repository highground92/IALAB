(defmodule MAINSHIP (import NEWSTATE ?ALL) (export ?ALL))

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

(defrule find_new_ship_state (declare (salience 10))
  (next_trans(id_trans ?id_ship)(type_trans Ship))
=>
  (printout t "changed truck to " ?id_ship crlf)
  (assert (state_planning(id_transport ?id_ship)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus LOAD)
)
