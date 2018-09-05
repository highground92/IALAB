(defmodule MAIN (export ?ALL))

(deftemplate state (slot id_state)(slot f_cost)(slot h_cost)(slot g_cost))

(deftemplate city (slot id_state)(slot id_city)(slot requested_goods_quantity)
                  (slot requested_goods_type)(slot provided_goods_quantity)
                  (slot provided_goods_type))

(deftemplate transport (slot id_state)(slot id_transport)(slot transport_type)(slot type_route) ;Per il momento si assume un solo tipo di merci trasportato
                       (slot capacity)(slot trans_goods_quantity)(slot trans_goods_type)(slot city))

(deftemplate route (slot departure)(slot arrival)(slot km)(slot type_route))

(deftemplate move_to (slot id_transport)(slot departure)(slot arrival)(slot km))

(deftemplate current (slot id_current) (slot g_cost))

(deftemplate next_truck (slot id_truck))

(deftemplate state_planning (slot id_transport)(slot id_city )(slot f_cost)(slot h_cost)(slot g_cost)
                            (slot requested_goods_quantity)(slot requested_goods_type)
                            (slot provided_goods_quantity)(slot provided_goods_type)
                            (slot trans_goods_quantity)(slot trans_goods_type))

(deftemplate move_planning (slot id_city_arrival)(slot f_cost)(slot h_cost)(slot g_cost)(slot father))

(deftemplate action (slot type))

;(deftemplate transport (slot id_state)(slot id_transport)(slot transport_type)(slot type_route) ;Per il momento si assume un solo tipo di merci trasportato
;                       (slot capacity)(multislot goods_quantity)(multislot goods_type)(slot city))
;(transport(goods_quantity $?prev ?q $?aft)) Esempio
(deffacts domain

        (route (departure Torino) (arrival Milano) (km 138) (type_route Ground))
        (route (departure Torino) (arrival Genova) (km 170) (type_route Ground))

        (route (departure Milano) (arrival Torino) (km 138) (type_route Ground))
        (route (departure Milano) (arrival Bologna) (km 206) (type_route Ground))
        (route (departure Milano) (arrival Venezia) (km 276) (type_route Ground))

        (route (departure Genova) (arrival Firenze) (km 230) (type_route Ground))
        (route (departure Genova) (arrival Torino) (km 170) (type_route Ground))

        (route (departure Firenze) (arrival Genova) (km 230) (type_route Ground))
        (route (departure Firenze) (arrival Bologna) (km 101) (type_route Ground))

        (route (departure Bologna) (arrival Firenze) (km 101) (type_route Ground))
        (route (departure Bologna) (arrival Venezia) (km 158) (type_route Ground))
        (route (departure Bologna) (arrival Milano) (km 206) (type_route Ground))

        (route (departure Venezia) (arrival Milano) (km 276) (type_route Ground))
        (route (departure Venezia) (arrival Bologna) (km 158) (type_route Ground))

)

(deffacts S0
  (current (id_current 0)(g_cost 0))

  (state(id_state 0)(f_cost 999999)(h_cost 999999)(g_cost 0))
  (transport (id_state 0)(id_transport 1)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Torino))
  (transport (id_state 0)(id_transport 2)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Milano))
  (transport (id_state 0)(id_transport 3)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Bologna))
  (transport (id_state 0)(id_transport 4)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Genova))
  (transport (id_state 0)(id_transport 5)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Venezia))


  (city (id_state 0)(id_city Torino)(requested_goods_quantity 10)(requested_goods_type A)
        ( provided_goods_quantity 5)(provided_goods_type B))
  (city (id_state 0)(id_city Genova)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 10)(provided_goods_type A))
  (city (id_state 0)(id_city Firenze)(requested_goods_quantity 0)(requested_goods_type NA)
        ( provided_goods_quantity 0)(provided_goods_type NA))
  (city (id_state 0)(id_city Bologna)(requested_goods_quantity 10)(requested_goods_type C)
        ( provided_goods_quantity 5)(provided_goods_type B))
  (city (id_state 0)(id_city Venezia)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 20)(provided_goods_type A))
  (city (id_state 0)(id_city Milano)(requested_goods_quantity 20)(requested_goods_type A)
        ( provided_goods_quantity 10)(provided_goods_type C))




  )

(defrule start
  (current (id_current 0))
=>
  (focus EXPAND)
)

