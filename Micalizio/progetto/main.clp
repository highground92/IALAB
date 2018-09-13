(defmodule MAIN (export ?ALL))

(deftemplate state (slot id_state)(slot f_cost)(slot h_cost)(slot g_cost))

(deftemplate city (slot id_state)(slot id_city)(slot requested_goods_quantity)
                  (slot requested_goods_type)(slot provided_goods_quantity)
                  (slot provided_goods_type)(multislot route_id))

(deftemplate transport (slot id_state)(slot id_transport)(slot transport_type)(slot type_route) ;Per il momento si assume un solo tipo di merci trasportato
                       (slot capacity)(slot trans_goods_quantity)(slot trans_goods_type)
                       (slot city)(slot route_id))

(deftemplate route (slot departure)(slot arrival)(slot km)(slot type_route))

(deftemplate move_to (slot id_transport)(slot departure)(slot arrival)(slot km))

(deftemplate current (slot id_current) (slot g_cost))

(deftemplate next_trans (slot id_trans)(slot type_trans))

(deftemplate state_planning (slot id_transport)(slot transport_type)(slot id_city )
                            (slot f_cost)(slot h_cost)(slot g_cost)
                            (slot requested_goods_quantity)(slot requested_goods_type)
                            (slot provided_goods_quantity)(slot provided_goods_type)
                            (slot trans_goods_quantity)(slot trans_goods_type))

(deftemplate new-destination (slot id_city)(slot distance))

(deftemplate action (slot type))

