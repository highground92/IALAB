(defmodule MAIN (export ?ALL))

(deftemplate state (slot id_state)(slot f_cost)(slot h_cost)(slot g_cost))

(deftemplate city (slot id_state)(slot id_city)(slot requested_goods_quantity)
                  (slot requested_goods_type)(slot provided_goods_quantity)
                  (slot provided_goods_type))

(deftemplate transport (slot id_state)(slot id_transport)(slot transport_type)(slot type_route) ;Per il momento si assume un solo tipo di merci trasportato
                       (slot capacity)(slot goods_quantity)(slot goods_type)(slot city))

(deftemplate route (slot departure)(slot arrival)(slot km)(slot type_route))

(deftemplate move_to (slot id_transport)(slot departure)(slot arrival)(slot km))

(deftemplate current (slot id_current) (slot g_cost))

(deftemplate next_truck (slot id_truck))

(deftemplate state_planning (slot id_transport)(slot id_city )(slot f_cost)(slot h_cost)(slot g_cost)
                            (slot requested_goods_quantity)(slot goods_quantity)(slot goods_type))

(deffacts domain

        (route (departure Genova) (arrival Bologna) (km 393) (type_route Ground))
        (route (departure Milano) (arrival Torino) (km 138) (type_route Ground))
        (route (departure Milano) (arrival Firenze) (km 295) (type_route Ground))
        (route (departure Firenze) (arrival Genova) (km 230) (type_route Ground))
        (route (departure Firenze) (arrival Bologna) (km 101) (type_route Ground))
        (route (departure Bologna) (arrival Firenze) (km 101) (type_route Ground))
        (route (departure Bologna) (arrival Genova) (km 393) (type_route Ground))
        (route (departure Torino) (arrival Milano) (km 138) (type_route Ground))
        (route (departure Torino) (arrival Genova) (km 170) (type_route Ground))
        (route (departure Torino) (arrival Firenze) (km 400) (type_route Ground))
        (route (departure Firenze) (arrival Torino) (km 400) (type_route Ground))
        (route (departure Venezia) (arrival Milano) (km 276) (type_route Ground))
        (route (departure Venezia) (arrival Bologna) (km 158) (type_route Ground))
        (route (departure Milano) (arrival Venezia) (km 276) (type_route Ground))
        (route (departure Bologna) (arrival Venezia) (km 158) (type_route Ground))

)

(deffacts S0
  (current (id_current 0)(g_cost 0))

  (state(id_state 0)(f_cost 999)(h_cost 999)(g_cost 0))
  (transport (id_state 0)(id_transport 1)(transport_type Truck)(type_route Ground)
             (capacity 4)(goods_quantity 0)(goods_type NA)(city Torino))
  (transport (id_state 0)(id_transport 2)(transport_type Truck)(type_route Ground)
             (capacity 4)(goods_quantity 0)(goods_type NA)(city Milano))
  (transport (id_state 0)(id_transport 3)(transport_type Truck)(type_route Ground)
             (capacity 4)(goods_quantity 0)(goods_type NA)(city Bologna))
  (transport (id_state 0)(id_transport 4)(transport_type Truck)(type_route Ground)
             (capacity 4)(goods_quantity 0)(goods_type NA)(city Genova))
  (transport (id_state 0)(id_transport 5)(transport_type Truck)(type_route Ground)
             (capacity 4)(goods_quantity 0)(goods_type NA)(city Venezia))


  (city (id_state 0)(id_city Torino)(requested_goods_quantity 10)(requested_goods_type A)
        ( provided_goods_quantity 5)(provided_goods_type B))
  (city (id_state 0)(id_city Milano)(requested_goods_quantity 20)(requested_goods_type A)
        ( provided_goods_quantity 10)(provided_goods_type C))
  (city (id_state 0)(id_city Bologna)(requested_goods_quantity 10)(requested_goods_type C)
        ( provided_goods_quantity 5)(provided_goods_type B))
  (city (id_state 0)(id_city Genova)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 10)(provided_goods_type A))
  (city (id_state 0)(id_city Venezia)(requested_goods_quantity 5)(requested_goods_type B)
        ( provided_goods_quantity 20)(provided_goods_type A))
  (city (id_state 0)(id_city Firenze)(requested_goods_quantity 0)(requested_goods_type NA)
        ( provided_goods_quantity 0)(provided_goods_type NA))
  )

; H-cost = (km pesati)*(Merce richiesta - merce consegnata)
; G-cost = km pesati       (nave: km*2/3, furgone:km, aereo: km+km*1/4)

