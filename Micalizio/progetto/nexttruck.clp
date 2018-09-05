(defmodule NEXTTRUCK (import NEXTTRANSPORT ?ALL) (export ?ALL))

(defrule next-trans-done-load
  ?tmp<-(action(type load))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (< ?id_truck 5))
=>
  (modify ?t (id_trans (+ ?id_truck 1)))
  (printout t "nuovo truck è: " (+ ?id_truck 1) crlf)
  (retract ?tmp)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

(defrule next-trans-done-unload
  ?tmp<-(action(type unload))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (< ?id_truck 5))
=>
  (modify ?t (id_trans (+ ?id_truck 1)))
  (printout t "nuovo truck è: " (+ ?id_truck 1) crlf)
  (retract ?tmp)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)

(defrule next-trans-done-move
  ?tmp1<-(action(type load))
  ?tmp2<-(action(type move))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (< ?id_truck 5))
=>
  (modify ?t (id_trans (+ ?id_truck 1)))
  (printout t "nuovo truck è: " (+ ?id_truck 1) crlf)
  (retract ?tmp1)
  (retract ?tmp2)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)
(defrule next-trans-done-move-2
  ?tmp2<-(action(type unload))
  ?tmp3<-(action(type move))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (< ?id_truck 5))
=>
  (modify ?t (id_trans (+ ?id_truck 1)))
  (printout t "nuovo truck è: " (+ ?id_truck 1) crlf)
  (retract ?tmp2)
  (retract ?tmp3)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)
;;;;;;;;;;
(defrule next-trans-end-done-load
  ?tmp<-(action(type load))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (= ?id_truck 5))
=>
(printout t "SONO IN trans end load " crlf)
  (retract ?t)
  (retract ?tmp)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)
(defrule next-trans-end-done-unload
  ?tmp<-(action(type unload))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (= ?id_truck 5))
=>
(printout t "SONO IN trans end unload " crlf)

  (retract ?t)
  (retract ?tmp)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)
(defrule next-trans-end-done-move
  ?tmp1<-(action(type load))
  ?tmp2<-(action(type move))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (= ?id_truck 5))
=>
(printout t "SONO IN trans end move " crlf)

  (retract ?t)
  (retract ?tmp1)
  (retract ?tmp2)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)
(defrule next-trans-end-done-move-2
  ?tmp2<-(action(type unload))
  ?tmp3<-(action(type move))
  ?t <- (next_trans(id_trans ?id_truck))
  (test (= ?id_truck 5))
=>
(printout t "SONO IN trans end move " crlf)

  (retract ?t)
  (retract ?tmp2)
  (retract ?tmp3)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
  (pop-focus)
)