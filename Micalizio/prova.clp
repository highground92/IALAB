(defmodule MAIN (export ?ALL))

(deftemplate state (slot id_state)(slot f_cost)(slot h_cost)(slot g_cost)(slot father))

(deftemplate in (slot id_state)(slot id_in)(slot id_state)(slot id_transport)(slot id_city))

(deftemplate city (slot id_state)(slot id_city)(slot requested_goods_quantity)(slot requested_goods_type)
                  (slot provided_goods_quantity)(slot provided_goods_type))

(deftemplate transport (slot id_state)(slot id_transport)(slot transport_type)(slot type_route) ;Per il momento si assume un solo tipo di merci trasportato
                       (slot capacity)(slot goods_quantity)(slot goods_type))

(deftemplate route (slot departure)(slot arrival)(slot km)(slot type_route))

(deftemplate move_to (slot id_transport)(slot departure)(slot arrival)(slot km))

(deftemplate current (slot id_current) (slot g_cost))

(deftemplate next_truck(slot id_truck))

(deftemplate state_planning(slot id_transport)(slot id_city ) (slot requested_goods_quantity)
                               (slot goods_quantity)(slot goods_type))

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
  ;(state (id_state 0)(f_cost 999)(h_cost 999)(g_cost 0))
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

  (in (id_in 0)(id_state 0)(id_transport 1)(id_city Torino))
  (in (id_in 0)(id_state 0)(id_transport 2)(id_city Milano))
  (in (id_in 0)(id_state 0)(id_transport 3)(id_city Bologna))
  (in (id_in 0)(id_state 0)(id_transport 4)(id_city Genova))
  (in (id_in 0)(id_state 0)(id_transport 5)(id_city Venezia))

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
  (state ())
  (in())
  (route())
=>


  (assert(state ?id)) ; Serve per la stampa finale
  (focus EXPANDSHIP)

)

(defrule stampa-soluzione (declare (salience 50)) ; Faccio le stampe(al contrario) del percorso
  ?id_stampa<-(stampa ?id)
  (combinazione (id ?id) (padre ?father&~NA) (furgone1_partenza ?f1p)
                (furgone1_arrivo ?f1a) (furgone2_partenza ?f2p) (furgone2_arrivo ?f2a)
                (costo ?costo))
=>
  (printout t "Il passaggio è " ?f1p "-" ?f1a ", " ?f2p "-" ?f2a ", " ?costo crlf)
  (assert (stampa ?father))
  (retract ?id_stampa)
)

(defrule stampa-fine (declare (salience 51))
  (stampa ?id)
  (initial_id ?id)
=>
  (printout t "FINE" crlf)
  (halt)
)
;;;;;;;;;;;;;;;;;;;;
(defmodule EXPAND (import MAIN ?ALL) (export ?ALL))
(defrule find_new_state
  ;a) asserire state_planning facendo la copia di state
(current (id_state ?id_current_state))
(state (id_state ?id_current_state))
(transport (id_state ?id_current_state)(id_transport ?id_trans1)(transport_type Truck)(type_route Ground)
   (capacity 4)(goods_quantity ?quantity1)(goods_type ?g_type1)(city ?trans_city1))
(transport (id_state ?id_current_state)(id_transport ?id_trans2)(transport_type Truck)(type_route Ground)
   (capacity 4)(goods_quantity ?quantity2)(goods_type ?g_type2)(city ?trans_city2))
(transport (id_state ?id_current_state)(id_transport ?id_trans3)(transport_type Truck)(type_route Ground)
   (capacity 4)(goods_quantity ?quantity3)(goods_type ?g_type3)(city ?trans_city3))
(transport (id_state ?id_current_state)(id_transport ?id_trans4)(transport_type Truck)(type_route Ground)
   (capacity 4)(goods_quantity ?quantity4)(goods_type ?g_type4)(city ?trans_city4))
(transport (id_state ?id_current_state)(id_transport ?id_trans5)(transport_type Truck)(type_route Ground)
   (capacity 4)(goods_quantity ?quantity5)(goods_type ?g_type5)(city ?trans_city5))

(city (id_state ?id_current_state)(id_city ?city1)(requested_goods_quantity ?requested_q1)(requested_goods_type ?requested_t1)
      ( provided_goods_quantity ?provided_g1)(provided_goods_type ?provided_t1))
(city (id_state ?id_current_state)(id_city ?city2)(requested_goods_quantity ?requested_q2)(requested_goods_type ?requested_t2)
      ( provided_goods_quantity ?provided_g2)(provided_goods_type ?provided_t2))
(city (id_state ?id_current_state)(id_city ?city3)(requested_goods_quantity ?requested_q3)(requested_goods_type ?requested_t3)
      ( provided_goods_quantity ?provided_g3)(provided_goods_type ?provided_t3))
