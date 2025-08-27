;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate perim-batch
  (multislot cells)
) ; sequenza piatta: x y x y x y ...

(deftemplate fire-cells
  (multislot cells)
) ; sequenza piatta: x y x y x y ...

(deftemplate water-cell
	(slot x)
	(slot y)
)

; Consumo "valido": prendo una coppia (x y) in-bounds e non ancora marcata,
; asserisco la water-cell e rimuovo la coppia dal bucket.
(defrule consume-perim-pair-valid (declare (salience 58))
  ?b <- (perim-batch (cells ?x ?y $?post))
  (test (and (>= ?x 0) (< ?x 10) (>= ?y 0) (< ?y 10)))
  (not (water-cell (x ?x) (y ?y)))
=>
  (assert (water-cell (x ?x) (y ?y)))
  (printout t "[PERIM-BATCH] water at [" ?x ", " ?y "]" crlf)
  (modify ?b (cells $?post))
)

; Consumo "scarto": fuori griglia o già marcata -> rimuovo solo la coppia.
(defrule consume-perim-pair-drop (declare (salience 58))
  ?b <- (perim-batch (cells $?pre ?x ?y $?post))
  (or (test (or (< ?x 0) (> ?x 9) (< ?y 0) (> ?y 9)))
      (water-cell (x ?x) (y ?y)))
=>
  (modify ?b (cells $?post))
)

; Pulizia: quando il bucket è vuoto, lo ritraggo.
(defrule cleanup-empty-perim-batch (declare (salience 57))
  ?b <- (perim-batch (cells $?cells))
  (test (eq (length$ $?cells) 0))
=>
  (retract ?b)
)


(defrule mark-perimeter-known-sub (declare (salience 59))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content sub))
=>
  (assert (perim-batch
           (cells
             (- ?x 1) ?y      ; left
             (+ ?x 1) ?y      ; right
             ?x (- ?y 1)      ; up
             ?x (+ ?y 1)      ; down
             (- ?x 1) (- ?y 1) ; diag NW
             (+ ?x 1) (- ?y 1) ; diag NE
             (- ?x 1) (+ ?y 1) ; diag SW
             (+ ?x 1) (+ ?y 1) ; diag SE
           )))
  (printout t "I fire cell [" ?x ", " ?y "] that contains sub" crlf)
  (assert (initial-phase-done))
)


;---------------------------------------
; BOAT PART = TOP  → scendi sulle righe: (x+1, x+2, x+3)
;---------------------------------------
(defrule fire-known-boat-part-top (declare (salience 60))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content top))
  (not (initial-phase-done))  
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)  (+ ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)  (+ ?x 1) (+ ?y 1))))
  (assert (fire-cells (cells
            (+ ?x 1) ?y
            (+ ?x 2) ?y
            (+ ?x 3) ?y)))
  (printout t "I fire cell [" ?x ", " ?y "] (TOP) and queue downward rows." crlf)
)

;---------------------------------------
; BOAT PART = BOT  → sali sulle righe: (x-1, x-2, x-3)
;---------------------------------------
(defrule fire-known-boat-part-bot (declare (salience 60))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content bot))
  (not (initial-phase-done))  
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)  (+ ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)  (+ ?x 1) (+ ?y 1))))
  (assert (fire-cells (cells
            (- ?x 1) ?y
            (- ?x 2) ?y
            (- ?x 3) ?y)))
  (printout t "I fire cell [" ?x ", " ?y "] (BOT) and queue upward rows." crlf)
)

;---------------------------------------
; BOAT PART = MIDDLE → su e giù sulle righe:
; prima vicine (x-1, x+1), poi (x-2, x+2)
;---------------------------------------
(defrule fire-known-boat-part-middle (declare (salience 60))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content middle))
  (not (initial-phase_done))
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)  (+ ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)  (+ ?x 1) (+ ?y 1))))
  (assert (fire-cells (cells
            (- ?x 1) ?y   ; subito sopra (x-1)
            (+ ?x 1) ?y   ; subito sotto (x+1)
            (- ?x 2) ?y   ; due sopra
            (+ ?x 2) ?y))) ; due sotto
  (printout t "I fire cell [" ?x ", " ?y "] (MIDDLE) and queue up/down rows." crlf)
)
; Scarta l'head se è fuori-bordo / acqua dedotta / già non disponibile
(defrule drop-invalid-fire-cell (declare (salience 41))
  ?q <- (fire-cells (cells ?x ?y $?rest))
  (or (test (< ?x 1)) (test (> ?x 10))
      (test (< ?y 1)) (test (> ?y 10))
      (water-cell (x ?x) (y ?y))                 ; acqua dedotta dall'agente
      (exec (action fire) (x ?x) (y ?y)))        ; già pianificata
=>
  (modify ?q (cells ?rest)))

