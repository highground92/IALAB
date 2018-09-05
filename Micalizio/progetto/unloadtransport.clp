(defmodule UNLOAD (import LOAD ?ALL)(export ?ALL))

; Ho il mezzo scarico e la città mi può rifornire per tutta la mia capacità
(defrule unload-transport-pos (declare (salience 100))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?id_city)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (test(> ?tgq 0))
  (test(> ?rgq 0))
  (test(> ?rgq ?tgq))
  (test (< (* (- 12 ?tgq) 10) ?fcostplanning))
=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?id_city)
                         (requested_goods_quantity (- ?rgq ?tgq))
                         (requested_goods_type ?good_type)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity 0)(trans_goods_type NA)
                         (f_cost (* (- 12 ?tgq) 10))
                         (h_cost (* (- 12 ?tgq) 10))(g_cost 0)
  )
  (assert (action(type unload)))
  (focus UPDATESTATE)
)

; Ho il mezzo scarico e la città mi può rifornire con beni <= alla capacità del mezzo
(defrule unload-transport-neg (declare (salience 100))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?id_city)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (test(> ?tgq 0))
  (test(> ?rgq 0))
  (test(< ?rgq ?tgq))
  (test (< (* (- 12 ?tgq) 10) ?fcostplanning))

=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?id_city)
                         (requested_goods_quantity 0)
                         (requested_goods_type NA)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity (- ?tgq ?rgq))(trans_goods_type ?good_type)
                         (f_cost (* (- 12 ?tgq) 10))
                         (h_cost (* (- 12 ?tgq) 10))(g_cost 0)
  )
  (assert (action(type unload)))
  (focus UPDATESTATE)
)
(defrule unload-transport-eq (declare (salience 100))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?id_city)(requested_goods_quantity ?rgq )
        (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(id_city ?id_city_arrival)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (test(> ?tgq 0))
  (test(> ?rgq 0))
  (test(= ?rgq ?tgq))
  (test (< (* (- 12 ?tgq) 10) ?fcostplanning))

=>
  (modify ?stateplanning (id_transport ?id_trans)(id_city ?id_city)
                         (requested_goods_quantity 0)
                         (requested_goods_type NA)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity 0)(trans_goods_type NA)
                         (f_cost (* (- 12 ?tgq) 10))
                         (h_cost (* (- 12 ?tgq) 10))(g_cost 0)
  )
  (assert (action(type unload)))
  (focus UPDATESTATE)
)

; Trasporto carico ma tipo di merce diverso da quella richiesta
(defrule unload-transport-no-possible (declare (salience 90))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?tgt)(city ?id_city))
  (city (id_state ?id_state)(id_city ?id_city)(requested_goods_quantity ?rgq )
        (requested_goods_type ?rgt)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (test (> ?tgq 0))
  (test (neq ?rgt ?tgt))
=>
  (assert (action(type unload)))
  (focus MOVE)
)