(city (id_state ?id_current_state)(id_city ?city4)(requested_goods_quantity ?requested_q4)(requested_goods_type ?requested_t4)
      ( provided_goods_quantity ?provided_g4)(provided_goods_type ?provided_t4))
(city (id_state ?id_current_state)(id_city ?city5)(requested_goods_quantity ?requested_q5)(requested_goods_type ?requested_t5)
      ( provided_goods_quantity ?provided_g5)(provided_goods_type ?provided_t5))
(city (id_state ?id_current_state)(id_city ?city6)(requested_goods_quantity ?requested_q6)(requested_goods_type ?requested_t6)
      ( provided_goods_quantity ?provided_g6)(provided_goods_type ?provided_t6))

=>
  (assert(state (id_state (+ ?id_current_state 1)))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans1)(transport_type Truck)(type_route Ground)
       (capacity 4)(goods_quantity ?quantity1)(goods_type ?g_type1)(city ?trans_city1))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans2)(transport_type Truck)(type_route Ground)
       (capacity 4)(goods_quantity ?quantity2)(goods_type ?g_type2)(city ?trans_city2))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans3)(transport_type Truck)(type_route Ground)
       (capacity 4)(goods_quantity ?quantity3)(goods_type ?g_type3)(city ?trans_city3))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans4)(transport_type Truck)(type_route Ground)
       (capacity 4)(goods_quantity ?quantity4)(goods_type ?g_type4)(city ?trans_city4))
    (transport (id_state (+ ?id_current_state 1))(id_transport ?id_trans5)(transport_type Truck)(type_route Ground)
       (capacity 4)(goods_quantity ?quantity5)(goods_type ?g_type5)(city ?trans_city5))

    (city (id_state (+ ?id_current_state 1))(id_city ?city1)(requested_goods_quantity ?requested_q1)(requested_goods_type ?requested_t1)
          ( provided_goods_quantity ?provided_g1)(provided_goods_type ?provided_t1))
    (city (id_state (+ ?id_current_state 1))(id_city ?city2)(requested_goods_quantity ?requested_q2)(requested_goods_type ?requested_t2)
          ( provided_goods_quantity ?provided_g2)(provided_goods_type ?provided_t2))
    (city (id_state (+ ?id_current_state 1))(id_city ?city3)(requested_goods_quantity ?requested_q3)(requested_goods_type ?requested_t3)
          ( provided_goods_quantity ?provided_g3)(provided_goods_type ?provided_t3))
    (city (id_state (+ ?id_current_state 1))(id_city ?city4)(requested_goods_quantity ?requested_q4)(requested_goods_type ?requested_t4)
          ( provided_goods_quantity ?provided_g4)(provided_goods_type ?provided_t4))
    (city (id_state (+ ?id_current_state 1))(id_city ?city5)(requested_goods_quantity ?requested_q5)(requested_goods_type ?requested_t5)
          ( provided_goods_quantity ?provided_g5)(provided_goods_type ?provided_t5))
    (city (id_state (+ ?id_current_state 1))(id_city ?city6)(requested_goods_quantity ?requested_q6)(requested_goods_type ?requested_t6)
          ( provided_goods_quantity ?provided_g6)(provided_goods_type ?provided_t6))
    )

  ;(focus EXPANDSHIP)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning
  (assert next_truck(1))
  (focus MAINEXPANDTRUCK)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning
  ;(focus EXPANDPLANE)
  ;b) creazione stato aggiornato
  ;c) retract di tutti gli state_planning

)

(defmodule MAINEXPANDTRUCK (import EXPAND ?ALL) (export ?ALL))
(defrule find_new_truck_state
(next_truck(?id_truck))
=>
(focus EXPANDTRUCK)
(focus UPDATESTATE)
(focus NEXTTRUCK)
)

(defmodule EXPANDTRUCK (import EXPAND ?ALL) (export ?ALL))

; Controllo se la differenza della quantitá tra merce richiesta della cittá e quella scaricata dal furgone é positiva
(defrule expand_truck_quantity_pos
  (next_truck(?id_trans))
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
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground)
  )
  (test (< (+ (* ?km (- ?rgq ?gq)) ?km) ?fcostplanning)) ; calcolo dell'euristica
  (test (>= ?rgq ?gq))
=>
  ;(f_cost (+ (* ?km (- ?rgq ?gq1)) ?km))
  ;(h_cost (* ?km (- ?rgq ?gq1)))
  ;(g_cost ?km)
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?arrival)
                         (requested_goods_quantity (- ?rgq ?gq))
                         (goods_quantity 0)(goods_type NA)
                         (f_cost (+ (* ?km (- ?rgq ?gq1)) ?km))
                         (h_cost (* ?km (- ?rgq ?gq1)))(g_cost ?km)
  )
)

