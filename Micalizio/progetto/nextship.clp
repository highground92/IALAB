;Si aggiorna il contatore del mezzo e in base ai moduli attraversati si decide quante pop-focus applicare
(defmodule NEXTSHIP (import NEXTTRANSPORT ?ALL) (export ?ALL))

;
(defrule next-trans-done-load
  ?tmp<-(action(type load))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (< ?id_ship 2))
=>
  (modify ?t (id_trans (+ ?id_ship 1)))
  (retract ?tmp)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-done-unload
  ?tmp<-(action(type unload))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (< ?id_ship 2))
=>
  (modify ?t (id_trans (+ ?id_ship 1)))
  (retract ?tmp)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-done-move
  ?tmp1<-(action(type load))
  ?tmp2<-(action(type move))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (< ?id_ship 2))
=>
  (modify ?t (id_trans (+ ?id_ship 1)))
  (retract ?tmp1)
  (retract ?tmp2)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-done-move-2
  ?tmp2<-(action(type unload))
  ?tmp3<-(action(type move))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (< ?id_ship 2))
=>
  (modify ?t (id_trans (+ ?id_ship 1)))
  (retract ?tmp2)
  (retract ?tmp3)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-end-done-load
  ?tmp<-(action(type load))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (= ?id_ship 2))
=>
  (retract ?t)
  (retract ?tmp)
  (assert (next_trans(id_trans 1)(type_trans Plane)))
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-end-done-unload
  ?tmp<-(action(type unload))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (= ?id_ship 2))
=>
  (retract ?t)
  (retract ?tmp)
  (assert (next_trans(id_trans 1)(type_trans Plane)))
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-end-done-move
  ?tmp1<-(action(type load))
  ?tmp2<-(action(type move))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (= ?id_ship 2))
=>
  (retract ?t)
  (retract ?tmp1)
  (retract ?tmp2)
  (assert (next_trans(id_trans 1)(type_trans Plane)))
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

;
(defrule next-trans-end-done-move-2
  ?tmp2<-(action(type unload))
  ?tmp3<-(action(type move))
  ?t <- (next_trans(id_trans ?id_ship))
  (test (= ?id_ship 2))
=>
  (retract ?t)
  (retract ?tmp2)
  (retract ?tmp3)
  (assert (next_trans(id_trans 1)(type_trans Plane)))
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)
