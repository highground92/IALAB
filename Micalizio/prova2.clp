(deftemplate state (slot id_state)(slot f_cost)(slot h_cost)(slot g_cost)
                  (multislot transport_type)(multislot type_route)
                  (multislot capacity)(multislot goods_quantity))





(deftemplate transport (slot id_transport)(slot transport_type)(slot type_route)
                       (slot capacity)(slot goods_quantity)(slot goods_type))

(deftemplate city (slot id_city)(slot requested_goods_quantity)(slot requested_goods_type)
                  (slot provided_goods_quantity)(slot provided_goods_type))

(deftemplate in (slot id_in)(slot id_state)(slot id_transport)(slot id_city))

(deffacts domain
  (state
    (id_state 0)(f_cost 999)(h_cost 999)(g_cost 0)(id_transport 1)
    (transport_type Truck)(type_route Ground)(capacity 4)(goods_quantity 0)
    (goods_type NA)(id_in 0)(id_state 0)(id_transport 1)(id_city Torino)
    (id_city Torino)(requested_goods_quantity 10)(requested_goods_type A)
    ( provided_goods_quantity 5)(provided_goods_type B)

)

(defrule start
 (state (id_state ?id))
 (test(< ?id 2))
=>
  (assert state(id_state (+ ?id 1)))

)
