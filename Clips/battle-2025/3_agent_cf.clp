; ---------------------------------------------
; Modulo e template
; ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate cell-cf
  (slot x)
  (slot y)
  (slot CF (type INTEGER))
)
(deftemplate cf-best
  (slot x) (slot y)
  (slot CF (type INTEGER))
)
; Marker
(deftemplate advantage-disadvantage (slot sx) (slot sy) (slot x) (slot y))
; ---------------------------------------------
; COMBINAZIONE CF (stessa (x,y)) 
; ---------------------------------------------

; ---------------------------------------------
; Merge: 0 vince (prima di tutto)
; ---------------------------------------------
(defrule combine-cf-zero-wins-A
  (declare (salience 130))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 0))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)))
  (test (neq ?z ?f))
=>
  (retract ?f)
)

(defrule combine-cf-zero-wins-B
  (declare (salience 130))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 0))
  (test (neq ?f ?z))
=>
  (retract ?f)
)

; ---------------------------------------------
; Merge delle penalità (CF<0) con positivi:
;   C' = C - |P|, clamp a 0. Poi retract della penalità.
; ---------------------------------------------

(defrule combine-cf-penalty-ge
  (declare (salience 120))
  ?p <- (cell-cf (x ?x) (y ?y) (CF ?pn&:(< ?pn 0)))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)&:(>= ?c (abs ?pn))))
=>
  (retract ?p)
  (modify ?f (CF (- ?c (abs ?pn))))
)

(defrule combine-cf-penalty-lt
  (declare (salience 120))
  ?p <- (cell-cf (x ?x) (y ?y) (CF ?pn&:(< ?pn 0)))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)&:(<  ?c (abs ?pn))))
=>
  (retract ?p)
  (modify ?f (CF 0))
)

; ---------------------------------------------
; Merge percentuale tra positivi:
;   C3 = C1 + C2 - (C1*C2)/100
;   caso >0 e caso che andrebbe a <=0 (clamp a 0)
; ---------------------------------------------

(defrule combine-cf-percent-pos
  (declare (salience 110))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
  (test (> (- (+ ?C1 ?C2) (div (* ?C1 ?C2) 100)) 0))
=>
  (retract ?f1)
  (modify ?f2 (CF (- (+ ?C1 ?C2) (div (* ?C1 ?C2) 100))))
)

(defrule combine-cf-percent-to-zero
  (declare (salience 110))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
  (test (<= (- (+ ?C1 ?C2) (div (* ?C1 ?C2) 100)) 0))
=>
  (retract ?f1)
  (modify ?f2 (CF 0))
)

(defrule build-cell-cf-leq-100 (declare (salience 150))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (<= (+ (* ?px 10) (* ?py 10)) 100))
  (not (cell-cf (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y)
                   (CF (+ (* ?px 10) (* ?py 10)))))
)

(defrule build-cell-cf-gt-100 (declare (salience 150))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (> (+ (* ?px 10) (* ?py 10)) 100))
  (not (cell-cf (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 100)))
)

; ====== Middle: adiacenze 60 ======
(defrule exp-left-middle-60
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content middle))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 60)))
)

(defrule exp-right-middle-69
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content middle))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 60)))
)

(defrule exp-below-middle-60
  (declare (salience 80))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content middle))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 60)))
)

(defrule exp-above-middle-60
  (declare (salience 80))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content middle))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 60)))
)

; ====== Top/Bot: 100 ======
; Sotto a un top -> nave (100)
(defrule exp-below-top-100
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content top))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 100)))
)

; Sopra a un bot -> nave (100)
(defrule exp-above-bot-100
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content bot))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 100)))
)

; ====== Right/Left forti: 1.0 ======
; A sinistra di un right -> nave (100)
(defrule exp-left-of-right-1
  (declare (salience 80))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content right))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 100)))
)

; A destra di un left -> nave (100)
(defrule exp-right-of-left-1
  (declare (salience 80))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content left))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 100)))
)

; ====== Boost con step < 5: 80 ======
; (richiede un fatto di stato con lo step corrente)
; Esempio di fatto atteso: (status (step 3))
; Sopra a middle e step<5 -> 80
(defrule exp-above-middle-step-80
  (declare (salience 80))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content middle))
=>
 (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 80)))
)

; Sotto a middle e step<5 -> 80
(defrule exp-below-middle-step-80
  (declare (salience 80))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content middle))
=>
 (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 80)))
)

; ---------------------------------------------
; EVIDENCE CF = 0
; ---------------------------------------------