(deffacts domain

  (route (departure Torino) (arrival Milano)  (km 138) (type_route Ground))
  (route (departure Torino) (arrival Genova)  (km 170) (type_route Ground))
  (route (departure Torino) (arrival Roma)    (km 669) (type_route Air))
  (route (departure Torino) (arrival Palermo) (km 1596) (type_route Air))

  (route (departure Torino) (arrival Venezia) (km 405) (type_route NA))
  (route (departure Torino) (arrival Bologna) (km 327) (type_route NA))
  (route (departure Torino) (arrival Firenze) (km 400) (type_route NA))
  (route (departure Torino) (arrival Napoli)  (km 869) (type_route NA))
  (route (departure Torino) (arrival Bari)    (km 998) (type_route NA))
  (route (departure Torino) (arrival Reggio)  (km 1312) (type_route NA))

  (route (departure Milano) (arrival Torino)  (km 138) (type_route Ground))
  (route (departure Milano) (arrival Bologna) (km 206) (type_route Ground))
  (route (departure Milano) (arrival Venezia) (km 276) (type_route Ground))
  (route (departure Milano) (arrival Napoli)  (km 764) (type_route Air))
  (route (departure Milano) (arrival Bari)    (km 711) (type_route Air))

  (route (departure Milano) (arrival Genova)  (km 253) (type_route NA))
  (route (departure Milano) (arrival Firenze) (km 295) (type_route NA))
  (route (departure Milano) (arrival Roma)    (km 564) (type_route NA))
  (route (departure Milano) (arrival Reggio)  (km 1208) (type_route NA))
  (route (departure Milano) (arrival Palermo) (km 1476) (type_route NA))

  (route (departure Genova) (arrival Firenze) (km 230) (type_route Ground))
  (route (departure Genova) (arrival Torino)  (km 170) (type_route Ground))
  (route (departure Genova) (arrival Palermo) (km 1412) (type_route Sea))

  (route (departure Genova) (arrival Milano)  (km 253) (type_route NA))
  (route (departure Genova) (arrival Bologna) (km 393) (type_route NA))
  (route (departure Genova) (arrival Venezia) (km 402) (type_route NA))
  (route (departure Genova) (arrival Roma)    (km 507) (type_route NA))
  (route (departure Genova) (arrival Napoli)  (km 707) (type_route NA))
  (route (departure Genova) (arrival Bari)    (km 407) (type_route NA))
  (route (departure Genova) (arrival Reggio)  (km 1150) (type_route NA))

  (route (departure Firenze) (arrival Genova) (km 230) (type_route Ground))
  (route (departure Firenze) (arrival Bologna)(km 101) (type_route Ground))
  (route (departure Firenze) (arrival Roma)   (km 268) (type_route Ground))

  (route (departure Firenze) (arrival Torino)  (km 400) (type_route NA))
  (route (departure Firenze) (arrival Milano)  (km 295) (type_route NA))
  (route (departure Firenze) (arrival Venezia) (km 258) (type_route NA))
  (route (departure Firenze) (arrival Napoli)  (km 468) (type_route NA))
  (route (departure Firenze) (arrival Bari)    (km 662) (type_route NA))
  (route (departure Firenze) (arrival Reggio)  (km 912) (type_route NA))
  (route (departure Firenze) (arrival Palermo) (km 1185) (type_route NA))

  (route (departure Bologna) (arrival Firenze) (km 101) (type_route Ground))
  (route (departure Bologna) (arrival Venezia) (km 158) (type_route Ground))
  (route (departure Bologna) (arrival Milano)  (km 206) (type_route Ground))

  (route (departure Bologna) (arrival Torino) (km 327) (type_route NA))
  (route (departure Bologna) (arrival Genova) (km 393) (type_route NA))
  (route (departure Bologna) (arrival Roma)   (km 370) (type_route NA))
  (route (departure Bologna) (arrival Napoli) (km 570) (type_route NA))
  (route (departure Bologna) (arrival Bari)   (km 1026) (type_route NA))
  (route (departure Bologna) (arrival Reggio) (km 1014) (type_route NA))
  (route (departure Bologna) (arrival Palermo)(km 1288) (type_route NA))

  (route (departure Venezia) (arrival Milano)  (km 276) (type_route Ground))
  (route (departure Venezia) (arrival Bologna) (km 158) (type_route Ground))
  (route (departure Venezia) (arrival Bari)    (km 754) (type_route Sea))

  (route (departure Venezia) (arrival Torino)  (km 405) (type_route NA))
  (route (departure Venezia) (arrival Genova)  (km 402) (type_route NA))
  (route (departure Venezia) (arrival Firenze) (km 258) (type_route NA))
  (route (departure Venezia) (arrival Roma)    (km 527) (type_route NA))
  (route (departure Venezia) (arrival Napoli)  (km 727) (type_route NA))
  (route (departure Venezia) (arrival Reggio)  (km 1171) (type_route NA))
  (route (departure Venezia) (arrival Palermo) (km 1431) (type_route NA))

  (route (departure Roma) (arrival Firenze) (km 268) (type_route Ground))
  (route (departure Roma) (arrival Napoli)  (km 219) (type_route Ground))
  (route (departure Roma) (arrival Torino)  (km 669) (type_route Air))

  (route (departure Roma) (arrival Milano)  (km 564) (type_route NA))
  (route (departure Roma) (arrival Venezia) (km 527) (type_route NA))
  (route (departure Roma) (arrival Bologna) (km 370) (type_route NA))
  (route (departure Roma) (arrival Genova)  (km 507) (type_route NA))
  (route (departure Roma) (arrival Bari)    (km 412) (type_route NA))
  (route (departure Roma) (arrival Reggio)  (km 662) (type_route NA))
  (route (departure Roma) (arrival Palermo) (km 932) (type_route NA))

  (route (departure Napoli) (arrival Roma)   (km 219) (type_route Ground))
  (route (departure Napoli) (arrival Bari)   (km 255) (type_route Ground))
  (route (departure Napoli) (arrival Reggio) (km 462) (type_route Ground))
  (route (departure Napoli) (arrival Palermo)(km 740) (type_route Sea))
  (route (departure Napoli) (arrival Milano) (km 764) (type_route Air))

  (route (departure Napoli) (arrival Torino)  (km 869) (type_route NA))
  (route (departure Napoli) (arrival Genova)  (km 707) (type_route NA))
  (route (departure Napoli) (arrival Venezia) (km 727) (type_route NA))
  (route (departure Napoli) (arrival Bologna) (km 570) (type_route NA))
  (route (departure Napoli) (arrival Firenze) (km 468) (type_route NA))

  (route (departure Bari) (arrival Napoli)  (km 255) (type_route Ground))
  (route (departure Bari) (arrival Venezia) (km 754) (type_route Sea))
  (route (departure Bari) (arrival Milano)  (km 711) (type_route Air))

  (route (departure Bari) (arrival Torino)  (km 998) (type_route NA))
  (route (departure Bari) (arrival Genova)  (km 407) (type_route NA))
  (route (departure Bari) (arrival Bologna) (km 1026) (type_route NA))
  (route (departure Bari) (arrival Firenze) (km 662) (type_route NA))
  (route (departure Bari) (arrival Roma)    (km 412) (type_route NA))
  (route (departure Bari) (arrival Reggio)  (km 439) (type_route NA))
  (route (departure Bari) (arrival Palermo) (km 762) (type_route NA))

  (route (departure Reggio) (arrival Napoli)(km 462) (type_route Ground))

  (route (departure Reggio) (arrival Torino) (km 1312) (type_route NA))
  (route (departure Reggio) (arrival Milano) (km 1208) (type_route NA))
  (route (departure Reggio) (arrival Venezia)(km 1171) (type_route NA))
  (route (departure Reggio) (arrival Genova) (km 1150) (type_route NA))
  (route (departure Reggio) (arrival Bologna)(km 1014) (type_route NA))
  (route (departure Reggio) (arrival Firenze)(km 912) (type_route NA))
  (route (departure Reggio) (arrival Roma)   (km 662) (type_route NA))
  (route (departure Reggio) (arrival Bari)   (km 439) (type_route NA))
  (route (departure Reggio) (arrival Palermo)(km 257) (type_route NA))

  (route (departure Palermo) (arrival Napoli) (km 740) (type_route Sea))
  (route (departure Palermo) (arrival Genova) (km 1412) (type_route Sea))
  (route (departure Palermo) (arrival Torino) (km 1596) (type_route Air))

  (route (departure Palermo) (arrival Milano)  (km 1476) (type_route NA))
  (route (departure Palermo) (arrival Venezia) (km 1431) (type_route NA))
  (route (departure Palermo) (arrival Bologna) (km 1288) (type_route NA))
  (route (departure Palermo) (arrival Firenze) (km 1185) (type_route NA))
  (route (departure Palermo) (arrival Roma)    (km 932) (type_route NA))
  (route (departure Palermo) (arrival Bari)    (km 762) (type_route NA))
  (route (departure Palermo) (arrival Reggio)  (km 257) (type_route NA))
)

