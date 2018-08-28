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
