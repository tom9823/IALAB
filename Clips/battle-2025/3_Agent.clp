;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate perim-batch
  (multislot cells)
) ; sequenza piatta: x y x y x y ...

(deftemplate fire-guess-cells
  (multislot cells)
) ; sequenza piatta: x y x y x y ...

(deftemplate water-cell
	(slot x)
	(slot y)
)

; Consumo "valido": prendo una coppia (x y) in-bounds e non ancora marcata,
; asserisco la water-cell e rimuovo la coppia dal bucket.
(defrule consume-perim-pair-valid (declare (salience 11))
  ?b <- (perim-batch (cells ?x ?y $?post))
  (test (and (>= ?x 0) (< ?x 10) (>= ?y 0) (< ?y 10)))
  (not (water-cell (x ?x) (y ?y)))
=>
  (assert (water-cell (x ?x) (y ?y)))
  (modify ?b (cells $?post))
)

; Consumo "scarto": fuori griglia o già marcata -> rimuovo solo la coppia.
(defrule consume-perim-pair-drop (declare (salience 11))
  ?b <- (perim-batch (cells $?pre ?x ?y $?post))
  (or (test (or (< ?x 0) (> ?x 9) (< ?y 0) (> ?y 9)))
      (water-cell (x ?x) (y ?y)))
=>
  (modify ?b (cells $?post))
)

; Pulizia: quando il bucket è vuoto, lo ritraggo.
(defrule cleanup-empty-perim-batch (declare (salience 11))
  ?b <- (perim-batch (cells $?cells))
  (test (eq (length$ $?cells) 0))
=>
  (retract ?b)
)


; ============================================================
; ORIENTAMENTO
;  - Nord (su):       (x-1, y)
;  - Sud (giù):       (x+1, y)
;  - Ovest (sinistra):(x, y-1)
;  - Est  (destra):   (x, y+1)
; Le diagonali:
;  NW(x-1,y-1), NE(x-1,y+1), SW(x+1,y-1), SE(x+1,y+1)
; N.B.: il clipping ai bordi è demandato alle regole che consumano perim-batch
; ============================================================


;-------------------------------------------------------------
; SUB (size=1): tutto il perimetro a water
;-------------------------------------------------------------
(defrule mark-perimeter-known-sub
  (declare (salience 10))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content sub))
=>
  (assert (perim-batch
           (cells
             ; Cardinali
             (- ?x 1) ?y      ; N
             (+ ?x 1) ?y      ; S
             ?x (- ?y 1)      ; W
             ?x (+ ?y 1)      ; E
             ; Diagonali
             (- ?x 1) (- ?y 1) ; NW
             (- ?x 1) (+ ?y 1) ; NE
             (+ ?x 1) (- ?y 1) ; SW
             (+ ?x 1) (+ ?y 1) ; SE
           )))
)


;-------------------------------------------------------------
; BOAT PART = TOP
;  - Water: diagonali + N + W + E
;  - Coda di fire/guess: verso S (x+1, x+2, x+3)
;-------------------------------------------------------------
(defrule mark-top-perimeter-and-queue-south
  (declare (salience 10))
  (k-cell (x ?x) (y ?y) (content top))
=>
  ; celle sicuramente water (perimetro per TOP)
  (assert (perim-batch (cells
            ; Cardinali da marcare water
            (- ?x 1) ?y      ; N
            ?x (- ?y 1)      ; W
            ?x (+ ?y 1)      ; E
            ; Diagonali
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
  )))
  ; esplorazione/attacco lungo S
  (assert (fire-guess-cells (cells
            (+ ?x 1) ?y
            (+ ?x 2) ?y
            (+ ?x 3) ?y)))
)


;-------------------------------------------------------------
; BOAT PART = BOT
;  - Water: diagonali + W + E + S
;  - Coda di fire: verso N (x-1, x-2, x-3)
;-------------------------------------------------------------
(defrule mark-bot-perimeter-and-queue-north
  (declare (salience 10))
  (k-cell (x ?x) (y ?y) (content bot))
=>
  ; celle sicuramente water (perimetro per BOT)
  (assert (perim-batch (cells
            ; Cardinali da marcare water
            (+ ?x 1) ?y      ; S
            ?x (- ?y 1)      ; W
            ?x (+ ?y 1)      ; E
            ; Diagonali
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
  )))
  ; esplorazione/attacco lungo N
  (assert (fire-guess-cells (cells
            (- ?x 1) ?y
            (- ?x 2) ?y
            (- ?x 3) ?y)))
)


;-------------------------------------------------------------
; BOAT PART = LEFT
;  - Water: diagonali + N + S + W
;  - Coda di fire/guess: verso E (y+1, y+2, y+3)
;-------------------------------------------------------------
(defrule mark-left-perimeter-and-queue-east
  (declare (salience 10))
  (k-cell (x ?x) (y ?y) (content left))
=>
  ; perimetro water per LEFT
  (assert (perim-batch (cells
            ; Cardinali da marcare water
            (- ?x 1) ?y      ; N
            (+ ?x 1) ?y      ; S
            ?x (- ?y 1)      ; W
            ; Diagonali
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
  )))
  ; esplorazione/attacco verso E
  (assert (fire-guess-cells (cells
            ?x (+ ?y 1)
            ?x (+ ?y 2)
            ?x (+ ?y 3))))
)


;-------------------------------------------------------------
; BOAT PART = RIGHT
;  - Water: diagonali + N + S + E
;  - Coda di fire/guess: verso W (y-1, y-2, y-3)
;-------------------------------------------------------------
(defrule mark-right-perimeter-and-queue-west
  (declare (salience 10))
  (k-cell (x ?x) (y ?y) (content right))
=>
  ; perimetro water per RIGHT
  (assert (perim-batch (cells
            ; Cardinali da marcare water
            (- ?x 1) ?y      ; N
            (+ ?x 1) ?y      ; S
            ?x (+ ?y 1)      ; E
            ; Diagonali
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
  )))
  ; esplorazione/attacco verso W
  (assert (fire-guess-cells (cells
            ?x (- ?y 1)
            ?x (- ?y 2)
            ?x (- ?y 3))))
)


