(defmodule MOVE (import LOAD ?ALL)(import UNLOAD ?ALL) (export ?ALL))

; Non ho trovato nessuna destinazione quindi rimango fermo
(defrule no-move (declare(salience 106))
?f1<- (new-destination (id_city ?id_city)(distance 9999999))

  (current (id_current ?id_state))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
           (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?tgt)(city ?id_city))
  (city (id_state ?id_state)(id_city ?id_city)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city_planning)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
?f2<- (no-a-star)
(test (= ?tgq 0))

=>
  (modify ?stateplanning (id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city)
                         (requested_goods_quantity ?rgq)
                         (requested_goods_type ?rgt)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity ?tgq)(trans_goods_type ?tgt)
                         (f_cost 0)
                         (h_cost 0)(g_cost 0)
  )
  (retract ?f1)
  (retract ?f2)
  (assert (action(type move)))
  (focus UPDATESTATE)
)

; Applico A* per cercare il percorso più breve per la nuova destinazione
(defrule move-find-path-full (declare(salience 105))
  (new-destination (id_city ?id_city)(distance ?distance))
=>
  (focus ASTAR)
)

; A* ha trovato la città migliore in cui muoversi
(defrule a-star-applied (declare(salience 101))
  ?f1<-(move_to_city ?id ?hcost)
  (current (id_current ?id_state))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
           (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?tgt)(city ?id_city))
  (city (id_state ?id_state)(id_city ?id)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route(departure ?id_city)(arrival ?id)(km ?km)(type_route ?tr))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city_planning)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
=>
  (modify ?stateplanning (id_transport ?id_trans)(transport_type ?tt)(id_city ?id)
                         (requested_goods_quantity ?rgq)
                         (requested_goods_type ?rgt)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity ?tgq)(trans_goods_type ?tgt)
                         (f_cost (+ ?hcost ?km))
                         (h_cost ?hcost)(g_cost ?km)
  )
  (retract ?f1)
  (assert (action(type move)))
  (focus UPDATESTATE)
)

; Mezzo vuoto e c'è una città adiacente che lo può completamente rifornire
(defrule move-empty-cargo-full (declare (salience 100))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity 0)(trans_goods_type NA)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route(departure ?id_city)(arrival ?arrival)(km ?km)(type_route ?tr))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city_planning)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (test(> ?pgq 0))
  (test(>= ?pgq ?capacity))
  (test(< (+ (/ ?km ?pgq) ?km) ?fcostplanning))
=>
  (modify ?stateplanning (id_transport ?id_trans)(transport_type ?tt)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (requested_goods_type ?rgt)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity 0)(trans_goods_type NA)
                         (f_cost (+ (/ ?km ?pgq) ?km))
                         (h_cost (/ ?km ?pgq))(g_cost ?km)
  )
  (assert (no-a-star))
)

; Il mezzo è carico e c'è una città adiacente che può completamente rifornire
(defrule move-full-cargo-pos (declare (salience 100))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?good_type)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route(departure ?id_city)(arrival ?arrival)(km ?km)(type_route ?tr))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city_planning)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                  )
  (test(> ?rgq 0))
  (test(> ?tgq 0))
  (test(>= ?tgq ?rgq))
  (test(neq ?tr NA))
  (test(< (+ (/ ?km ?rgq) ?km) ?fcostplanning))

=>
  (modify ?stateplanning (id_transport ?id_trans)(transport_type ?tt)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (requested_goods_type ?good_type)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity ?tgq)(trans_goods_type ?good_type)
                         (f_cost (+ (/ ?km ?tgq) ?km))
                         (h_cost (/ ?km ?tgq))(g_cost ?km)
  )

  (assert (no-a-star))

)

; Mezzo vuoto e c'è una città adiacente che lo può rifornire non completamente
(defrule move-empty-cargo-some (declare (salience 90))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity 0)(trans_goods_type NA)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route(departure ?id_city)(arrival ?arrival)(km ?km)(type_route ?tr))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city_planning)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                   )
  (test(> ?pgq 0))
  (test(< ?pgq ?capacity))
  (test(< (+ (/ ?km ?pgq) ?km) ?fcostplanning))
=>
  (modify ?stateplanning (id_transport ?id_trans)(transport_type ?tt)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (requested_goods_type ?rgt)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity 0)(trans_goods_type NA)
                         (f_cost (+ (/ ?km ?pgq) ?km))
                         (h_cost (/ ?km ?pgq))(g_cost ?km)
  )
  (assert (no-a-star))
)

; Il mezzo è carico e c'è una città adiacente che può parzialmente rifornire
(defrule move-full-cargo-neg (declare (salience 90))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?good_type)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?good_type)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route(departure ?id_city)(arrival ?arrival)(km ?km)(type_route ?tr))

  ?stateplanning<-(state_planning(id_transport ?id_trans)(transport_type ?tt)(id_city ?id_city_planning)
                                 (requested_goods_quantity ?req_quantity)
                                 (requested_goods_type ?req_type)
                                 (provided_goods_quantity ?prov_quantity)
                                 (provided_goods_type ?prov_type)
                                 (trans_goods_quantity ?goodsq)(trans_goods_type ?goodst)
                                 (f_cost ?fcostplanning)(h_cost ?hcostplanning)
                                 (g_cost ?gcostplanning)
                   )

  (test(> ?rgq 0))
  (test(> ?tgq 0))
  (test(< ?tgq ?rgq))
  (test(neq ?tr NA))
  (test(< (+ (/ ?km ?tgq) ?km) ?fcostplanning))
=>
  (modify ?stateplanning (id_transport ?id_trans)(transport_type ?tt)(id_city ?arrival)
                         (requested_goods_quantity ?rgq)
                         (requested_goods_type ?good_type)
                         (provided_goods_quantity ?pgq)
                         (provided_goods_type ?pgt)
                         (trans_goods_quantity ?tgq)(trans_goods_type ?good_type)
                         (f_cost (+ (/ ?km ?tgq) ?km))
                         (h_cost (/ ?km ?tgq))(g_cost ?km)
  )
  (assert (no-a-star))
)

; Non ho nessuna città adiacente che soddisfa i requisiti, quindi applico A*
(defrule move-cargo-a-star (declare (salience 80))
  (not (no-a-star))
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(f_cost ?f_cost)(h_cost ?h_cost)(g_cost ?g_cost))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?tgt)(city ?id_city))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route(departure ?id_city)(arrival ?arrival)(km ?km)(type_route ?tr))

=>
  (assert (new-destination (id_city ?id_city)(distance 9999999)))
  (assert (no-a-star))
  (focus NEWDESTINATION)
)

; Ho scelto che movimento fare applicando una scelta greedy
(defrule move-chosen (declare(salience 5))
  (next_trans(id_trans ?id)(type_trans ?tt))
  ?f1<-(no-a-star)
=>
  (assert (action(type move)))
  (retract ?f1)
  (focus UPDATESTATE)
)
