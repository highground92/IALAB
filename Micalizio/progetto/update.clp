;Modulo dedito a mantenere la persistenza delle informazioni dopo aver preso una decisione per un trasporto (carico/scarico/movimento)
(defmodule UPDATESTATE (import LOAD ?ALL)(import UNLOAD ?ALL)(import MOVE ?ALL) (export ?ALL))

(defrule update-state-1 (declare (salience 101))
  (current (id_current 1))
  ?new_state <- (state(id_state 1)(total_distance ?old_total_distance)(total_cost ?old_total_cost)(weight ?old_weight))
  ?trans<-(transport (id_state 1)(id_transport ?id_trans)(transport_type ?tt)
                     (capacity ?capacity)(type_route ?tr)(trans_goods_quantity ?tgq)
                     (trans_goods_type ?tgt)(city ?id_city_t))

  ?city<-(city (id_state 1)(id_city ?id_city)(requested_goods_quantity ?rgq)
               (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (total_cost ?fcostplanning)(weight ?hcostplanning)
                                 (total_distance ?totaldistanceplanning)
                  )
=>
  (modify ?new_state (total_cost ?fcostplanning)(weight ?hcostplanning)
                     (total_distance ?totaldistanceplanning))

  (modify ?trans (id_state 1)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
                 (type_route ?tr) (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)(city ?id_city))

  (modify ?city (id_state 1)(id_city ?id_city)(requested_goods_quantity ?req_quantity)
                (requested_goods_type ?req_type)(provided_goods_quantity ?prov_quantity)
                (provided_goods_type ?prov_type))

  (retract ?stateplanning)

  (focus NEXTTRANSPORT)
)

(defrule update-state (declare (salience 100))
  (current (id_current ?current))
  ?new_state <- (state(id_state ?current)(total_distance ?old_total_distance)(total_cost ?old_total_cost)(weight ?old_weight))
  ?trans<-(transport (id_state ?current)(id_transport ?id_trans)(transport_type ?tt)
                     (capacity ?capacity)(type_route ?tr)(trans_goods_quantity ?tgq)
                     (trans_goods_type ?tgt)(city ?id_city_t))

  ?city<-(city (id_state ?current)(id_city ?id_city)(requested_goods_quantity ?rgq)
               (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (total_cost ?fcostplanning)(weight ?hcostplanning)
                                 (total_distance ?totaldistanceplanning)
                  )
=>
  (modify ?new_state (total_cost (+ ?old_total_cost ?fcostplanning))(weight (+ ?old_weight ?hcostplanning))
                     (total_distance (+ ?old_total_distance ?totaldistanceplanning)))

  (modify ?trans (id_state ?current)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
                 (type_route ?tr) (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)(city ?id_city))

  (modify ?city (id_state ?current)(id_city ?id_city)(requested_goods_quantity ?req_quantity)
                (requested_goods_type ?req_type)(provided_goods_quantity ?prov_quantity)
                (provided_goods_type ?prov_type))

  (retract ?stateplanning)

  (focus NEXTTRANSPORT)
)
