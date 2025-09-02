;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))


(deftemplate grid-pos
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
)

(deftemplate grid-cursor
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
)

; Avvia il seeding una sola volta
(defrule start-grid-seeding
  (declare (salience 100))
  (not (grid-seeded))
=>
  (assert (grid-seeding))
  (assert (grid-cursor (x 0) (y 0)))
)

(deftemplate perim-batch
  (multislot cells)
) ; sequenza piatta: x y x y x y ...

(deftemplate guess-cells
  (multislot cells)
) ; sequenza piatta: x y x y x y ...

(deftemplate water-cell
	(slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
)

; Passi su Y (j = 0..8) della riga i
(defrule seed-step-y (declare (salience 99))
  (grid-seeding)
  ?c <- (grid-cursor (x ?i&:(<= ?i 9)) (y ?j&:(< ?j 9)))
=>
  (assert (grid-pos (x ?i) (y ?j)))
  (modify ?c (y (+ ?j 1)))
)

; Chiusura riga (j = 9) e salto alla riga successiva
(defrule seed-step-row (declare (salience 99))
  (grid-seeding)
  ?c <- (grid-cursor (x ?i&:(<= ?i 9)) (y 9))
=>
  (assert (grid-pos (x ?i) (y 9)))
  (modify ?c (x (+ ?i 1)) (y 0))
)

; Fine seeding: superata l’ultima riga (i = 10)
(defrule seed-finish (declare (salience 98))
  ?flag <- (grid-seeding)
  ?c <- (grid-cursor (x ?i&:(> ?i 9)) (y ?j))
=>
  (retract ?c)
  (retract ?flag)
  (assert (grid-seeded))
)

; ============================================================
; ORIENTAMENTO
;  - Nord (su):       (x-1, y)
;  - Sud (giù):       (x+1, y)
;  - Ovest (sinistra):(x, y-1)
;  - Est  (destra):   (x, y+1)
; Le diagonali:
;  NW(x-1,y-1), NE(x-1,y+1), SW(x+1,y-1), SE(x+1,y+1)
; ============================================================

(defrule mark-right-perimeter-and-queue-west
  (declare (salience 12))
  (k-cell (x ?x) (y ?y) (content right))
  (not (perim-batch (cells $?tail ?x ?y)))
=>
  ; perimetro water per RIGHT (non marcare l'origine come water!)
  (assert (perim-batch (cells
            (- ?x 1) ?y        ; N
            (+ ?x 1) ?y        ; S
            ?x (+ ?y 1)        ; E
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
            ?x ?y              ; ancora in coda
  )))
  ; esplorazione/attacco verso W (dentro la nave)
  (assert (guess-cells (cells ?x (- ?y 1))))
)

(defrule mark-left-perimeter-and-queue-east
  (declare (salience 12))
  (k-cell (x ?x) (y ?y) (content left))
  (not (perim-batch (cells $?tail ?x ?y)))
=>
  (assert (perim-batch (cells
            (- ?x 1) ?y
            (+ ?x 1) ?y
            ?x (- ?y 1)        ; W
            (- ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)
            (+ ?x 1) (- ?y 1)
            (+ ?x 1) (+ ?y 1)
            ?x ?y              ; ancora
  )))
  (assert (guess-cells (cells ?x (+ ?y 1))))
)
  

(defrule mark-perimeter-known-sub
  (declare (salience 12))
  (k-cell (x ?x) (y ?y) (content sub))
  (not (perim-batch (cells $?tail ?x ?y)))
=>
  (assert (perim-batch (cells
            (- ?x 1) ?y
            (+ ?x 1) ?y
            ?x (- ?y 1)
            ?x (+ ?y 1)
            (- ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)
            (+ ?x 1) (- ?y 1)
            (+ ?x 1) (+ ?y 1)
            ?x ?y              ; 
  )))
  (assert (guess-cells (cells ?x ?y)))
)

(defrule mark-top-perimeter-and-queue-south (declare (salience 12))
  (k-cell (x ?x) (y ?y) (content top))
  (not (perim-batch (cells $?tail ?x ?y)))
=>
  (assert (perim-batch (cells
            (- ?x 1) ?y
            ?x (- ?y 1)
            ?x (+ ?y 1)
            (- ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)
            (+ ?x 1) (- ?y 1)
            (+ ?x 1) (+ ?y 1)
            ?x ?y
  )))
  (assert (guess-cells (cells (+ ?x 1) ?y))) ; parentesi ok
)

(defrule mark-bot-perimeter-and-queue-north (declare (salience 12))
  (k-cell (x ?x) (y ?y) (content bot))
  (not (perim-batch (cells $?tail ?x ?y)))
=>
  (assert (perim-batch (cells
            (+ ?x 1) ?y
            ?x (- ?y 1)
            ?x (+ ?y 1)
            (- ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)
            (+ ?x 1) (- ?y 1)
            (+ ?x 1) (+ ?y 1)
            ?x ?y
  )))
  (assert (guess-cells (cells (- ?x 1) ?y)))
)


(defrule mark-middle-perimeter-and-queue-hor (declare (salience 12))
  (k-cell (x ?x) (y ?y) (content middle))
  (not (perim-batch (cells $?tail ?x ?y)))
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
            ?x ?y
  )))
  (assert (guess-cells (cells ?x (- ?y 1) ?x (+ ?y 1))))
)