(defrule start
  (current (id_current 0))
=>
  (focus EXPAND)
)

(defrule stampa-soluzione (declare (salience 50))
  ?id_stampa<-(stampa ?id)

  (transport (id_state ?id)(id_transport 1)(transport_type ?trans_type1)
    (goods_quantity ?quantity1)(goods_type ?g_type1)(city ?trans_city1))
  (transport (id_state ?id)(id_transport 2)(transport_type ?trans_type2)
    (goods_quantity ?quantity2)(goods_type ?g_type2)(city ?trans_city2))
  (transport (id_state ?id)(id_transport 3)(transport_type ?trans_type3)
    (goods_quantity ?quantity3)(goods_type ?g_type3)(city ?trans_city3))
  (transport (id_state ?id)(id_transport 4)(transport_type ?trans_type4)
    (goods_quantity ?quantity4)(goods_type ?g_type4)(city ?trans_city4))
  (transport (id_state ?id)(id_transport 5)(transport_type ?trans_type5)
    (goods_quantity ?quantity5)(goods_type ?g_type5)(city ?trans_city5))

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
  (printout t " ////////////////////////////////////////////////////////////////////" crlf)
  (printout t "STATO " ?id crlf)
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
  (printout t " ////////////////////////////////////////////////////////////////////" crlf)

  (assert (stampa (+ ?id 1)))
  (retract ?id_stampa)
)

(defrule stampa-fine (declare (salience 51))
  (stampa ?id)
  (current (id_current ?id))

  (transport (id_state ?id)(id_transport 1)(transport_type ?trans_type1)
    (goods_quantity ?quantity1)(goods_type ?g_type1)(city ?trans_city1))
  (transport (id_state ?id)(id_transport 2)(transport_type ?trans_type2)
    (goods_quantity ?quantity2)(goods_type ?g_type2)(city ?trans_city2))
  (transport (id_state ?id)(id_transport 3)(transport_type ?trans_type3)
    (goods_quantity ?quantity3)(goods_type ?g_type3)(city ?trans_city3))
  (transport (id_state ?id)(id_transport 4)(transport_type ?trans_type4)
    (goods_quantity ?quantity4)(goods_type ?g_type4)(city ?trans_city4))
  (transport (id_state ?id)(id_transport 5)(transport_type ?trans_type5)
    (goods_quantity ?quantity5)(goods_type ?g_type5)(city ?trans_city5))

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
  (printout t " ////////////////////////////////////////////////////////////////////" crlf)
  (printout t "STATO " ?id crlf)
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
  (printout t " ////////////////////////////////////////////////////////////////////" crlf)
  (printout t "FINE" crlf)
  (halt)
)
;;;;;;;;;;;;;;;;;;;;
(defmodule EXPAND (import MAIN ?ALL) (export ?ALL))

(defrule find_new_state
  ?current<-(current (id_current ?id_current_state))

  (state (id_state ?id_current_state))

  (transport (id_state ?id_current_state)(id_transport ?id_trans1)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity1)(goods_type ?g_type1)
             (city ?trans_city1))
  (transport (id_state ?id_current_state)(id_transport ?id_trans2)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity2)(goods_type ?g_type2)
             (city ?trans_city2))
  (transport (id_state ?id_current_state)(id_transport ?id_trans3)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity3)(goods_type ?g_type3)
             (city ?trans_city3))
  (transport (id_state ?id_current_state)(id_transport ?id_trans4)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity4)(goods_type ?g_type4)
             (city ?trans_city4))
  (transport (id_state ?id_current_state)(id_transport ?id_trans5)(transport_type Truck)
             (type_route Ground)(capacity 4)(goods_quantity ?quantity5)(goods_type ?g_type5)
             (city ?trans_city5))

  (city (id_state ?id_current_state)(id_city ?city1)(requested_goods_quantity ?requested_q1)
        (requested_goods_type ?requested_t1)(provided_goods_quantity ?provided_g1)
        (provided_goods_type ?provided_t1))
  (city (id_state ?id_current_state)(id_city ?city2)(requested_goods_quantity ?requested_q2)
        (requested_goods_type ?requested_t2)(provided_goods_quantity ?provided_g2)
        (provided_goods_type ?provided_t2))
  (city (id_state ?id_current_state)(id_city ?city3)(requested_goods_quantity ?requested_q3)
        (requested_goods_type ?requested_t3)(provided_goods_quantity ?provided_g3)
        (provided_goods_type ?provided_t3))
  (city (id_state ?id_current_state)(id_city ?city4)(requested_goods_quantity ?requested_q4)
        (requested_goods_type ?requested_t4)(provided_goods_quantity ?provided_g4)
        (provided_goods_type ?provided_t4))
  (city (id_state ?id_current_state)(id_city ?city5)(requested_goods_quantity ?requested_q5)
        (requested_goods_type ?requested_t5)(provided_goods_quantity ?provided_g5)
        (provided_goods_type ?provided_t5))
  (city (id_state ?id_current_state)(id_city ?city6)(requested_goods_quantity ?requested_q6)
        (requested_goods_type ?requested_t6)(provided_goods_quantity ?provided_g6)
        (provided_goods_type ?provided_t6))

