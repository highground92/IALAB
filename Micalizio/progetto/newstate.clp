(defmodule NEWSTATE (import MAIN ?ALL) (export ?ALL))

(defrule find_new_state
  ?current<-(current (id_current ?id_current_state))

  (state (id_state ?id_current_state)(total_cost ?total_cost)(weight ?weight)(total_distance ?total_distance))

  (transport (id_state ?id_current_state)(id_transport 1)(transport_type Truck)
             (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity1)(trans_goods_type ?g_type1)
             (city ?trans_city1))
  (transport (id_state ?id_current_state)(id_transport 2)(transport_type Truck)
             (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity2)(trans_goods_type ?g_type2)
             (city ?trans_city2))
  (transport (id_state ?id_current_state)(id_transport 3)(transport_type Truck)
             (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity3)(trans_goods_type ?g_type3)
             (city ?trans_city3))
  (transport (id_state ?id_current_state)(id_transport 4)(transport_type Truck)
             (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity4)(trans_goods_type ?g_type4)
             (city ?trans_city4))
  (transport (id_state ?id_current_state)(id_transport 5)(transport_type Truck)
             (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity5)(trans_goods_type ?g_type5)
             (city ?trans_city5))
  (transport (id_state ?id_current_state)(id_transport 1)(transport_type Ship)
             (type_route Sea)(capacity 11)(trans_goods_quantity ?quantity6)(trans_goods_type ?g_type6)
             (city ?trans_city6))
  (transport (id_state ?id_current_state)(id_transport 2)(transport_type Ship)
             (type_route Sea)(capacity 11)(trans_goods_quantity ?quantity7)(trans_goods_type ?g_type7)
             (city ?trans_city7))
  (transport (id_state ?id_current_state)(id_transport 1)(transport_type Plane)
             (type_route Air)(capacity 7)(trans_goods_quantity ?quantity8)(trans_goods_type ?g_type8)
             (city ?trans_city8))
  (transport (id_state ?id_current_state)(id_transport 2)(transport_type Plane)
             (type_route Air)(capacity 7)(trans_goods_quantity ?quantity9)(trans_goods_type ?g_type9)
             (city ?trans_city9))

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
  (city (id_state ?id_current_state)(id_city Palermo)(requested_goods_quantity ?requested_q7)
        (requested_goods_type ?requested_t7)(provided_goods_quantity ?provided_g7)
        (provided_goods_type ?provided_t7))
  (city (id_state ?id_current_state)(id_city Roma)(requested_goods_quantity ?requested_q8)
        (requested_goods_type ?requested_t8)(provided_goods_quantity ?provided_g8)
        (provided_goods_type ?provided_t8))
  (city (id_state ?id_current_state)(id_city Napoli)(requested_goods_quantity ?requested_q9)
        (requested_goods_type ?requested_t9)(provided_goods_quantity ?provided_g9)
        (provided_goods_type ?provided_t9))
  (city (id_state ?id_current_state)(id_city Bari)(requested_goods_quantity ?requested_q10)
        (requested_goods_type ?requested_t10)(provided_goods_quantity ?provided_g10)
        (provided_goods_type ?provided_t10))
  (city (id_state ?id_current_state)(id_city Reggio)(requested_goods_quantity ?requested_q11)
        (requested_goods_type ?requested_t11)(provided_goods_quantity ?provided_g11)
        (provided_goods_type ?provided_t11))
=>
  (assert
    (state (id_state (+ ?id_current_state 1))(total_cost ?total_cost)(weight ?weight)(total_distance ?total_distance))

    (transport (id_state (+ ?id_current_state 1))(id_transport 1)(transport_type Truck)
               (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity1)
               (trans_goods_type ?g_type1)(city ?trans_city1)(route_id t1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 2)(transport_type Truck)
               (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity2)
               (trans_goods_type ?g_type2)(city ?trans_city2)(route_id t1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 3)(transport_type Truck)
               (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity3)
               (trans_goods_type ?g_type3)(city ?trans_city3)(route_id t1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 4)(transport_type Truck)
               (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity4)
               (trans_goods_type ?g_type4)(city ?trans_city4)(route_id t1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 5)(transport_type Truck)
               (type_route Ground)(capacity 4)(trans_goods_quantity ?quantity5)
               (trans_goods_type ?g_type5)(city ?trans_city5)(route_id t1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 1)(transport_type Ship)
               (type_route Sea)(capacity 11)(trans_goods_quantity ?quantity6)
               (trans_goods_type ?g_type6)(city ?trans_city6)(route_id s1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 2)(transport_type Ship)
               (type_route Sea)(capacity 11)(trans_goods_quantity ?quantity7)
               (trans_goods_type ?g_type7)(city ?trans_city7)(route_id s2))
    (transport (id_state (+ ?id_current_state 1))(id_transport 1)(transport_type Plane)
               (type_route Air)(capacity 7)(trans_goods_quantity ?quantity8)
               (trans_goods_type ?g_type8)(city ?trans_city8)(route_id a1))
    (transport (id_state (+ ?id_current_state 1))(id_transport 2)(transport_type Plane)
               (type_route Air)(capacity 7)(trans_goods_quantity ?quantity9)
               (trans_goods_type ?g_type9)(city ?trans_city9)(route_id a2))

    (city (id_state (+ ?id_current_state 1))(id_city Torino)(requested_goods_quantity ?requested_q1)
          (requested_goods_type ?requested_t1)(provided_goods_quantity ?provided_g1)
          (provided_goods_type ?provided_t1)(route_id a1 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Genova)(requested_goods_quantity ?requested_q2)
          (requested_goods_type ?requested_t2)(provided_goods_quantity ?provided_g2)
          (provided_goods_type ?provided_t2)(route_id s1 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Firenze)(requested_goods_quantity ?requested_q3)
          (requested_goods_type ?requested_t3)(provided_goods_quantity ?provided_g3)
          (provided_goods_type ?provided_t3)(route_id t1))
    (city (id_state (+ ?id_current_state 1))(id_city Bologna)(requested_goods_quantity ?requested_q4)
          (requested_goods_type ?requested_t4)(provided_goods_quantity ?provided_g4)
          (provided_goods_type ?provided_t4)(route_id t1))
    (city (id_state (+ ?id_current_state 1))(id_city Venezia)(requested_goods_quantity ?requested_q5)
          (requested_goods_type ?requested_t5)(provided_goods_quantity ?provided_g5)
          (provided_goods_type ?provided_t5)(route_id s2 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Milano)(requested_goods_quantity ?requested_q6)
          (requested_goods_type ?requested_t6)(provided_goods_quantity ?provided_g6)
          (provided_goods_type ?provided_t6)(route_id a2 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Palermo)(requested_goods_quantity ?requested_q7)
          (requested_goods_type ?requested_t7)(provided_goods_quantity ?provided_g7)
          (provided_goods_type ?provided_t7)(route_id s1 a1))
    (city (id_state (+ ?id_current_state 1))(id_city Roma)(requested_goods_quantity ?requested_q8)
          (requested_goods_type ?requested_t8)(provided_goods_quantity ?provided_g8)
          (provided_goods_type ?provided_t8)(route_id a1 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Napoli)(requested_goods_quantity ?requested_q9)
          (requested_goods_type ?requested_t9)(provided_goods_quantity ?provided_g9)
          (provided_goods_type ?provided_t9)(route_id s1 a2 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Bari)(requested_goods_quantity ?requested_q10)
          (requested_goods_type ?requested_t10)(provided_goods_quantity ?provided_g10)
          (provided_goods_type ?provided_t10)(route_id s2 a2 t1))
    (city (id_state (+ ?id_current_state 1))(id_city Reggio)(requested_goods_quantity ?requested_q11)
          (requested_goods_type ?requested_t11)(provided_goods_quantity ?provided_g11)
          (provided_goods_type ?provided_t11)(route_id t1))
  )

  (modify ?current(id_current (+ ?id_current_state 1)))
  (assert (next_trans(id_trans 1)(type_trans Ship)))
  (focus MAINTRANSPORT)
)