(defrule expand_truck_quantity_neg ; La differenza é negativa
  (next_truck(?id_trans))
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
    (departure ?id_city)(arrival ?arrival)(km ?km)(type_route Ground)
  )
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

(defmodule UPDATESTATE (import MAINEXPANDTRUCK ?ALL) (export ?ALL))
(defrule update-state-cargo>0
?state_planning <- (state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                  (requested_goods_quantity ?req_quantity)
                                  (goods_quantity ?goodsq)(goods_type ?goodst)
                                  (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                  (g_cost ?gcostplanning))
(current (id_current ?id_current))
?new_state <- (state(id_state (+ ?id_current 1)(g_cost ?old_g_cost)))
?transport <- (transport(id_state (+ ?id_current 1))(id_transport ?id_t))
?city <- (city(id_state(+ ?id_current 1))(id_city ?id_city_arrival))
(test (> ?goodsq 0)) ;caso in cui il furgone non è stato completamente svuotato (manteniamo la quantità e il tipo di merce precedente)
=>
(modify ?new_state(g_cost (+ ?old_g_cost ?gcostplanning)))
(modify ?transport(goods_quantity ?goodsq)(goods_type ?goodst)(city ?id_city_arrival))
(modify ?city(requested_goods_quantity ?req_quantity))
)

(defrule update-state-cargo=0
?state_planning <- (state_planning(id_transport ?id_t)(id_city ?id_city_arrival)
                                  (requested_goods_quantity ?req_quantity)
                                  (goods_quantity ?goodsq)(goods_type ?goodst)
                                  (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                  (g_cost ?gcostplanning))
(current (id_current ?id_current))
?new_state <- (state(id_state (+ ?id_current 1)(g_cost ?old_g_cost)))
?transport <- (transport(id_state (+ ?id_current 1))(id_transport ?id_t)(capacity ?capacity))
?city <- (city(id_state(+ ?id_current 1))(id_city ?id_city_arrival)(provided_goods_type ?prov_goods_type)(provided_goods_quantity ?prov_goods_q))
(test (= ?goodsq 0)) ;caso in cui il furgone è vuoto e la città ha merci con cui caricarlo
(test (>= ?prov_goods_q ?capacity))
=>
(modify ?new_state(g_cost (+ ?old_g_cost ?gcostplanning)))
(modify ?transport(goods_quantity ?capacity)(goods_type ?prov_goods_type)(city ?id_city_arrival))
(modify ?city(requested_goods_quantity ?req_quantity)(provided_goods_quantity (- ?prov_goods_q ?capacity)))
)

(defmodule NEXTTRUCK (import EXPANDTRUCK ?ALL) (export ?ALL))

(defrule exp_next_truck
?t <- (next_truck(?id_truck))
(test (< ?id_truck 5))
=>
(modify ?t (id_truck (+ ?id_truck 1)))
(pop-focus)
)

(defrule exp_next_truck_end
?t <- (next_truck(?id_truck))
(test (= ?id_truck 5))
=>
(retract ?t)
(pop-focus)
(pop-focus)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule SELECT (import EXPAND ?ALL) (export ?ALL))

(defrule selezione (declare (salience 50))
  (combinazione (costo ?cost) (id ?id) (furgone1_arrivo ?f1arr)
                (furgone2_arrivo ?f2arr))
  ?furg1<-(furgone (id 1) (posizione ?pos1)) ; TODo Da generalizzare gli id(?)
  ?furg2<-(furgone (id 2) (posizione ?pos2))

  ?current<-(current (id_current ?id_current)(g_cost ?gcost))
  (test (> ?cost ?gcost))
=>
  (modify ?furg1 (posizione ?f1arr))
  (modify ?furg2 (posizione ?f2arr))
  (modify ?current (id_current ?id) (g_cost ?cost))
)

(defrule retract_old_spostamenti (declare (salience 30))
  ?r<-(spostamento)
  =>
  (retract ?r)
)

(defrule isgoal (declare (salience 20)) ; controllo se il costo ha superato 100, in quel caso ho raggiunto il goal
  ?comb<-(combinazione (id ?id) (costo ?cost))
  (test (> ?cost 100))
=>
    (printout t "GOAL RAGGIUNTO" crlf)
    (assert (stampa ?id))
    (pop-focus)
    (pop-focus)
)

(defrule pop (declare (salience 10)) ; Ritorno a EXPAND
  =>
  (printout t "situazione stack selezione: " (list-focus-stack) crlf)
  (pop-focus)

)
