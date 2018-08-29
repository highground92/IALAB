(deftemplate furgone (slot id) (slot capacita) (slot pieno) )

(deftemplate citta (slot nome) (multislot veicoli) (slot tipoMerceRichiesta)
                   (slot quantitaRichiesta)(slot tipoMerceProdotta) (slot quantitaProdotta) (slot quantitaRicevuta))

(deftemplate istantanea (multislot citta))

(deftemplate distanza (slot citta1) (slot citta2) (slot km))

(deftemplate initial-position-furgone1 (slot citta))
(deftemplate initial-position-furgone2 (slot citta))
(deftemplate initial-position-furgone3 (slot citta))

(deffacts domain
    (citta (nome Torino) (veicoli 1) (tipoMerceRichiesta A) (quantitaRichiesta 20)
           (tipoMerceProdotta B) (quantitaProdotta 5) (quantitaRicevuta 0))
    (citta (nome Milano)(veicoli 0) (tipoMerceRichiesta A) (quantitaRichiesta 30)
           (tipoMerceProdotta C) (quantitaProdotta 10)(quantitaRicevuta 0))
    (citta (nome Venezia)(veicoli 1)(tipoMerceRichiesta B) (quantitaRichiesta 5)
           (tipoMerceProdotta A) (quantitaProdotta 40)(quantitaRicevuta 0))
    (citta (nome Bologna)(veicoli 1)(tipoMerceRichiesta C) (quantitaRichiesta 10)
           (tipoMerceProdotta B) (quantitaProdotta 5)(quantitaRicevuta 0))
    (citta (nome Genova)(veicoli 0)(tipoMerceRichiesta B) (quantitaRichiesta 5)
           (tipoMerceProdotta A) (quantitaProdotta 10)(quantitaRicevuta 0))

    (furgone (id 1) (capacita 4) (pieno 0)) ;0 vuol dire vuoto - 4 é il massimo
    (furgone (id 2) (capacita 4) (pieno 0))
    (furgone (id 3) (capacita 4) (pieno 0))

    (initial-position-furgone1 (citta Torino))
    (initial-position-furgone2 (citta Venezia))
    (initial-position-furgone3 (citta Bologna))

    (distanza (citta1 Torino) (citta2 Milano) (km 138))
    (distanza (citta1 Torino) (citta2 Genova) (km 170))
    (distanza (citta1 Milano) (citta2 Torino) (km 138))
    (distanza (citta1 Milano) (citta2 Venezia) (km 276))
    (distanza (citta1 Milano) (citta2 Bologna) (km 206))
    (distanza (citta1 Bologna) (citta2 Milano) (km 206))
    (distanza (citta1 Bologna) (citta2 Venezia) (km 158))
    (distanza (citta1 Bologna) (citta2 Firenze) (km 101))
    (distanza (citta1 Venezia) (citta2 Milano) (km 276))
    (distanza (citta1 Venezia) (citta2 Bologna) (km 158))
    (distanza (citta1 Genova) (citta2 Firenze) (km 230))
    (distanza (citta1 Genova) (citta2 Torino) (km 170))
    (distanza (citta1 Firenze) (citta2 Genova) (km 230))
    (distanza (citta1 Firenze) (citta2 Bologna) (km 101))
)

(deffacts S0
  (initial-position-furgone1 (citta Torino))
  (initial-position-furgone2 (citta Venezia))
  (initial-position-furgone3 (citta Bologna))
)

(deffacts final
  goal(
    (citta (nome Torino) (quantitaRichiesta 0))
    (citta (nome Milano) (quantitaRichiesta 0))
    (citta (nome Bologna) (quantitaRichiesta 0))
    (citta (nome Venezia) (quantitaRichiesta 0))
    (citta (nome Genova) (quantitaRichiesta 0))
  ))

(defrule start
    (initial-position-furgone1 (citta ?p1))
    (initial-position-furgone2 (citta ?p2))
    (initial-position-furgone3 (citta ?p3))

    goal(
      (citta (nome ?c1) (quantitaRichiesta ?q1))
      (citta (nome ?c2) (quantitaRichiesta ?q2))
      (citta (nome ?c3) (quantitaRichiesta ?q3))
      (citta (nome ?c4) (quantitaRichiesta ?q4))
      (citta (nome ?c5) (quantitaRichiesta ?q5))
    )

    =>

    (bind ?id (gensym*))
    (assert
      (node (ident ?id)(gcost 0)
      (bind ?sum 0)
      (do-for-all-facts ((?f citta)) TRUE
        (bind ?sum (+ ?sum ?f:quantitaRichiesta)))
      (fcost ?sum)
      )
      (status ?id position1 ?p1 position2 ?p2 position3 ?p3)
      (current ?id)
    )
    (focus EXPAND)
)