;-------------------------------------------------------------
; BOAT PART = MIDDLE (verticale “ignoto/assunto”): 
;  - Water: diagonali
;  - Coda fire: su e giù (x-1, x+1, poi x-2, x+2)
;-------------------------------------------------------------
(defrule fire-known-boat-part-middle
  (declare (salience 10))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content middle))
  (not (initial-phase_done))
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
  )))
  (assert (fire-guess-cells (cells
            (- ?x 1) ?y    ; subito sopra
            (+ ?x 1) ?y    ; subito sotto
            (- ?x 2) ?y    ; due sopra
            (+ ?x 2) ?y))) ; due sotto
)
;-------------------------------------------------------------
; BOAT PART = MIDDLE (ipotesi orizzontale):
;  - Water: diagonali
;  - Coda fire: a sinistra e a destra (y-1, y+1, poi y-2, y+2)
;-------------------------------------------------------------
(defrule fire-known-boat-part-middle-horizontal
  (declare (salience 10))
  (status (step ?s) (currently running))
  (k-cell (x ?x) (y ?y) (content middle))
  (not (initial-phase_done))
=>
  (assert (perim-batch (cells
            (- ?x 1) (- ?y 1)  ; NW
            (- ?x 1) (+ ?y 1)  ; NE
            (+ ?x 1) (- ?y 1)  ; SW
            (+ ?x 1) (+ ?y 1)  ; SE
  )))
  (assert (fire-guess-cells (cells
            ?x (- ?y 1)   ; subito a Ovest
            ?x (+ ?y 1)   ; subito a Est
            ?x (- ?y 2)   ; due a Ovest
            ?x (+ ?y 2))) ; due a Est
  )
)
; =========================
; Griglia
; =========================
(deftemplate grid-pos
  (slot x) (slot y))

(deftemplate grid-cursor
  (slot x) (slot y))

; Avvia il seeding una sola volta
(defrule start-grid-seeding
  (declare (salience 100))
  (not (grid-seeded))
=>
  (assert (grid-seeding))
  (assert (grid-cursor (x 0) (y 0)))
)

; Passi su Y (j = 0..8) della riga i
(defrule seed-step-y
  (declare (salience 99))
  (grid-seeding)
  ?c <- (grid-cursor (x ?i&:(<= ?i 9)) (y ?j&:(< ?j 9)))
=>
  (assert (grid-pos (x ?i) (y ?j)))
  (modify ?c (y (+ ?j 1)))
)

; Chiusura riga (j = 9) e salto alla riga successiva
(defrule seed-step-row
  (declare (salience 99))
  (grid-seeding)
  ?c <- (grid-cursor (x ?i&:(<= ?i 9)) (y 9))
=>
  (assert (grid-pos (x ?i) (y 9)))
  (modify ?c (x (+ ?i 1)) (y 0))
)

; Fine seeding: superata l’ultima riga (i = 10)
(defrule seed-finish
  (declare (salience 98))
  ?flag <- (grid-seeding)
  ?c <- (grid-cursor (x ?i&:(> ?i 9)) (y ?j))
=>
  (retract ?c)
  (retract ?flag)
  (assert (grid-seeded))
)


; GUESS dalla coda (priorità alta)
(defrule act-guess-from-queue
  (declare (salience 2))
  (status (step ?s) (currently running))
  (moves (fires 0) (guesses ?g&:(> ?g 0)))
  ?q <- (fire-guess-cells (cells ?x ?y $?post))
  (test (and (>= ?x 0) (< ?x 10) (>= ?y 0) (< ?y 10)))
  (not (k-cell (x ?x) (y ?y) (content water)))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y)))
=>
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (modify ?q (cells $?post))
  (pop-focus)
)

; Scarto coppie invalide/già note dalla coda
(defrule drop-guess-queue-pair
  (declare (salience 2))
  ?q <- (fire-guess-cells (cells $?pre ?x ?y $?post))
  (or (test (or (< ?x 0) (> ?x 9) (< ?y 0) (> ?y 9)))
      (k-cell (x ?x) (y ?y) (content water))
      (water-cell (x ?x) (y ?y))
      (exec (x ?x) (y ?y)))
=>
  (modify ?q (cells $?pre $?post))
)

(defrule cleanup-empty-fire-guess
  (declare (salience 2))
  ?q <- (fire-guess-cells (cells $?cells))
  (test (eq (length$ $?cells) 0))
=>
  (retract ?q)
)

; FIRE sweep senza usare ENV::cell (usa grid-pos)
(defrule act-fire-sweep
  (declare (salience 1))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (grid-pos (x ?x) (y ?y))
  (not (k-cell (x ?x) (y ?y) (content water)))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y)))
=>
  (assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
  (pop-focus)
)

; GUESS sweep di fallback (quando la coda è vuota)
(defrule act-guess-sweep
  (declare (salience 0))
  (status (step ?s) (currently running))
  (moves (fires 0) (guesses ?g&:(> ?g 0)))
  (grid-pos (x ?x) (y ?y))
  (not (k-cell (x ?x) (y ?y) (content water)))
  (not (water-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y)))
=>
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (pop-focus)
)

(defrule act-finish-the-game (declare (salience 8))
  (status (step ?s) (currently running))
=>
  (assert (exec (step ?s) (action solve)))
  (format t "[ACT] Step %d: SOLVE" ?s)
  (pop-focus)
)