(defrule stampa-soluzione (declare (salience 50))
  ?id_stampa<-(stampa ?id)

  (state (id_state ?id)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id)(id_transport 1)(transport_type ?trans_type1)
    (trans_goods_quantity ?quantity1)(trans_goods_type ?g_type1)(city ?trans_city1))
  (transport (id_state ?id)(id_transport 2)(transport_type ?trans_type2)
    (trans_goods_quantity ?quantity2)(trans_goods_type ?g_type2)(city ?trans_city2))
  (transport (id_state ?id)(id_transport 3)(transport_type ?trans_type3)
    (trans_goods_quantity ?quantity3)(trans_goods_type ?g_type3)(city ?trans_city3))
  (transport (id_state ?id)(id_transport 4)(transport_type ?trans_type4)
    (trans_goods_quantity ?quantity4)(trans_goods_type ?g_type4)(city ?trans_city4))
  (transport (id_state ?id)(id_transport 5)(transport_type ?trans_type5)
    (trans_goods_quantity ?quantity5)(trans_goods_type ?g_type5)(city ?trans_city5))

  (city (id_state ?id)(id_city Torino)(requested_goods_quantity ?requested_q1)
        (requested_goods_type ?requested_t1)( provided_goods_quantity ?provided_g1)
        (provided_goods_type ?provided_t1))
  (city (id_state ?id)(id_city Genova)(requested_goods_quantity ?requested_q2)
        (requested_goods_type ?requested_t2)( provided_goods_quantity ?provided_g2)
        (provided_goods_type ?provided_t2))
  (city (id_state ?id)(id_city Firenze)(requested_goods_quantity ?requested_q3)
        (requested_goods_type ?requested_t3)( provided_goods_quantity ?provided_g3)
        (provided_goods_type ?provided_t3))
  (city (id_state ?id)(id_city Venezia)(requested_goods_quantity ?requested_q4)
        (requested_goods_type ?requested_t4)( provided_goods_quantity ?provided_g4)
        (provided_goods_type ?provided_t4))
  (city (id_state ?id)(id_city Bologna)(requested_goods_quantity ?requested_q5)
        (requested_goods_type ?requested_t5)( provided_goods_quantity ?provided_g5)
        (provided_goods_type ?provided_t5))
  (city (id_state ?id)(id_city Milano)(requested_goods_quantity ?requested_q6)
        (requested_goods_type ?requested_t6)( provided_goods_quantity ?provided_g6)
        (provided_goods_type ?provided_t6))

=>
  (printout t "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞" crlf)
  (printout t "STATO " ?id " f_cost " ?f_cost crlf)
  (printout t "trasporto 1 tipo " ?trans_type1 " goods " ?quantity1 " " ?g_type1 " citta " ?trans_city1 crlf)
  (printout t "trasporto 2 tipo " ?trans_type2 " goods " ?quantity2 " " ?g_type2 " citta " ?trans_city2 crlf)
  (printout t "trasporto 3 tipo " ?trans_type3 " goods " ?quantity3 " " ?g_type3 " citta " ?trans_city3 crlf)
  (printout t "trasporto 4 tipo " ?trans_type4 " goods " ?quantity4 " " ?g_type4 " citta " ?trans_city4 crlf)
  (printout t "trasporto 5 tipo " ?trans_type5 " goods " ?quantity5 " " ?g_type5 " citta " ?trans_city5 crlf)

  (printout t "citta Torino requested " ?requested_q1 " " ?requested_t1 " provided " ?provided_g1 " " ?provided_t1 crlf)
  (printout t "citta Genova requested " ?requested_q2 " " ?requested_t2 " provided " ?provided_g2 " " ?provided_t2 crlf)
  (printout t "citta Firenze requested " ?requested_q3 " " ?requested_t3 " provided " ?provided_g3 " " ?provided_t3 crlf)
  (printout t "citta Venezia requested " ?requested_q4 " " ?requested_t4 " provided " ?provided_g4 " " ?provided_t4 crlf)
  (printout t "citta Bologna requested " ?requested_q5 " " ?requested_t5 " provided " ?provided_g5 " " ?provided_t5 crlf)
  (printout t "citta Milano requested " ?requested_q6 " " ?requested_t6 " provided " ?provided_g6 " " ?provided_t6 crlf)
  (assert (stampa (+ ?id 1)))
  (retract ?id_stampa)
)