=>
  (assert
    (state (id_state (+ ?id_current_state 1)))

    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans1)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity1)(goods_type ?g_type1)
               (city ?trans_city1))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans2)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity2)(goods_type ?g_type2)
               (city ?trans_city2))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans3)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity3)(goods_type ?g_type3)
               (city ?trans_city3))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans4)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity4)(goods_type ?g_type4)
               (city ?trans_city4))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans5)(transport_type Truck)
               (type_route Ground)(capacity 4)(goods_quantity ?quantity5)(goods_type ?g_type5)
               (city ?trans_city5))

    (city (id_state (+ ?id_current_state 1))(id_city ?city1)(requested_goods_quantity ?requested_q1)
          (requested_goods_type ?requested_t1)(provided_goods_quantity ?provided_g1)
          (provided_goods_type ?provided_t1))
    (city (id_state (+ ?id_current_state 1))(id_city ?city2)(requested_goods_quantity ?requested_q2)
          (requested_goods_type ?requested_t2)(provided_goods_quantity ?provided_g2)
          (provided_goods_type ?provided_t2))
    (city (id_state (+ ?id_current_state 1))(id_city ?city3)(requested_goods_quantity ?requested_q3)
          (requested_goods_type ?requested_t3)(provided_goods_quantity ?provided_g3)
          (provided_goods_type ?provided_t3))
    (city (id_state (+ ?id_current_state 1))(id_city ?city4)(requested_goods_quantity ?requested_q4)
          (requested_goods_type ?requested_t4)(provided_goods_quantity ?provided_g4)
          (provided_goods_type ?provided_t4))
    (city (id_state (+ ?id_current_state 1))(id_city ?city5)(requested_goods_quantity ?requested_q5)
          (requested_goods_type ?requested_t5)(provided_goods_quantity ?provided_g5)
          (provided_goods_type ?provided_t5))
    (city (id_state (+ ?id_current_state 1))(id_city ?city6)(requested_goods_quantity ?requested_q6)
          (requested_goods_type ?requested_t6)(provided_goods_quantity ?provided_g6)
          (provided_goods_type ?provided_t6))
  )

  (modify ?current(id_current (+ ?id_current_state 1)))

  ;(focus EXPANDSHIP)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning
  (assert (next_truck(id_truck 1)))
  (focus MAINEXPANDTRUCK)
  (focus CHECKGOAL)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning
  ;(focus EXPANDPLANE)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning

)

(defmodule MAINEXPANDTRUCK (import EXPAND ?ALL) (export ?ALL))

(defrule find_new_truck_state
  (next_truck(id_truck ?id_truck))
  ;?sp<-(state_planning(id_transport ?id_truck))
=>
  (assert (state_planning(id_transport ?id_truck)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus EXPANDTRUCK) ;valuto tutte le possibili azioni per un truck e scelgo la migliore
  (focus UPDATESTATE) ;in base all'azione scelta, aggiorno lo stato delle città e delle merci
  (focus NEXTTRUCK)   ;incremento il contatore per il prossimo truck da valutare
)

(defmodule EXPANDTRUCK (import MAINEXPANDTRUCK ?ALL) (export ?ALL))

;Caso in cui il furgone è vuoto e valuta di andare in una città che può fornire merci
(defrule expand-truck-empty-cargo-city-with-goods
  (next_truck(id_truck ?id_trans))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type Truck)
             (type_route Ground)(goods_quantity 0)(goods_type NA)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ;Informazioni temporanee da salvare in state
  ?stateplanning<-(state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (goods_quantity ?goodsq)(goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (route
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground))

  (test (< (+ (* ?km ?rgq) ?km) ?fcostplanning))
  (test (> ?pgq 0))
=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (goods_quantity 0)(goods_type NA)
                         (f_cost (+ (* ?km ?rgq) ?km))
                         (h_cost (* ?km ?rgq))(g_cost ?km)
  )

)