(defrule fire-known-boat-part-middle-horizontal
  (declare (salience 10))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content middle))
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)
            (- ?x 1) (+ ?y 1)
            (+ ?x 1) (- ?y 1)
            (+ ?x 1) (+ ?y 1)
            ?x ?y                
  )))
  (assert (guess-cells (cells ?x (- ?y 1) ?x (+ ?y 1))))
)


; Consumo "valido": prendo la coppia in testa se è in-bounds
; e solo se, dopo il pop, restano >= 2 elementi (almeno un’altra coppia).
(defrule consume-perim-pair-valid
  (declare (salience 11))
  ?b <- (perim-batch
          (cells
            ?x&:(and (>= ?x 0) (< ?x 10))
            ?y&:(and (>= ?y 0) (< ?y 10))
            $?post&:(>= (length$ $?post) 2)))
  (not (water-cell (x ?x) (y ?y)))
=>
  (assert (water-cell (x ?x) (y ?y)))
  (modify ?b (cells $?post))
)

; Consumo "scarto" (fuori griglia su X): rimuovo la coppia
; solo se, dopo il pop, restano >= 2 elementi.
(defrule consume-perim-pair-drop-oob-x
  (declare (salience 11))
  ?b <- (perim-batch
          (cells
            ?x&:(or (< ?x 0) (> ?x 9))
            ?y
            $?post&:(>= (length$ $?post) 2)))
=>
  (modify ?b (cells $?post))
)

; Consumo "scarto" (fuori griglia su Y): rimuovo la coppia
; solo se, dopo il pop, restano >= 2 elementi.
(defrule consume-perim-pair-drop-oob-y
  (declare (salience 11))
  ?b <- (perim-batch
          (cells
            ?x
            ?y&:(or (< ?y 0) (> ?y 9))
            $?post&:(>= (length$ $?post) 2)))
=>
  (modify ?b (cells $?post))
)

; Consumo "scarto" (già marcata water): rimuovo la coppia
; solo se, dopo il pop, restano >= 2 elementi.
(defrule consume-perim-pair-drop-marked
  (declare (salience 11))
  ?b <- (perim-batch
          (cells
            ?x
            ?y
            $?post&:(>= (length$ $?post) 2)))
  (water-cell (x ?x) (y ?y))
=>
  (modify ?b (cells $?post))
)