; Spara la prossima valida dalla coda
(defrule queue-next-fire-from-fire-cells (declare (salience 40))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  ?q <- (fire-cells (cells ?x ?y $?rest))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (action fire) (x ?x) (y ?y)))
=>
  (assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
  (modify ?q (cells ?rest))
  (printout t "Planned follow-up vertical fire at [" ?x ", " ?y "]" crlf)
  (pop-focus))

; Pulizia code vuote
(defrule clear-empty-fire-cells (declare (salience 39))
  ?q <- (fire-cells (cells))
=>
  (retract ?q)
)


(deftemplate cell-point
  (slot x)
  (slot y)
  (slot num))

(defrule build-cell-point-for-guess (declare (salience 90))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (not (cell-point (x ?x) (y ?y)))
  =>
  (assert (cell-point (x ?x) (y ?y) (num (+ ?px ?py)))))


(defrule inerzia0 (declare (salience 10))
	(status (step ?s)(currently running))
	(not (water-cell (x 0) (y 0)))
	(moves (fires 0) (guesses ?ng&:(> ?ng 0)))

=>
	(assert (exec (step ?s) (action guess) (x 0) (y 0)))
    (pop-focus)

)

(defrule inerzia0-bis (declare (salience 10))
	(status (step ?s)(currently running))
	(moves (guesses 0))
=>
	(assert (exec (step ?s) (action unguess) (x 0) (y 0)))
    (pop-focus)

)



(defrule inerzia
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 2) (y 4)) )
	(not (water-cell (x 2) (y 4)))
=>
	(assert (exec (step ?s) (action fire) (x 2) (y 4)))
    (pop-focus)

)

(defrule inerzia1
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 2) (y 5)))
	(not (water-cell (x 2) (y 5)))
=>

	(assert (exec (step ?s) (action fire) (x 2) (y 5)))
    (pop-focus)

)

(defrule inerzia2
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 2) (y 6)))
	(not (water-cell (x 2) (y 6)))

=>

	(assert (exec (step ?s) (action fire) (x 2) (y 6)))
     (pop-focus)

)

(defrule inerzia3
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 1) (y 2)))
	(not (water-cell (x 1) (y 2)))


=>
	(assert (exec (step ?s) (action fire) (x 1) (y 2)))
     (pop-focus)
)


(defrule inerzia4
	(status (step ?s)(currently running))
	(not (exec (action fire) (x 7) (y 5)))
	(not (water-cell (x 7) (y 5)))

=>

	(assert (exec (step ?s) (action fire) (x 7) (y 5)))
    (pop-focus)
)

(defrule inerzia5
	(status (step ?s)(currently running))
	(not (exec (action fire) (x 8) (y 3)))
	(not (water-cell (x 8) (y 3)))

=>

	(assert (exec (step ?s) (action fire) (x 8) (y 3)))
    (pop-focus)
)


(defrule inerzia6
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 8) (y 4)))
	(not (water-cell (x 8) (y 4)))

=>

	(assert (exec (step ?s) (action fire) (x 8) (y 4)))
    (pop-focus)
)



(defrule inerzia7
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 8) (y 5)))
	(not (water-cell (x 8) (y 5)))

=>

	(assert (exec (step ?s) (action fire) (x 8) (y 5)))
    (pop-focus)

)


(defrule inerzia8
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 6) (y 9)))
	(not (water-cell (x 6) (y 9)))
=>

	(assert (exec (step ?s) (action fire) (x 6) (y 9)))
    (pop-focus)
)


(defrule inerzia9
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 7) (y 9)))
	(not (water-cell (x 7) (y 9)))

=>

	(assert (exec (step ?s) (action fire) (x 7) (y 9)))
    (pop-focus)
)

(defrule inerzia10 (declare (salience 30))
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 6) (y 4)))
	(not (water-cell (x 6) (y 4)))

=>

	(assert (exec (step ?s) (action fire) (x 6) (y 4)))
    (pop-focus)
)

(defrule inerzia11 (declare (salience 30))
	(status (step ?s)(currently running))
	(not (exec  (action guess) (x 7) (y 7)))
	(not (water-cell (x 7) (y 7)))

=>


	(assert (exec (step ?s) (action guess) (x 7) (y 7)))
    (pop-focus)
)


(defrule inerzia20 (declare (salience 30))
	(status (step ?s)(currently running))
	(not (exec  (action guess) (x 1) (y 3)))
	(not (water-cell (x 1) (y 3)))
=>
	(assert (exec (step ?s) (action guess) (x 1) (y 3)))
    (pop-focus)

)

(defrule inerzia21  (declare (salience 30))
	(status (step ?s)(currently running))
	(not (exec  (action guess) (x 1) (y 4)))
	(not (water-cell (x 1) (y 4)))

=>

	(assert (exec (step ?s) (action guess) (x 1) (y 4)))
    (pop-focus)

)





(defrule print-what-i-know-since-the-beginning
	(k-cell (x ?x) (y ?y) (content ?t) )
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