;Caso in cui il furgone è vuoto e valuta di andare in una città che non può fornire merci
(defrule expand-truck-empty-cargo-city-with-no-goods
  (next_truck(id_truck ?id_trans))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type Truck)
             (type_route Ground)(goods_quantity 0)(goods_type NA)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type)(provided_goods_quantity 0)(provided_goods_type NA))

  ;Informazioni temporanee da salvare in state
  ?stateplanning<-(state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (goods_quantity ?goodsq)(goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (route
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground))
  (test (< (+ (* ?km ?rgq 20) ?km) ?fcostplanning))
=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (goods_quantity 0)(goods_type NA)
                         (f_cost (+ (* ?km ?rgq 20) ?km))
                         (h_cost (* ?km ?rgq 20))(g_cost ?km)
  )

)

; Controllo se la differenza della quantitá tra merce richiesta della cittá e quella scaricata dal furgone é positiva
(defrule expand-truck-quantity-pos
  (next_truck(id_truck ?id_trans))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type Truck)
             (type_route Ground)(goods_quantity ?gq)(goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type))

  ;Informazioni temporanee da salvare in state
  ?stateplanning<-(state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (goods_quantity ?goodsq)(goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (route
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground))
  (test (< (+ (* ?km (- ?rgq ?gq)) ?km) ?fcostplanning)) ; calcolo dell'euristica
  (test (>= ?rgq ?gq))
=>
  ;(f_cost (+ (* ?km (- ?rgq ?gq1)) ?km))
  ;(h_cost (* ?km (- ?rgq ?gq1)))
  ;(g_cost ?km)
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?arrival)
                         (requested_goods_quantity (- ?rgq ?gq))
                         (goods_quantity 0)(goods_type NA)
                         (f_cost (+ (* ?km (- ?rgq ?gq)) ?km))
                         (h_cost (* ?km (- ?rgq ?gq)))(g_cost ?km)
  )
)

(defrule expand-truck-quantity-neg ; La differenza é negativa
  (next_truck(id_truck ?id_trans))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type Truck)
             (type_route Ground)(goods_quantity ?gq)(goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type))

  ?stateplanning<-(state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (goods_quantity ?goodsq)(goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (route
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground))
  (test (< (+ (* ?km (- ?rgq ?gq)) ?km) ?fcostplanning))
  (test (< ?rgq ?gq))
=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?arrival)
                         (requested_goods_quantity 0)
                         (goods_quantity (- ?gq ?rgq))(goods_type ?good_type)
                         (f_cost (+ (* ?km (- ?rgq ?gq)) ?km))
                         (h_cost (* ?km (- ?rgq ?gq)))(g_cost ?km)
  )
)
;Caso in cui le merci trasportate sul truck sono di tipologia differente da quelle richieste nella città
(defrule expand-truck-different-type-goods
  (next_truck(id_truck ?id_trans))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type Truck)
             (type_route Ground)(goods_quantity ?gq)(goods_type ?trans_goods_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq )
        (requested_goods_type ?city_req_goods_type))

  ;Informazioni temporanee da salvare in state
  ?stateplanning<-(state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (goods_quantity ?goodsq)(goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (route
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground))
  (test (neq ?city_req_goods_type ?trans_goods_type))
  (test (< (* 20 ?km) ?fcostplanning)) ; uso un moltiplicatore alto (20) perchè questa scelta risulti peggiore di ogni altra scelta in cui posso scaricare merci
=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (goods_quantity ?gq)(goods_type ?trans_goods_type)
                         (f_cost (+ (* 20 ?km) ?km))
                         (h_cost (* 20 ?km))
                         (g_cost ?km)
  )
)
;Modulo dedito a mantenere la persistenza delle informazioni dopo la decisione di muovere un trasporto (eventuale scarico/carico merci in città)
(defmodule UPDATESTATE (import MAINEXPANDTRUCK ?ALL) (export ?ALL))