(defmodule EXPAND (import MAIN ?ALL) (export ?ALL))

(defrule move-furgone-apply
    (current ?curr)
    (node (ident ?curr) (open yes))
    (status ?curr position ?pos)
    (distanza (citta1 ?pos) (citta2 ?newPos))
   =>
  (assert (apply ?curr move ?pos ?newPos))
)

(defrule move-furgone-exec

        (current ?curr)
 ?f1<-  (apply ?curr move ?pos ?newPos)

        (node (ident ?curr) (gcost ?g))
        (goal
          (citta (nome ?c1) (quantitaRichiesta ?q1))
          (citta (nome ?c2) (quantitaRichiesta ?q2))
          (citta (nome ?c3) (quantitaRichiesta ?q3))
          (citta (nome ?c4) (quantitaRichiesta ?q4))
          (citta (nome ?c5) (quantitaRichiesta ?q5))
          )
  ?f2<-  (citta (nome ?c1) (veicoli ?v1) (tipoMerceRichiesta ?t1) (quantitaRicevuta ?qr1))
  ?f3<-  (citta (nome ?c2) (quantitaRicevuta ?qr2))
  ?f4<-  (citta (nome ?c3) (quantitaRicevuta ?qr3))
  ?f5<-  (citta (nome ?c4) (quantitaRicevuta ?qr4))
  ?f6<-  (citta (nome ?c5) (quantitaRicevuta ?qr5))

  (bind ?gcost 0)
  (do-for-all-facts ((?f citta)) TRUE
    (bind ?gcost (+ ?gcost ?f:quantitaRicevuta)))

    (bind ?fcost 0)
    (do-for-all-facts ((?f citta)) TRUE
      (bind ?fcost (+ ?fcost (- ?f:quantitaRichiesta ?f:quantitaRicevuta))))

   => (bind ?new (gensym*))
       (assert (exec ?curr ?new move ?pos ?newPos)
               (status ?new position ?newPos)
               (newnode (ident ?new) (gcost ?gcost))
               (fcost ?fcost)
               (father ?curr)

               (citta (nome Torino) (veicoli 1) (tipoMerceRichiesta A) (quantitaRichiesta 20)
                      (tipoMerceProdotta B) (quantitaProdotta 5) (quantitaRicevuta 0))
               (citta (nome Milano)(veicoli 0) (tipoMerceRichiesta A) (quantitaRichiesta 30)
                      (tipoMerceProdotta C) (quantitaProdotta 10)(quantitaRicevuta 0))
               (citta (nome Venezia)(veicoli 1)(tipoMerceRichiesta B) (quantitaRichiesta 5)
                      (tipoMerceProdotta A) (quantitaProdotta 40)(quantitaRicevuta 0))
               (citta (nome Bologna)(veicoli 1)(tipoMerceRichiesta C) (quantitaRichiesta 10)
                      (tipoMerceProdotta B) (quantitaProdotta 5)(quantitaRicevuta 0))
               (citta (nome Genova)(veicoli 0)(tipoMerceRichiesta B) (quantitaRichiesta 5)
                      (tipoMerceProdotta A) (quantitaProdotta 10)(quantitaRicevuta 0))
      )
       (retract ?f1)
)



(defrule up-exec (declare (salience 50))

        (current ?curr)
 ?f1<-  (apply ?curr up ?r ?c)

        (node (ident ?curr) (gcost ?g))
        (goal position ?x ?y)

   => (bind ?new (gensym*))
      (assert (exec ?curr ?new up ?r ?c)
              (status ?new position (+ ?r 1) ?c)
              (newnode (ident ?new) (gcost (+ ?g 1))
			(fcost (+ (abs (- ?x (+ ?r 1))) (abs (- ?y ?c)) ?g 1))
		 (father ?curr))
       )
      (retract ?f1)
)
