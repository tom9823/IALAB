; ---------------------------------------------
; Modulo e template
; ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate cell-cf
  (slot x)
  (slot y)
  (slot CF (type INTEGER) (range 0 100))
)
(deftemplate cf-best
  (slot x) (slot y)
  (slot CF (type INTEGER) (range 0 100))
)
; ---------------------------------------------
; COMBINAZIONE CF (stessa (x,y)) 
; ---------------------------------------------

; 0 vince: se esistono più evidenze e una ha CF=0, lasciamo 0
(defrule combine-cf-zero-wins-A (declare (salience 130))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 0))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)))
  (test (neq ?z ?f))
=>
  (retract ?f) ; mantengo il fatto con CF 0
)

(defrule combine-cf-zero-wins-B
  (declare (salience 130))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 0))
  (test (neq ?f ?z))
=>
  (retract ?f)
)

; Fusione percentuale per CF > 0: C3 = C1 + C2 - (C1*C2)/100
(defrule combine-cf-percent
  (declare (salience 100))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
=>
  (retract ?f1)
  (modify ?f2 (CF (- (+ ?C1 ?C2) (div (* ?C1 ?C2) 100))))
)


(defrule build-cell-cf-leq-100 (declare (salience 100))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (<= (+ (* ?px 10) (* ?py 10)) 100))
  (not (cell-cf (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y)
                   (CF (+ (* ?px 10) (* ?py 10)))))
)

(defrule build-cell-cf-gt-100 (declare (salience 100))
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
  (k-cell (x ?kx) (y ?ky) (content middle))
  (test (>= ?ky 1))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 60)))
)

(defrule exp-right-middle-69
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content middle))
  (test (<= ?ky 8))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 60)))
)

(defrule exp-below-middle-60
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content middle))
  (test (<= ?kx 8))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 60)))
)

(defrule exp-above-middle-60
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content middle))
  (test (>= ?kx 1))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 60)))
)

; ====== Top/Bot: 100 ======
; Sotto a un top -> nave (100)
(defrule exp-below-top-100
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content top))
  (test (<= ?ky 8))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 100)))
)

; Sopra a un bot -> nave (100)
(defrule exp-above-bot-100
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content bot))
  (test (>= ?ky 1))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 100)))
)

; ====== Right/Left forti: 1.0 ======
; A sinistra di un right -> nave (100)
(defrule exp-left-of-right-1
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content right))
  (test (>= ?kx 1))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 100)))
)

; A destra di un left -> nave (100)
(defrule exp-right-of-left-1
  (declare (salience 80))
  (k-cell (x ?kx) (y ?ky) (content left))
  (test (<= ?kx 8))
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
  (k-cell (x ?kx) (y ?ky) (content middle))
  (test (>= ?ky 1))
=>
 (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 80)))
)

; Sotto a middle e step<5 -> 80
(defrule exp-below-middle-step-80
  (declare (salience 80))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx) (y ?ky) (content middle))
  (test (<= ?ky 8))
=>
 (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 80)))
)

; ---------------------------------------------
; EVIDENCE CF = 0
; ---------------------------------------------

(defrule AGENT::zero-diag-se-of-boat
  (declare (salience 80))
  (k-cell (x ?cx) (y ?cy) (content ?c&~sub&~water))
  (test (<= ?cx 8)) (test (<= ?cy 8))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule AGENT::zero-diag-sw-of-boat
  (declare (salience 80))
  (k-cell (x ?cx) (y ?cy) (content ?c&~sub&~water))
  (test (>= ?cx 1)) (test (<= ?cy 8))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule AGENT::zero-diag-ne-of-boat
  (declare (salience 80))
  (k-cell (x ?cx) (y ?cy) (content ?c&~sub&~water))
  (test (<= ?cx 8)) (test (>= ?cy 1))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (- ?cy 1)) (CF 0)))
)

(defrule AGENT::zero-diag-nw-of-boat
  (declare (salience 80))
  (k-cell (x ?cx) (y ?cy) (content ?c&~sub&~water))
  (test (>= ?cx 1)) (test (>= ?cy 1))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (- ?cy 1)) (CF 0)))
)

; -- Perimetro di un sub: 8 celle attorno a (k-cell ... sub)
; nord
(defrule zero-perim-sub-n
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (>= ?sy 1))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
)
; sud
(defrule zero-perim-sub-s
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (<= ?sy 8))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
)
; est
(defrule zero-perim-sub-e
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (<= ?sx 8))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
)
; ovest
(defrule zero-perim-sub-w
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (>= ?sx 1))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
)
; nord-est
(defrule zero-perim-sub-ne
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (<= ?sx 8)) (test (>= ?sy 1))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (- ?sy 1)) (CF 0)))
)
; nord-ovest
(defrule zero-perim-sub-nw
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (>= ?sx 1)) (test (>= ?sy 1))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (- ?sy 1)) (CF 0)))
)
; sud-est
(defrule zero-perim-sub-se
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (<= ?sx 8)) (test (<= ?sy 8))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (+ ?sy 1)) (CF 0)))
)
; sud-ovest
(defrule zero-perim-sub-sw
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content sub))
  (test (>= ?sx 1)) (test (<= ?sy 8))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (+ ?sy 1)) (CF 0)))
)

(defrule zero-water
  (declare (salience 80))
  (k-cell (x ?sx) (y ?sy) (content water))
=>
  (assert (cell-cf (x ?sx) (y ?sy) (CF 0)))
)

(defrule seed-best (declare (salience 40))
  (cell-cf (x ?x) (y ?y) (CF ?c))
  (not (exec (x ?x) (y ?y)))  
  (not (cf-best (x ?) (y ?)))
=>
  (assert (cf-best (x ?x) (y ?y) (CF ?c)))
)

(defrule improve-best (declare (salience 40))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?bc))
  (not (exec (x ?x) (y ?y)))  
  (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c ?bc)))
=>
  (modify ?b (x ?x) (y ?y) (CF ?c))
)


(defrule act-fire-best (declare (salience 20))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by)))     
=>
  (assert (exec (step ?s) (action fire) (x ?bx) (y ?by)))
  (retract ?b)                         
  (pop-focus)
)

; GUESS se CF < 50
(defrule act-guess-best (declare (salience 20))
  (status (step ?s) (currently running))
  (moves (fires 0) (guesses ?ng&:(> ?ng 0)))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by)))
=>
  (assert (exec (step ?s) (action guess) (x ?bx) (y ?by)))
  (retract ?b)                         
  (pop-focus)
)