(deffacts S0
  (current (id_current 0)(g_cost 0))

  (state(id_state 0)(f_cost 999999)(h_cost 999999)(g_cost 0))
  (transport (id_state 0)(id_transport 1)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Bologna)(route_id t1))
  (transport (id_state 0)(id_transport 2)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Bologna)(route_id t1))
  (transport (id_state 0)(id_transport 3)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Bologna)(route_id t1))
  (transport (id_state 0)(id_transport 4)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Roma)(route_id t1))
  (transport (id_state 0)(id_transport 5)(transport_type Truck)(type_route Ground)
             (capacity 4)(trans_goods_quantity 0)(trans_goods_type NA)(city Roma)(route_id t1))

  (transport (id_state 0)(id_transport 1)(transport_type Plane)(type_route Air)
           (capacity 7)(trans_goods_quantity 0)(trans_goods_type NA)(city Palermo)(route_id a1))
  (transport (id_state 0)(id_transport 2)(transport_type Plane)(type_route Air)
           (capacity 7)(trans_goods_quantity 0)(trans_goods_type NA)(city Milano)(route_id a2))

  (transport (id_state 0)(id_transport 1)(transport_type Ship)(type_route Sea)
             (capacity 11)(trans_goods_quantity 0)(trans_goods_type NA)(city Genova)(route_id s1))
  (transport (id_state 0)(id_transport 2)(transport_type Ship)(type_route Sea)
             (capacity 11)(trans_goods_quantity 0)(trans_goods_type NA)(city Venezia)(route_id s2))


  (city (id_state 0)(id_city Torino)(requested_goods_quantity 20)(requested_goods_type A)
        ( provided_goods_quantity 10)(provided_goods_type B)(route_id a1 t1))
  (city (id_state 0)(id_city Genova)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 10)(provided_goods_type C)(route_id s1 t1))
  (city (id_state 0)(id_city Palermo)(requested_goods_quantity 5)(requested_goods_type C)
        ( provided_goods_quantity 10)(provided_goods_type A)(route_id s1 a1))
  (city (id_state 0)(id_city Bologna)(requested_goods_quantity 10)(requested_goods_type C)
        ( provided_goods_quantity 10)(provided_goods_type B)(route_id t1))
  (city (id_state 0)(id_city Venezia)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 10)(provided_goods_type C)(route_id s2 t1))
  (city (id_state 0)(id_city Milano)(requested_goods_quantity 30)(requested_goods_type A)
        ( provided_goods_quantity 5)(provided_goods_type C)(route_id a2 t1))
  (city (id_state 0)(id_city Roma)(requested_goods_quantity 5)(requested_goods_type C)
        ( provided_goods_quantity 10)(provided_goods_type A)(route_id a1 t1))
  (city (id_state 0)(id_city Napoli)(requested_goods_quantity 5)(requested_goods_type C)
        ( provided_goods_quantity 5)(provided_goods_type B)(route_id s1 a2 t1))
  (city (id_state 0)(id_city Bari)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 10)(provided_goods_type A)(route_id s2 a2 t1))
  (city (id_state 0)(id_city Reggio)(requested_goods_quantity 10)(requested_goods_type B)
        ( provided_goods_quantity 20)(provided_goods_type A)(route_id t1))
  (city (id_state 0)(id_city Firenze)(requested_goods_quantity 0)(requested_goods_type NA)
        ( provided_goods_quantity 0)(provided_goods_type NA)(route_id t1))
  )