(defrule stampa-fine (declare (salience 51))
  ?st<-(stampa ?id)
  (current (id_current ?id))

  (state (id_state ?id)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id)(id_transport 1)(transport_type ?trans_type1)
    (trans_goods_quantity ?quantity1)(trans_goods_type ?g_type1)(city ?trans_city1))
  (transport (id_state ?id)(id_transport 2)(transport_type ?trans_type2)
    (trans_goods_quantity ?quantity2)(trans_goods_type ?g_type2)(city ?trans_city2))
  (transport (id_state ?id)(id_transport 3)(transport_type ?trans_type3)
    (trans_goods_quantity ?quantity3)(trans_goods_type ?g_type3)(city ?trans_city3))
  (transport (id_state ?id)(id_transport 4)(transport_type ?trans_type4)
    (trans_goods_quantity ?quantity4)(trans_goods_type ?g_type4)(city ?trans_city4))
  (transport (id_state ?id)(id_transport 5)(transport_type ?trans_type5)
    (trans_goods_quantity ?quantity5)(trans_goods_type ?g_type5)(city ?trans_city5))

  (city (id_state ?id)(id_city Torino)(requested_goods_quantity ?requested_q1)
        (requested_goods_type ?requested_t1)( provided_goods_quantity ?provided_g1)
        (provided_goods_type ?provided_t1))
  (city (id_state ?id)(id_city Genova)(requested_goods_quantity ?requested_q2)
        (requested_goods_type ?requested_t2)( provided_goods_quantity ?provided_g2)
        (provided_goods_type ?provided_t2))
  (city (id_state ?id)(id_city Firenze)(requested_goods_quantity ?requested_q3)
        (requested_goods_type ?requested_t3)( provided_goods_quantity ?provided_g3)
        (provided_goods_type ?provided_t3))
  (city (id_state ?id)(id_city Venezia)(requested_goods_quantity ?requested_q4)
        (requested_goods_type ?requested_t4)( provided_goods_quantity ?provided_g4)
        (provided_goods_type ?provided_t4))
  (city (id_state ?id)(id_city Bologna)(requested_goods_quantity ?requested_q5)
        (requested_goods_type ?requested_t5)( provided_goods_quantity ?provided_g5)
        (provided_goods_type ?provided_t5))
  (city (id_state ?id)(id_city Milano)(requested_goods_quantity ?requested_q6)
        (requested_goods_type ?requested_t6)( provided_goods_quantity ?provided_g6)
        (provided_goods_type ?provided_t6))
=>
  (printout t "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞" crlf)
  (printout t "STATO " ?id " f_cost " ?f_cost crlf)
  (printout t "trasporto 1 tipo " ?trans_type1 " goods " ?quantity1 " " ?g_type1 " citta " ?trans_city1  crlf)
  (printout t "trasporto 2 tipo " ?trans_type2 " goods " ?quantity2 " " ?g_type2 " citta " ?trans_city2  crlf)
  (printout t "trasporto 3 tipo " ?trans_type3 " goods " ?quantity3 " " ?g_type3 " citta " ?trans_city3  crlf)
  (printout t "trasporto 4 tipo " ?trans_type4 " goods " ?quantity4 " " ?g_type4 " citta " ?trans_city4  crlf)
  (printout t "trasporto 5 tipo " ?trans_type5 " goods " ?quantity5 " " ?g_type5 " citta " ?trans_city5  crlf)

  (printout t "citta Torino requested " ?requested_q1 " " ?requested_t1 " provided " ?provided_g1 " " ?provided_t1 crlf)
  (printout t "citta Genova requested " ?requested_q2 " " ?requested_t2 " provided " ?provided_g2 " " ?provided_t2 crlf)
  (printout t "citta Firenze requested " ?requested_q3 " " ?requested_t3 " provided " ?provided_g3 " " ?provided_t3 crlf)
  (printout t "citta Venezia requested " ?requested_q4 " " ?requested_t4 " provided " ?provided_g4 " " ?provided_t4 crlf)
  (printout t "citta Bologna requested " ?requested_q5 " " ?requested_t5 " provided " ?provided_g5 " " ?provided_t5 crlf)
  (printout t "citta Milano requested " ?requested_q6 " " ?requested_t6 " provided " ?provided_g6 " " ?provided_t6 crlf)
  (printout t "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞" crlf)
  (printout t "FINE" crlf)
  (retract ?st)
)
;;;;;;;;;;;;;;;;;;;;
