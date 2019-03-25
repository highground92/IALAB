(defmodule NEWDESTINATION (import MOVE ?ALL)(export ?ALL))

; Cerco la città migliore in cui scaricare
(defrule find-new-destination-unload
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(total_cost ?total_cost)(weight ?weight)(total_distance ?total_distance))
  (route (departure ?departure) (arrival ?arrival) (km ?km))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity ?tgq)(trans_goods_type ?tgt)(city ?departure)(route_id ?id_route))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt)(route_id $?before ?id_route $?after))

  ?dest<- (new-destination (id_city ?id_city_destination)(distance ?distance))

  (test (> ?tgq 0))
  (test (eq ?tgt ?rgt))
  (test (< ?km ?distance))
=>
 (modify ?dest (id_city ?arrival)(distance ?km))
)

; Cerco la città migliore in cui caricare
(defrule find-new-destination-load
  (next_trans(id_trans ?id_trans)(type_trans ?tt))
  (current (id_current ?id_state))
  (state(id_state ?id_state)(total_cost ?total_cost)(weight ?weight)(total_distance ?total_distance))
  (route (departure ?departure) (arrival ?arrival) (km ?km) (type_route NA))
  (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(capacity ?capacity)
             (type_route ?tr)(trans_goods_quantity 0)(trans_goods_type NA)(city ?departure)(route_id ?id_route))
  (city (id_state ?id_state)(id_city ?arrival)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
        (provided_goods_quantity ?pgq)(provided_goods_type ?pgt)(route_id $?before ?id_route $?after))

  ?dest<- (new-destination (id_city ?id_city_destination)(distance ?distance))

  (test (< ?km ?distance))
  (test (> ?pgq 0))
=>
 (modify ?dest (id_city ?arrival)(distance ?km))
)