(defrule AGENT::zero-diag-se-of-boat
  (declare (salience 80))
  (k-cell (x ?cx&:(<= ?cx 8)) (y ?cy&:(<= ?cy 8)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule AGENT::zero-diag-sw-of-boat
  (declare (salience 80))
  (k-cell (x ?cx&:(>= ?cx 1)) (y ?cy&:(<= ?cy 8)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule AGENT::zero-diag-ne-of-boat
  (declare (salience 80))
  (k-cell (x ?cx&:(<= ?cx 8)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (- ?cy 1)) (CF 0)))
)

(defrule AGENT::zero-diag-nw-of-boat
  (declare (salience 80))
  (k-cell (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (- ?cy 1)) (CF 0)))
)

; -- Perimetro di un sub: 8 celle attorno a (k-cell ... sub)
; nord
(defrule zero-perim-sub-n
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
)
; sud
(defrule zero-perim-sub-s
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
)
; est
(defrule zero-perim-sub-e
  (declare (salience 80))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
)
; ovest
(defrule zero-perim-sub-w
  (declare (salience 80))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
)
; nord-est
(defrule zero-perim-sub-ne
  (declare (salience 80))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (- ?sy 1)) (CF 0)))
)
; nord-ovest
(defrule zero-perim-sub-nw
  (declare (salience 80))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (- ?sy 1)) (CF 0)))
)
; sud-est
(defrule zero-perim-sub-se (declare (salience 80))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (+ ?sy 1)) (CF 0)))
)
; sud-ovest
(defrule zero-perim-sub-sw (declare (salience 80))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (+ ?sy 1)) (CF 0)))
)

(defrule zero-water (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content water))
=>
  (assert (cell-cf (x ?sx) (y ?sy) (CF 0)))
)

; ---------------------------------------------
; Vantaggio da riga/colonna: assert di +5
; ---------------------------------------------

; --- Vantaggio +5 per le celle della stessa RIGA di una cella con water ---
(defrule advantage-rows-from-water
  (declare (salience 120))
  (k-cell (x ?x1) (y ?y1) (content water))
  (cell-cf (x ?x1) (y ?y2&:(<> ?y2 ?y1)) (CF ?C2))
  (not (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x1) (y ?y2)))
=>
  (assert (cell-cf (x ?x1) (y ?y2) (CF 5)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x1) (y ?y2)))
)

; --- Vantaggio +5 per le celle della stessa COLONNA di una cella con water ---
(defrule advantage-cols-from-water
  (declare (salience 120))
  (k-cell (x ?x1) (y ?y1) (content water))
  (cell-cf (x ?x2&:(<> ?x2 ?x1)) (y ?y1) (CF ?C2))
  (not (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x2) (y ?y1)))
=>
  (assert (cell-cf (x ?x2) (y ?y1) (CF 5)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x2) (y ?y1)))
)

; --- Svantaggio -5 per le celle della stessa RIGA di una cella con un pezzo di barca ---
(defrule disadvantage-rows-from-boat
  (declare (salience 120))
  (k-cell (x ?x1) (y ?y1) (content water))
  (cell-cf (x ?x1) (y ?y2&:(<> ?y2 ?y1)) (CF ?C2))
  (not (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x1) (y ?y2)))
=>
  (assert (cell-cf (x ?x1) (y ?y2) (CF 5)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x1) (y ?y2)))
)

; --- Svantaggio -5 per le celle della stessa COLONNA di una cella con un pezzo di barca ---
(defrule disadvantage-cols-from-boat
  (declare (salience 120))
  (k-cell (x ?x1) (y ?y1) (content ?c & ~water))
  (cell-cf (x ?x2&:(<> ?x2 ?x1)) (y ?y1) (CF ?C2))
  (not (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x2) (y ?y1)))
=>
  (assert (cell-cf (x ?x2) (y ?y1) (CF 5)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y1) (x ?x2) (y ?y1)))
)



(defrule seed-best (declare (salience 2))
  (cell-cf (x ?x) (y ?y) (CF ?c))
  (not (exec (x ?x) (y ?y)))  
  (not (cf-best (x ?) (y ?)))
=>
  (assert (cf-best (x ?x) (y ?y) (CF ?c)))
)

(defrule improve-best (declare (salience 2))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?bc))
  (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c ?bc)))
  (not (exec (x ?x) (y ?y)))  
=>
  (modify ?b (x ?x) (y ?y) (CF ?c))
)


(defrule act-fire-best (declare (salience 1))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by)))     
=>
  (assert (exec (step ?s) (action fire) (x ?bx) (y ?by)))
  (retract ?b)                         
  (pop-focus)
)

; GUESS 
(defrule act-guess-best (declare (salience 1))
  (status (step ?s) (currently running))
  (moves (fires 0) (guesses ?ng&:(> ?ng 0)))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by)))
=>
  (assert (exec (step ?s) (action guess) (x ?bx) (y ?by)))
  (retract ?b)                         
  (pop-focus)
)





