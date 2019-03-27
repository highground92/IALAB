(defmodule PLANNING (import MAIN ?ALL)(export ?ALL))

(defrule main-search-route
  (city (id_city ?id_city)(requested_goods_quantity ?rgq)(requested_goods_type ?rgt))
=>
  (assert (city_goods_planning(id_cgp ?id_city)(num 0)(city_departure ?id_city)
                              (requested_goods_quantity ?rgq)(requested_goods_type ?rgt)
                              (f_cost 99999)(h_cost 99999)(g_cost 0)))
  (focus TEMP)
)

(defmodule TEMP (import PLANNING ?ALL)(export ?ALL))
(defrule tmp

=>

  (focus RECURSION)
)
(defrule stampa (declare(salience 100))
  ?l<-(lastcity (id_last ?last))
  (city_goods_planning(id_cgp ?id_city)(num ?last)(city_departure ?city_departure)
                            (city_arrival ?city_arrival)(requested_goods_quantity ?rgq)
                            (requested_goods_type ?good_type)(f_cost ?f_cost)(h_cost ?h_cost)
                            (g_cost ?g_cost)(father ?father)(type_route ?tr))
=>
  (printout t "La città " ?id_city " ha come last " ?last " e richiede " ?rgq " beni e ha città di partenza " ?city_departure ", di arrivo " ?city_arrival " con costo " ?f_cost crlf)
  (retract ?l)
  (pop-focus)
  (pop-focus)
)


; TODo Vedere di mettere due indici, uno per il livello locale e uno per quello globale 
(defmodule RECURSION (import TEMP ?ALL)(export ?ALL))
; Caso di città con lo stesso bene che soddisfa tutta la domanda
(defrule rec-0
  ?cgp<-(city_goods_planning(id_cgp ?id_city)(num ?num)(city_departure ?city_departure)
                            (city_arrival ?city_arrival)(requested_goods_quantity ?rgq)
                            (requested_goods_type ?good_type)(f_cost ?f_cost)(h_cost ?h_cost)
                            (g_cost ?g_cost)(father ?father)(type_route ?tr))
  (city (id_city ?arrival)(provided_goods_quantity ?pgq)(provided_goods_type ?good_type))
  (route (departure ?city_departure)(arrival ?arrival)(km ?km)(type_route ?type_route))
  (test(neq ?good_type NA))
  (test(> ?rgq 0))
  (test(>= ?pgq ?rgq))
  (test (< ?km ?f_cost))
=>
  ;(bind ?last (gensym*))
  (assert (lastcity (id_last (+ ?num 1))))
;  (modify ?cgp (city_departure ?city_departure)(city_arrival ?arrival)(requested_goods_quantity 0)
;               (f_cost (+ ?g_cost ?km))(h_cost 0)(g_cost (+ ?g_cost ?km))(type_route ?type_route))
  (assert (city_goods_planning(id_cgp ?id_city)(num (+ ?num 1))(city_departure ?city_departure)
                              (city_arrival ?arrival)(requested_goods_quantity 0)
                              (requested_goods_type ?good_type)(f_cost ?km)
                              (h_cost 0)(g_cost ?km)(type_route ?type_route)))
  ;(printout t "Ultima città " ?last " per la tratta di " ?id_city crlf)

)
; Caso di città con lo stesso bene che non soddisfa tutta la domanda
(defrule rec-1
  ;?last<-(lastcity ?num)
  ?cgp<-(city_goods_planning(id_cgp ?id_city)(num ?num)(city_departure ?city_departure)
                            (city_arrival ?city_arrival)(requested_goods_quantity ?rgq)
                            (requested_goods_type ?good_type)(f_cost ?f_cost)(h_cost ?h_cost)
                            (g_cost ?g_cost)(father ?father))
  (city (id_city ?arrival)(provided_goods_quantity ?pgq)(provided_goods_type ?good_type))
  (route (departure ?city_departure)(arrival ?arrival)(km ?km)(type_route ?type_route))
  (test(neq ?good_type NA))
  (test(> ?rgq 0))
  (test(< ?pgq ?rgq))
  (test(< (+(/ ?km ?pgq) ?km) ?f_cost))
=>
  (assert (city_goods_planning(id_cgp ?id_city)(num (+ ?num 1))(city_departure ?city_departure)
                              (city_arrival ?arrival)(requested_goods_quantity (- ?rgq ?pgq))
                              (requested_goods_type ?good_type)(f_cost (+(/ ?km ?pgq) ?km))
                              (h_cost (/ ?km ?pgq))(g_cost ?km)(father ?city_departure)
                              (type_route ?type_route)))

)
(defrule rec-2
  ;?last<-(lastcity ?num)
  ?cgp<-(city_goods_planning(id_cgp ?id_city)(num ?num)(city_departure ?city_departure)
                            (city_arrival ?city_arrival)(requested_goods_quantity ?rgq)
                            (requested_goods_type ?rgt)(f_cost ?f_cost)(h_cost ?h_cost)
                            (g_cost ?g_cost)(father ?father))
  (city (id_city ?arrival)(provided_goods_quantity ?pgq)(provided_goods_type ?pgt))
  (route (departure ?city_departure)(arrival ?arrival)(km ?km)(type_route ?type_route))
  (test(neq ?rgt NA))
  (test(> ?rgq 0))
  (test(< (+(* ?km 10) ?km) ?f_cost))
=>
  (assert (city_goods_planning(id_cgp ?id_city)(num (+ ?num 1))(city_departure ?city_departure)
                              (city_arrival ?arrival)(requested_goods_quantity ?rgq)
                              (requested_goods_type ?rgt)(f_cost (+(* ?km 10) ?km))
                              (h_cost (* ?km 10))(g_cost ?km)(father ?city_departure)
                              (type_route ?type_route)))

)
