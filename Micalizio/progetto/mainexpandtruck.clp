(defmodule MAINEXPANDTRUCK (import EXPAND ?ALL) (export ?ALL))

(defrule find_new_truck_state (declare (salience 100))
  (next_truck(id_truck ?id_truck))
  ;?sp<-(state_planning(id_transport ?id_truck))
=>
  (assert (state_planning(id_transport ?id_truck)(f_cost 999999)(h_cost 9999999)(g_cost 9999999))) ; stubby che verrà rimpiazzato subito
  (focus EXPANDTRUCK) ;valuto tutte le possibili azioni per un truck e scelgo la migliore
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

(defmodule EXPANDTRUCK (import MAINEXPANDTRUCK ?ALL) (export ?ALL))

;Caso in cui il furgone è vuoto e valuta di andare in una città che può fornire merci
(defrule expand-truck-empty-cargo-city-with-goods (declare (salience 100))
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
(defrule expand-truck-empty-cargo-city-with-no-goods (declare (salience 100))
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
(defrule expand-truck-quantity-pos (declare (salience 100))
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

(defrule expand-truck-quantity-neg (declare (salience 100)) ; La differenza é negativa
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
(defrule expand-truck-different-type-goods (declare (salience 100))
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

(defrule go-to-update (declare (salience 10))

=>
  (focus UPDATESTATE)
)

(defmodule NEXTTRUCK (import MAINEXPANDTRUCK ?ALL) (export ?ALL))

(defrule exp-next-truck
  ?t <- (next_truck(id_truck ?id_truck))
  ?sp <- (state_planning(id_transport ?id_truck))
  (test (< ?id_truck 5))
=>
  (modify ?t (id_truck (+ ?id_truck 1)))
  (retract ?sp)
  (pop-focus)
  (pop-focus)
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
  (pop-focus)
  (pop-focus)
)