; Pulizia: ritraggo SOLO se il bucket è vuoto.
; Se resta una sola coppia (lunghezza = 2), il fatto rimane (origine).
(defrule cleanup-empty-perim-batch
  (declare (salience 11))
  ?b <- (perim-batch (cells $?cells&:(= (length$ $?cells) 0)))
=>
  (retract ?b)
)

; ================================
; QUEUE-ONLY-GUESS + UNGUESS + FIRE EXPLORE
; ================================

; --- UNGUESS: se una cella guessata diventa acqua certa, rimborsa la guess ---
(defrule act-unguess-on-water (declare (salience 5))
  (status (step ?s) (currently running))
  (moves (guesses ?g&:(< ?g 20)))
  (exec (x ?x) (y ?y) (action guess))
  (or (k-cell    (x ?x) (y ?y) (content water))
      (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y) (action unguess)))
=>
  (assert (exec (step ?s) (action unguess) (x ?x) (y ?y)))
  (pop-focus)
)

; --- GUESS dalla coda (alta confidenza) ---
(defrule act-guess-from-queue
  (declare (salience 3))
  (status (step ?s) (currently running))
  (moves (guesses ?g&:(> ?g 0)))
  ?q <- (guess-cells(cells ?x&:(and (>= ?x 0) (< ?x 10)) ?y&:(and (>= ?y 0) (< ?y 10)) $?post))
  (not (k-cell    (x ?x) (y ?y) (content water)))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y) (action guess)))
=>
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (modify ?q (cells $?post))
  (pop-focus)
)

; --- DROP dalla coda: fuori griglia su X ---
(defrule drop-guess-queue-oob-x
  (declare (salience 3))
  ?q <- (guess-cells
          (cells $?pre
                 ?x&:(or (< ?x 0) (> ?x 9))
                 ?y
                 $?post))
=>
  (modify ?q (cells $?pre $?post))
)

; --- DROP dalla coda: fuori griglia su Y ---
(defrule drop-guess-queue-oob-y
  (declare (salience 3))
  ?q <- (guess-cells
          (cells $?pre
                 ?x
                 ?y&:(or (< ?y 0) (> ?y 9))
                 $?post))
=>
  (modify ?q (cells $?pre $?post))
)

; --- DROP dalla coda: già nota acqua / già eseguita ---
(defrule drop-guess-queue-known
  (declare (salience 3))
  ?q <- (guess-cells (cells $?pre ?x ?y $?post))
  (or (k-cell    (x ?x) (y ?y) (content water))
      (water-cell (x ?x) (y ?y))
      (exec       (x ?x) (y ?y)))
=>
  (modify ?q (cells $?pre $?post))
)

; --- Pulizia: ritraggo solo quando la coda è vuota ---
(defrule cleanup-empty-fire-guess
  (declare (salience 3))
  ?q <- (guess-cells (cells $?cells&:(= (length$ $?cells) 0)))
=>
  (retract ?q)
)

; --- FIRE esplorativo (NON usa la coda): sweep su grid-pos ---
(defrule act-fire-explore-sweep (declare (salience 2))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (not (guess-cells (cells $?any)))
  (grid-pos (x ?x) (y ?y))
  (not (k-cell (x ?x) (y ?y) (content water)))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y)))
=>
  (assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
  (pop-focus)
)

; --- GUESS di sweep (ultimo fallback) ---
(defrule act-guess-sweep (declare (salience 1))
  (status (step ?s) (currently running))
  (moves (fires 0) (guesses ?g&:(> ?g 0)))
  (grid-pos (x ?x) (y ?y))
  (not (k-cell (x ?x) (y ?y) (content water)))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y) (action guess)))
=>
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (pop-focus)
)

; --- Chiusura game ---
(defrule act-finish-the-game (declare (salience -1))
  (status (step ?s) (currently running))
=>
  (assert (exec (step ?s) (action solve)))
  (format t "[ACT] Step %d: SOLVE%n" ?s)
  (pop-focus)
)




