;Modulo dedito a mantenere la persistenza delle informazioni dopo la decisione di muovere un trasporto (eventuale scarico/carico merci in città)
(defmodule UPDATESTATE (import LOAD ?ALL)(import UNLOAD ?ALL)(import MOVE ?ALL) (export ?ALL))

(defrule update-state (declare(salience 10))
  (current (id_current ?current))
  ?new_state <- (state(id_state ?current)(g_cost ?old_g_cost)(f_cost ?old_f_cost)(h_cost ?old_h_cost))
  ?trans<-(transport (id_state ?current)(id_transport ?id_trans)(transport_type ?tt)
                     (capacity ?capacity)(type_route ?tr)(trans_goods_quantity ?tgq)
                     (trans_goods_type ?tgt)(city ?id_city_t))

  ?city<-(city (id_state ?current)(id_city ?id_city)(requested_goods_quantity ?rgq)
               (requested_goods_type ?good_type)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(id_city ?id_city)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
=>
  (modify ?new_state (f_cost (+ ?old_f_cost ?fcostplanning))(h_cost (+ ?old_h_cost ?hcostplanning))
                     (g_cost (+ ?old_g_cost ?gcostplanning)))

  (modify ?trans (id_state ?current)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
                 (type_route ?tr) (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)(city ?id_city))

  (modify ?city (id_state ?current)(id_city ?id_city)(requested_goods_quantity ?req_quantity)
                (requested_goods_type ?req_type)(provided_goods_quantity ?prov_quantity)
                (provided_goods_type ?prov_type))

  (retract ?stateplanning)
  (printout t "In update " crlf)

  (focus NEXTTRANSPORT)
)