(defrule start
  (current (id_current 0))
=>
  (focus NEWSTATE)
)

(defrule print-solution (declare (salience 50))
  ?id_stampa<-(stampa ?id)

  (state (id_state ?id)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))

  (transport (id_state ?id)(id_transport 1)(transport_type Ship)
    (trans_goods_quantity ?quantity1)(trans_goods_type ?g_type1)(city ?trans_city1))
  (transport (id_state ?id)(id_transport 2)(transport_type Ship)
    (trans_goods_quantity ?quantity2)(trans_goods_type ?g_type2)(city ?trans_city2))
  (transport (id_state ?id)(id_transport 1)(transport_type Plane)
    (trans_goods_quantity ?quantity3)(trans_goods_type ?g_type3)(city ?trans_city3))
  (transport (id_state ?id)(id_transport 2)(transport_type Plane)
    (trans_goods_quantity ?quantity4)(trans_goods_type ?g_type4)(city ?trans_city4))
  (transport (id_state ?id)(id_transport 1)(transport_type Truck)
    (trans_goods_quantity ?quantity5)(trans_goods_type ?g_type5)(city ?trans_city5))
  (transport (id_state ?id)(id_transport 2)(transport_type Truck)
    (trans_goods_quantity ?quantity6)(trans_goods_type ?g_type6)(city ?trans_city6))
  (transport (id_state ?id)(id_transport 3)(transport_type Truck)
    (trans_goods_quantity ?quantity7)(trans_goods_type ?g_type7)(city ?trans_city7))
  (transport (id_state ?id)(id_transport 4)(transport_type Truck)
    (trans_goods_quantity ?quantity8)(trans_goods_type ?g_type8)(city ?trans_city8))
  (transport (id_state ?id)(id_transport 5)(transport_type Truck)
    (trans_goods_quantity ?quantity9)(trans_goods_type ?g_type9)(city ?trans_city9))

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
  (city (id_state ?id)(id_city Palermo)(requested_goods_quantity ?requested_q7)
        (requested_goods_type ?requested_t7)( provided_goods_quantity ?provided_g7)
        (provided_goods_type ?provided_t7))
  (city (id_state ?id)(id_city Roma)(requested_goods_quantity ?requested_q8)
        (requested_goods_type ?requested_t8)( provided_goods_quantity ?provided_g8)
        (provided_goods_type ?provided_t8))
  (city (id_state ?id)(id_city Napoli)(requested_goods_quantity ?requested_q9)
        (requested_goods_type ?requested_t9)( provided_goods_quantity ?provided_g9)
        (provided_goods_type ?provided_t9))
  (city (id_state ?id)(id_city Bari)(requested_goods_quantity ?requested_q10)
        (requested_goods_type ?requested_t10)( provided_goods_quantity ?provided_g10)
        (provided_goods_type ?provided_t10))
  (city (id_state ?id)(id_city Reggio)(requested_goods_quantity ?requested_q11)
        (requested_goods_type ?requested_t11)( provided_goods_quantity ?provided_g11)
        (provided_goods_type ?provided_t11))

