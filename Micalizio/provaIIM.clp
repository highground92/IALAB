(deftemplate furgone (slot id) (slot capacita) (slot pieno) )

(deftemplate citta (slot nome) (multislot veicoli) (slot tipoMerceRichiesta)
                   (slot quantitaRichiesta)(slot tipoMerceProdotta) (slot quantitaProdotta))

(deftemplate istantanea (multislot citta))

(deftemplate distanza (slot citta1) (slot citta2) (slot km))

(deffacts domain
    (citta (nome Torino) (veicoli 1) (tipoMerceRichiesta A) (quantitaRichiesta 20)
           (tipoMerceProdotta B) (quantitaProdotta 5)))
    (citta (nome Milano)(veicoli 0) (tipoMerceRichiesta A) (quantitaRichiesta 30)
           (tipoMerceProdotta C) (quantitaProdotta 10)))
    (citta (nome Venezia)(veicoli 1)(tipoMerceRichiesta B) (quantitaRichiesta 5)
           (tipoMerceProdotta A) (quantitaProdotta 40)))
    (citta (nome Bologna)(veicoli 1)(tipoMerceRichiesta C) (quantitaRichiesta 10)
           (tipoMerceProdotta B) (quantitaProdotta 5)))
    (citta (nome Genova)(veicoli 0)(tipoMerceRichiesta B) (quantitaRichiesta 5)
           (tipoMerceProdotta A) (quantitaProdotta 10))

    (furgone (id 1) (capacita 4) (pieno 0)) ;0 vuol dire vuoto - 4 é il massimo
    (furgone (id 2) (capacita 4) (pieno 0))
    (furgone (id 3) (capacita 4) (pieno 0))

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

(defrule )





















;
