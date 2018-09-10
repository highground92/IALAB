(defmodule ASTAR (import MOVE ?ALL)(export ?ALL))

(deftemplate node_star (slot ident) (slot gcost) (slot fcost)  (slot father) (slot open) (slot city))

(deftemplate newnode (slot ident) (slot gcost) (slot fcost) (slot father) (slot city))
                         

(deffacts S0
        (open-worse 0)
        (open-better 0)
        (alreadyclosed 0)
        (numberofnodes 0)
)


(defrule start
    (new-destination(id_city ?id_city_destination)(distance ?distance))
    (next_trans(id_trans ?id_trans)(type_trans ?tt))
    (current (id_current ?id_state))
    (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)
             (type_route ?tr)(city ?id_city))
=>
    (bind ?id (gensym*))
    (assert
       (node_star (ident ?id) (gcost 0)
             (fcost ?distance) (father NA) (open yes)(city ?id_city)) 
       (current_star ?id)
    )
    (focus EXPAND)
)

(defrule stampaSol

(declare (salience 101))

?f<-(stampa ?id)

    (next_trans(id_trans ?id_trans)(type_trans ?tt))
    (current (id_current ?id_state))
    (transport (id_state ?id_state)(id_transport ?id_trans)(city ?id_city))

    (node_star (ident ?id) (father ?anc&~?id_city))  

    (exec ?anc ?id ?oper ?r ?c)

=> 
   (assert (stampa ?anc))

   (retract ?f)

)



(defrule stampa-fine

(declare (salience 102))

      (next_trans(id_trans ?id_trans)(type_trans ?tt))
      (current (id_current ?id_state))
      (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(city ?id_city))

      (stampa ?id)

      (node_star (ident ?id) (father ?id_city) (fcost ?fcost) (gcost ?gcost)) 

?f1<- (new-destination(id_city ?id_city_destination)(distance ?distance))

=> 
  (assert (move_to_city ?id (- ?fcost ?gcost)))

  (printout t " A_Star eseguita, muovo " ?id_trans " " ?tt " da " ?id_city " a " ?id crlf)

  (retract ?f1)

  (pop-focus)

)

(defmodule EXPAND (import ASTAR ?ALL) (export ?ALL))

;Posso applicare la move dallo stato corrente a una città se esiste una route che le collega "localmente"
(defrule move-apply (declare (salience 50))

        (next_trans(id_trans ?id_trans)(type_trans ?tt))
        (current (id_current ?id_state))
        (transport (id_state ?id_state)(id_transport ?id_trans)(transport_type ?tt)(city ?id_city)(type_route ?type_route))
        (current_star ?curr)
        (node_star (ident ?curr) (open yes) (city ?id_city))
        (route (departure ?id_city) (arrival ?arrival) (km ?km) (type_route ?type_route))
   => 
        (assert (apply ?curr move ?arrival))
)

(defrule move-exec (declare (salience 50))
        (current_star ?curr)
 ?f1<-  (apply ?curr move ?arrival)

        (node_star (ident ?curr) (city ?id_city) (gcost ?g))
        (new-destination(id_city ?id_city_destination)(distance ?distance))
        (route (departure ?id_city) (arrival ?arrival) (km ?km)) ;route tra città corrente e prossima città
        (route (departure ?arrival) (arrival ?id_city_destination) (km ?km_to_goal)) ;distanza tra prossima città e città goal

   => (bind ?new (gensym*))
      (assert (exec ?curr ?new move ?arrival)
              (newnode (ident ?new) (gcost (+ ?g ?km)) 
                        (fcost (+ ?km_to_goal ?g ?km))
                 (father ?curr)(city ?arrival))
       )
      (retract ?f1)
)


(defrule next-phase (declare (salience 100))
  (newnode (ident ?new))
=>
  (focus CHECK)
)


(defrule change-current (declare (salience 25))

?f1 <-   (current_star ?curr)

?f2 <-   (node_star (ident ?curr))

         (node_star (ident ?best&:(neq ?best ?curr)) (fcost ?bestcost) (open yes))

         (not (node_star (ident ?id&:(neq ?id ?curr)) (fcost ?gg&:(< ?gg ?bestcost)) (open yes)))

   =>    (assert (current_star ?best) )

         (retract ?f1)

         (modify ?f2 (open no))
)


(defrule open-empty (declare (salience 25))

?f1 <-   (current_star ?curr)

?f2 <-   (node_star (ident ?curr))

         (not 
    (node_star (ident ?id&:(neq ?id ?curr))  (open yes) )  
         )

 => 

         (retract ?f1)

         (modify ?f2 (open no))

         (printout t " fail (last  node expanded " ?curr ")" crlf)

         (halt))                

(defmodule CHECK (import EXPAND ?ALL)(export ?ALL))

(defrule goal-not-yet (declare (salience 50))
    (newnode (ident ?id))
    (new-destination(id_city ?id_city_destination))
    (not (newnode (ident ?id) (city ?id_city_destination)))
=>
    (focus NEW)
)


(defrule solution-exist (declare (salience 25))
?f <-     (newnode (ident ?id) (father ?father) (city ?id_city_destination) (gcost ?g))
     (new-destination(id_city ?id_city_destination))
     (node_star (ident ?father))
        => 
     (assert (node_star (ident ?id) (father ?father) (gcost ?g) (fcost 0) (open no)))
     (printout t " Esiste soluzione per goal " ?id_city_destination" con costo " ?g crlf)
     (assert (stampa ?id))
     (retract ?f)
     (pop-focus)
     (pop-focus)
)

(defmodule NEW (import CHECK ?ALL) (export ?ALL))

(defrule check-closed (declare (salience 50)) 

 ?f1 <-    (newnode (ident ?id) (city ?id_city))
           (node_star (ident ?old) (open no) (city ?id_city))
 ?f2 <-    (alreadyclosed ?a)

    =>

           (assert (alreadyclosed (+ ?a 1)))
           (retract ?f1 ?f2)
           (pop-focus)
           (pop-focus)
)



(defrule check-open-worse

(declare (salience 50)) 

?f1 <-    (newnode (ident ?id) (gcost ?g) (father ?anc) (city ?id_city))
           (node_star (ident ?old) (gcost ?g-old) (open yes) (city ?id_city))
           (test (or (> ?g ?g-old) (= ?g-old ?g)))

 ?f2 <-    (open-worse ?a)

    =>

           (assert (open-worse (+ ?a 1)))

           (retract ?f1)

           (retract ?f2)

           (pop-focus))



(defrule check-open-better

(declare (salience 50)) 
?f1 <- (newnode (ident ?id) (gcost ?g) (fcost ?f) (father ?anc) (city ?id_city))
?f2 <- (node_star (ident ?old) (gcost ?g-old) (open yes) (city ?id_city))

           (test (<  ?g ?g-old))

?f3 <- (open-better ?a)
    =>     
  (assert (node_star (ident ?id) (gcost ?g) (fcost ?f) (father ?anc) (open yes) (city ?id_city)))
  (assert (open-better (+ ?a 1)))
  (retract ?f1 ?f2 ?f3)
  (pop-focus)
  (pop-focus)
)



(defrule add-open (declare (salience 25))
 ?f1 <-    (newnode (ident ?id) (gcost ?g) (fcost ?f)(father ?anc)(city ?id_city))
 ?f2 <-    (numberofnodes ?a)
    =>     
   (assert (node_star (ident ?id) (gcost ?g) (fcost ?f)(father ?anc) (open yes) (city ?id_city)))
   (assert (numberofnodes (+ ?a 1)))
   (retract ?f1 ?f2)
   (pop-focus)
   (pop-focus)
)