=>
  (printout t "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞" crlf)
  (printout t "STATO " ?id " f_cost " ?f_cost  " h_cost " ?h_cost " g_cost " ?g_cost crlf)
  (printout t "Trasporto 1 tipo Ship, goods " ?quantity1 " " ?g_type1 " citta " ?trans_city1 crlf)
  (printout t "Trasporto 2 tipo Ship, goods " ?quantity2 " " ?g_type2 " citta " ?trans_city2 crlf)
  (printout t "Trasporto 1 tipo Plane, goods " ?quantity3 " " ?g_type3 " citta " ?trans_city3 crlf)
  (printout t "Trasporto 2 tipo Plane, goods " ?quantity4 " " ?g_type4 " citta " ?trans_city4 crlf)
  (printout t "Trasporto 1 tipo Truck, goods " ?quantity5 " " ?g_type5 " citta " ?trans_city5 crlf)
  (printout t "Trasporto 2 tipo Truck, goods " ?quantity6 " " ?g_type6 " citta " ?trans_city6 crlf)
  (printout t "Trasporto 3 tipo Truck, goods " ?quantity7 " " ?g_type7 " citta " ?trans_city7 crlf)
  (printout t "Trasporto 4 tipo Truck, goods " ?quantity8 " " ?g_type8 " citta " ?trans_city8 crlf)
  (printout t "Trasporto 5 tipo Truck, goods " ?quantity9 " " ?g_type9 " citta " ?trans_city9 crlf)

  (printout t "Citta Torino requested " ?requested_q1 " " ?requested_t1 " provided " ?provided_g1 " " ?provided_t1 crlf)
  (printout t "Citta Genova requested " ?requested_q2 " " ?requested_t2 " provided " ?provided_g2 " " ?provided_t2 crlf)
  (printout t "Citta Firenze requested " ?requested_q3 " " ?requested_t3 " provided " ?provided_g3 " " ?provided_t3 crlf)
  (printout t "Citta Venezia requested " ?requested_q4 " " ?requested_t4 " provided " ?provided_g4 " " ?provided_t4 crlf)
  (printout t "Citta Bologna requested " ?requested_q5 " " ?requested_t5 " provided " ?provided_g5 " " ?provided_t5 crlf)
  (printout t "Citta Milano requested " ?requested_q6 " " ?requested_t6 " provided " ?provided_g6 " " ?provided_t6 crlf)
  (printout t "Citta Palermo requested " ?requested_q7 " " ?requested_t7 " provided " ?provided_g7 " " ?provided_t7 crlf)
  (printout t "Citta Roma requested " ?requested_q8 " " ?requested_t8 " provided " ?provided_g8 " " ?provided_t8 crlf)
  (printout t "Citta Napoli requested " ?requested_q9 " " ?requested_t9 " provided " ?provided_g9 " " ?provided_t9 crlf)
  (printout t "Citta Bari requested " ?requested_q10 " " ?requested_t10 " provided " ?provided_g10 " " ?provided_t10 crlf)
  (printout t "Citta Reggio requested " ?requested_q11 " " ?requested_t11 " provided " ?provided_g11 " " ?provided_t11 crlf)
  (assert (stampa (+ ?id 1)))
  (retract ?id_stampa)
)

(defrule print-end (declare (salience 51))
  ?st<-(stampa ?id)
  (current (id_current ?id))

  (state (id_state ?id)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))

  (transport (id_state ?id)(id_transport 1)(transport_type Ship)
    (trans_goods_quantity ?quantity1)(trans_goods_type ?g_type1)(city ?trans_city1))
  (transport (id_state ?id)(id_transport 2)(transport_type Ship)
    (trans_goods_quantity ?quantity2)(trans_goods_type ?g_type2)(city ?trans_city2))
  (transport (id_state ?id)(id_transport 1)(transport_type Plane)
    (trans_goods_quantity ?quantity3)(trans_goods_type ?g_type3)(city ?trans_city3))
  (transport (id_state ?id)(id_transport 2)(transport_type Plane)
    (trans_goods_quantity ?quantity4)(trans_goods_type ?g_type4)(city ?trans_city4))
  (transport (id_state ?id)(id_transport 1)(transport_type Truck)
    (trans_goods_quantity ?quantity5)(trans_goods_type ?g_type5)(city ?trans_city5))
  (transport (id_state ?id)(id_transport 2)(transport_type Truck)
    (trans_goods_quantity ?quantity6)(trans_goods_type ?g_type6)(city ?trans_city6))
  (transport (id_state ?id)(id_transport 3)(transport_type Truck)
    (trans_goods_quantity ?quantity7)(trans_goods_type ?g_type7)(city ?trans_city7))
  (transport (id_state ?id)(id_transport 4)(transport_type Truck)
    (trans_goods_quantity ?quantity8)(trans_goods_type ?g_type8)(city ?trans_city8))
  (transport (id_state ?id)(id_transport 5)(transport_type Truck)
    (trans_goods_quantity ?quantity9)(trans_goods_type ?g_type9)(city ?trans_city9))

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
  (city (id_state ?id)(id_city Palermo)(requested_goods_quantity ?requested_q7)
        (requested_goods_type ?requested_t7)( provided_goods_quantity ?provided_g7)
        (provided_goods_type ?provided_t7))
  (city (id_state ?id)(id_city Roma)(requested_goods_quantity ?requested_q8)
        (requested_goods_type ?requested_t8)( provided_goods_quantity ?provided_g8)
        (provided_goods_type ?provided_t8))
  (city (id_state ?id)(id_city Napoli)(requested_goods_quantity ?requested_q9)
        (requested_goods_type ?requested_t9)( provided_goods_quantity ?provided_g9)
        (provided_goods_type ?provided_t9))
  (city (id_state ?id)(id_city Bari)(requested_goods_quantity ?requested_q10)
        (requested_goods_type ?requested_t10)( provided_goods_quantity ?provided_g10)
        (provided_goods_type ?provided_t10))
  (city (id_state ?id)(id_city Reggio)(requested_goods_quantity ?requested_q11)
        (requested_goods_type ?requested_t11)( provided_goods_quantity ?provided_g11)
        (provided_goods_type ?provided_t11))
