(defmodule EXPAND (import MAIN ?ALL) (export ?ALL))

(defrule find_new_state
  ?current<-(current (id_current ?id_current_state))

  (state (id_state ?id_current_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))

  (transport (id_state ?id_current_state)(id_transport 1)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity1)(goods_type ?g_type1)
             (city ?trans_city1))
  (transport (id_state ?id_current_state)(id_transport 2)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity2)(goods_type ?g_type2)
             (city ?trans_city2))
  (transport (id_state ?id_current_state)(id_transport 3)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity3)(goods_type ?g_type3)
             (city ?trans_city3))
  (transport (id_state ?id_current_state)(id_transport 4)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity4)(goods_type ?g_type4)
             (city ?trans_city4))
  (transport (id_state ?id_current_state)(id_transport 5)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity5)(goods_type ?g_type5)
             (city ?trans_city5))

  (city (id_state ?id_current_state)(id_city Torino)(requested_goods_quantity ?requested_q1)
        (requested_goods_type ?requested_t1)(provided_goods_quantity ?provided_g1)
        (provided_goods_type ?provided_t1))
  (city (id_state ?id_current_state)(id_city Genova)(requested_goods_quantity ?requested_q2)
        (requested_goods_type ?requested_t2)(provided_goods_quantity ?provided_g2)
        (provided_goods_type ?provided_t2))
  (city (id_state ?id_current_state)(id_city Firenze)(requested_goods_quantity ?requested_q3)
        (requested_goods_type ?requested_t3)(provided_goods_quantity ?provided_g3)
        (provided_goods_type ?provided_t3))
  (city (id_state ?id_current_state)(id_city Bologna)(requested_goods_quantity ?requested_q4)
        (requested_goods_type ?requested_t4)(provided_goods_quantity ?provided_g4)
        (provided_goods_type ?provided_t4))
  (city (id_state ?id_current_state)(id_city Venezia)(requested_goods_quantity ?requested_q5)
        (requested_goods_type ?requested_t5)(provided_goods_quantity ?provided_g5)
        (provided_goods_type ?provided_t5))
  (city (id_state ?id_current_state)(id_city Milano)(requested_goods_quantity ?requested_q6)
        (requested_goods_type ?requested_t6)(provided_goods_quantity ?provided_g6)
        (provided_goods_type ?provided_t6))


=>
  (assert
    (state (id_state (+ ?id_current_state 1))(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))

    (transport (id_state (+ ?id_current_state 1))(id_transport 1)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity1)(goods_type ?g_type1)
               (city ?trans_city1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 2)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity2)(goods_type ?g_type2)
               (city ?trans_city2))
    (transport (id_state (+ ?id_current_state 1))(id_transport 3)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity3)(goods_type ?g_type3)
               (city ?trans_city3))
    (transport (id_state (+ ?id_current_state 1))(id_transport 4)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity4)(goods_type ?g_type4)
               (city ?trans_city4))
    (transport (id_state (+ ?id_current_state 1))(id_transport 5)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity5)(goods_type ?g_type5)
               (city ?trans_city5))

    (city (id_state (+ ?id_current_state 1))(id_city Torino)(requested_goods_quantity ?requested_q1)
          (requested_goods_type ?requested_t1)(provided_goods_quantity ?provided_g1)
          (provided_goods_type ?provided_t1))
    (city (id_state (+ ?id_current_state 1))(id_city Genova)(requested_goods_quantity ?requested_q2)
          (requested_goods_type ?requested_t2)(provided_goods_quantity ?provided_g2)
          (provided_goods_type ?provided_t2))
    (city (id_state (+ ?id_current_state 1))(id_city Firenze)(requested_goods_quantity ?requested_q3)
          (requested_goods_type ?requested_t3)(provided_goods_quantity ?provided_g3)
          (provided_goods_type ?provided_t3))
    (city (id_state (+ ?id_current_state 1))(id_city Bologna)(requested_goods_quantity ?requested_q4)
          (requested_goods_type ?requested_t4)(provided_goods_quantity ?provided_g4)
          (provided_goods_type ?provided_t4))
    (city (id_state (+ ?id_current_state 1))(id_city Venezia)(requested_goods_quantity ?requested_q5)
          (requested_goods_type ?requested_t5)(provided_goods_quantity ?provided_g5)
          (provided_goods_type ?provided_t5))
    (city (id_state (+ ?id_current_state 1))(id_city Milano)(requested_goods_quantity ?requested_q6)
          (requested_goods_type ?requested_t6)(provided_goods_quantity ?provided_g6)
          (provided_goods_type ?provided_t6))
  )

  (modify ?current(id_current (+ ?id_current_state 1)))

  ;(focus EXPANDSHIP)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning
  (assert (next_truck(id_truck 1)))
  (focus MAINEXPANDTRUCK)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning
  ;(focus EXPANDPLANE)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning

)
