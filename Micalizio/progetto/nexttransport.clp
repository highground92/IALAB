(defmodule NEXTTRANSPORT (import UPDATESTATE ?ALL) (export ?ALL))

;
(defrule next-trans-truck
  (next_trans(id_trans ?id_truck)(type_trans Truck))
=>
  (focus NEXTTRUCK)
)

;
(defrule next-trans-ship
  (next_trans(id_trans ?id_ship)(type_trans Ship))
=>
  (focus NEXTSHIP)
)

;
(defrule next-trans-plane
  (next_trans(id_trans ?id_plane)(type_trans Plane))
=>
  (focus NEXTPLANE)
)