=>
  (printout t "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞" crlf)
  (printout t "STATO " ?id " f_cost " ?f_cost  " h_cost " ?h_cost " g_cost " ?g_cost crlf)
  (printout t "Trasporto 1 tipo Ship, goods " ?quantity1 " " ?g_type1 " citta " ?trans_city1 crlf)
  (printout t "Trasporto 2 tipo Ship, goods " ?quantity2 " " ?g_type2 " citta " ?trans_city2 crlf)
  (printout t "Trasporto 1 tipo Plane, goods " ?quantity3 " " ?g_type3 " citta " ?trans_city3 crlf)
  (printout t "Trasporto 2 tipo Plane, goods " ?quantity4 " " ?g_type4 " citta " ?trans_city4 crlf)
  (printout t "Trasporto 1 tipo Truck, goods " ?quantity5 " " ?g_type5 " citta " ?trans_city5 crlf)
  (printout t "Trasporto 2 tipo Truck, goods " ?quantity6 " " ?g_type6 " citta " ?trans_city6 crlf)
  (printout t "Trasporto 3 tipo Truck, goods " ?quantity7 " " ?g_type7 " citta " ?trans_city7 crlf)
  (printout t "Trasporto 4 tipo Truck, goods " ?quantity8 " " ?g_type8 " citta " ?trans_city8 crlf)
  (printout t "Trasporto 5 tipo Truck, goods " ?quantity9 " " ?g_type9 " citta " ?trans_city9 crlf)

  (printout t "Citta Torino requested " ?requested_q1 " " ?requested_t1 " provided " ?provided_g1 " " ?provided_t1 crlf)
  (printout t "Citta Genova requested " ?requested_q2 " " ?requested_t2 " provided " ?provided_g2 " " ?provided_t2 crlf)
  (printout t "Citta Firenze requested " ?requested_q3 " " ?requested_t3 " provided " ?provided_g3 " " ?provided_t3 crlf)
  (printout t "Citta Venezia requested " ?requested_q4 " " ?requested_t4 " provided " ?provided_g4 " " ?provided_t4 crlf)
  (printout t "Citta Bologna requested " ?requested_q5 " " ?requested_t5 " provided " ?provided_g5 " " ?provided_t5 crlf)
  (printout t "Citta Milano requested " ?requested_q6 " " ?requested_t6 " provided " ?provided_g6 " " ?provided_t6 crlf)
  (printout t "Citta Palermo requested " ?requested_q7 " " ?requested_t7 " provided " ?provided_g7 " " ?provided_t7 crlf)
  (printout t "Citta Roma requested " ?requested_q8 " " ?requested_t8 " provided " ?provided_g8 " " ?provided_t8 crlf)
  (printout t "Citta Napoli requested " ?requested_q9 " " ?requested_t9 " provided " ?provided_g9 " " ?provided_t9 crlf)
  (printout t "Citta Bari requested " ?requested_q10 " " ?requested_t10 " provided " ?provided_g10 " " ?provided_t10 crlf)
  (printout t "Citta Reggio requested " ?requested_q11 " " ?requested_t11 " provided " ?provided_g11 " " ?provided_t11 crlf)
  (printout t "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞" crlf)
  (printout t "FINE" crlf)
  (retract ?st)
)
;;;;;;;;;;;;;;;;;;;;