(defrule update-state-cargo-not-empty
  ?state_planning <- (state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                    (requested_goods_quantity ?req_quantity)
                                    (goods_quantity ?goodsq)(goods_type ?goodst)
                                    (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                    (g_cost ?gcostplanning))
  (current (id_current ?id_current))
  ?new_state <- (state(id_state ?id_current)(g_cost ?old_g_cost))
  ?transport <- (transport(id_state ?id_current)(id_transport ?id_t))
  ?city <- (city(id_state ?id_current)(id_city ?id_city_arrival))
  (test (> ?goodsq 0)) ;caso in cui il furgone non è stato completamente svuotato (manteniamo la quantità e il tipo di merce precedente)
=>
  (modify ?new_state(g_cost (+ ?old_g_cost ?gcostplanning)))
  (modify ?transport(goods_quantity ?goodsq)(goods_type ?goodst)(city ?id_city_arrival))
  (modify ?city(requested_goods_quantity ?req_quantity))
)

(defrule update-state-cargo-empty-city-full
  ?state_planning <- (state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                    (requested_goods_quantity ?req_quantity)
                                    (goods_quantity ?goodsq)(goods_type ?goodst)
                                    (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                    (g_cost ?gcostplanning))
  (current (id_current ?id_current))
  ?new_state <- (state(id_state ?id_current)(g_cost ?old_g_cost))
  ?transport <- (transport(id_state ?id_current)(id_transport ?id_t)(capacity ?capacity))
  ?city <- (city(id_state ?id_current)(id_city ?id_city_arrival)(provided_goods_type ?prov_goods_type)
                (provided_goods_quantity ?prov_goods_q))
  (test (= ?goodsq 0)) ;caso in cui il furgone è vuoto e la città ha merci con cui caricarlo
  (test (>= ?prov_goods_q ?capacity))
=>
  (modify ?new_state(g_cost (+ ?old_g_cost ?gcostplanning)))
  (modify ?transport(goods_quantity ?capacity)(goods_type ?prov_goods_type)(city ?id_city_arrival))
  (modify ?city(requested_goods_quantity ?req_quantity)
               (provided_goods_quantity (- ?prov_goods_q ?capacity)))
)

(defrule update-state-cargo-empty-city-with-some-goods
  ?state_planning <- (state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                    (requested_goods_quantity ?req_quantity)
                                    (goods_quantity ?goodsq)(goods_type ?goodst)
                                    (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                    (g_cost ?gcostplanning))
  (current (id_current ?id_current))
  ?new_state <- (state(id_state ?id_current)(g_cost ?old_g_cost))
  ?transport <- (transport(id_state ?id_current)(id_transport ?id_t)(capacity ?capacity))
  ?city <- (city(id_state ?id_current)(id_city ?id_city_arrival)
                (provided_goods_type ?prov_goods_type)(provided_goods_quantity ?prov_goods_q))
  (test (or (= ?goodsq 0)(< ?prov_goods_q ?capacity))) ;caso in cui il furgone è vuoto e la città ha 0 o alcune merci con cui caricarlo (furgone non caricato a pieno)
=>
  (modify ?new_state(g_cost (+ ?old_g_cost ?gcostplanning)))
  (modify ?transport(goods_quantity ?prov_goods_q)(goods_type ?prov_goods_type)(city ?id_city_arrival))
  (modify ?city(requested_goods_quantity ?req_quantity)(provided_goods_quantity 0))
)

(defmodule NEXTTRUCK (import EXPANDTRUCK ?ALL) (export ?ALL))

(defrule exp-next-truck
  ?t <- (next_truck(id_truck ?id_truck))
  ?sp <- (state_planning(id_transport ?id_truck))
  (test (< ?id_truck 5))
=>
  (modify ?t (id_truck (+ ?id_truck 1)))
  (retract ?sp)
  (pop-focus)
)

(defrule exp-next-truck-end
  ?t <- (next_truck(id_truck ?id_truck))
  ?sp <- (state_planning(id_transport ?id_truck))
  (test (= ?id_truck 5))
=>
  (retract ?t)
  (retract ?sp)
  (pop-focus)
  (pop-focus)
)

(defmodule CHECKGOAL (import EXPAND ?ALL) (export ?ALL))

(defrule check_goal
  (city (id_city Torino) (requested_goods_quantity 0)(requested_goods_type NA))
  (city (id_city Milano) (requested_goods_quantity 0)(requested_goods_type NA))
  (city (id_city Bologna)(requested_goods_quantity 0)(requested_goods_type NA))
  (city (id_city Genova) (requested_goods_quantity 0)(requested_goods_type NA))
  (city (id_city Venezia)(requested_goods_quantity 0)(requested_goods_type NA))
  (city (id_city Firenze)(requested_goods_quantity 0)(requested_goods_type NA))
=>
  (assert (stampa 0))
  (pop-focus)
  (pop-focus)
)
