; ---------------------------------------------
; Modulo e template
; ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))


(deftemplate cell-cf
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
  (slot CF (type INTEGER))
)
(deftemplate cf-best
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
  (slot CF (type INTEGER))
)

; --- Marker per non ripetere il bonus negli step successivi
(deftemplate exp-above-middle-step-mark
  (slot sx) (slot sy)   ; sorgente: middle
  (slot x)  (slot y)    ; target che ha ricevuto il bonus
)
(deftemplate exp-below-middle-step-mark
  (slot sx) (slot sy)
  (slot x)  (slot y)
)

; Marker
(deftemplate advantage-disadvantage (slot sx) (slot sy) (slot x) (slot y))

; ---------------------------------------------
; EVIDENCE CF = 0
; ---------------------------------------------
; -- Diagonale di un pezzo di barca (k-cell ... ~sub&~water)

(defrule zero-diag-se-of-boat (declare (salience 10))
  (k-cell (x ?cx&:(<= ?cx 8)) (y ?cy&:(<= ?cy 8)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule zero-diag-sw-of-boat (declare (salience 10))
  (k-cell (x ?cx&:(<= ?cx 8)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (- ?cy 1)) (CF 0)))
)

(defrule zero-diag-ne-of-boat (declare (salience 10))
  (k-cell (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule zero-diag-nw-of-boat (declare (salience 10))
  (k-cell (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (- ?cy 1)) (CF 0)))
)
; -- Nord, est, ovest di un top

(defrule zero-perim-top-w (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content top))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
)
; E (x, y+1)
(defrule zero-perim-top-e (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content top))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
)
(defrule zero-perim-top-n (declare (salience 10))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content top))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
)
; -- Sud, est, ovest di un bot
(defrule zero-perim-bot-w (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content bot))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
)
; E (x, y+1)
(defrule zero-perim-bot-e (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content bot))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
)
(defrule zero-perim-bot-s (declare (salience 10))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content bot))
=> 
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
)
; -- ovest, sud, nord di un left
(defrule zero-perim-left-w (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content left))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
)
(defrule zero-perim-left-s (declare (salience 10))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content left))
=> 
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
)
(defrule zero-perim-left-n (declare (salience 10))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content left))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
)
; -- est, nord, sud di un right
(defrule zero-perim-right-e (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content right))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
)
(defrule zero-perim-right-s (declare (salience 10))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content right))
=> 
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
)
(defrule zero-perim-right-n (declare (salience 10))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content right))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
)
; -- Diagonale di un k-cell con CF 100

(defrule zero-diag-se-of-cf100 (declare (salience 10))
  (cell-cf (x ?cx&:(<= ?cx 8)) (y ?cy&:(<= ?cy 8)) (CF 100))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule zero-diag-sw-of-cf100 (declare (salience 10))
  (cell-cf (x ?cx&:(<= ?cx 8)) (y ?cy&:(>= ?cy 1)) (CF 100))
=> 
  (assert (cell-cf (x (+ ?cx 1)) (y (- ?cy 1)) (CF 0)))
)

(defrule zero-diag-ne-of-cf100 (declare (salience 10))
  (cell-cf (x ?cx&:(>= ?cx 1)) (y ?cy&:(<= ?cy 8)) (CF 100))
=> 
  (assert (cell-cf (x (- ?cx 1)) (y (+ ?cy 1)) (CF 0)))
)

(defrule zero-diag-nw-of-cf100 (declare (salience 10))
  (cell-cf (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (CF 100))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (- ?cy 1)) (CF 0)))
) 

; -- Perimetro di un sub: 8 celle attorno a (k-cell ... sub)
; W (x, y-1)
(defrule zero-perim-sub-w (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
)
; E (x, y+1)
(defrule zero-perim-sub-e (declare (salience 10))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
)
; S (x+1, y)
(defrule zero-perim-sub-s (declare (salience 10))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
)
; N (x-1, y)
(defrule zero-perim-sub-n (declare (salience 10))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
)
; SW (x+1, y-1)
(defrule zero-perim-sub-sw (declare (salience 10))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (- ?sy 1)) (CF 0)))
)
; NW (x-1, y-1)
(defrule zero-perim-sub-nw (declare (salience 10))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (- ?sy 1)) (CF 0)))
)
; SE (x+1, y+1)
(defrule zero-perim-sub-se (declare (salience 10))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (+ ?sy 1)) (CF 0)))
)
; NE (x-1, y+1)
(defrule zero-perim-sub-ne (declare (salience 10))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (+ ?sy 1)) (CF 0)))
)
; Water → CF 0
(defrule zero-water (declare (salience 10))
  (k-cell (x ?sx) (y ?sy) (content water))
=>
  (assert (cell-cf (x ?sx) (y ?sy) (CF 0)))
)
; ---------------------------------------------
; COMBINAZIONE CF (stessa (x,y)) 
; ---------------------------------------------

; ---------------------------------------------
; Merge: 0 e 100 vincono sempre nel combine (prima di tutto)
; ---------------------------------------------
(defrule combine-cf-zero-wins
  (declare (salience 6))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 0))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)))
  (test (neq ?z ?f))
=>
  (retract ?f)
)
(defrule combine-cf-100-wins
  (declare (salience 6))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 100))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c))
  (test (neq ?z ?f))
=>
  (retract ?f)
)

; ---------------------------------------------
; Merge delle penalità (CF<0) con positivi:
;   C' = C - |P|, clamp a 0. Poi retract della penalità.
; ---------------------------------------------

(defrule combine-cf-penalty-ge
  (declare (salience 5))
  ?p <- (cell-cf (x ?x) (y ?y) (CF ?pn&:(< ?pn 0)))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)&:(>= ?c (abs ?pn))))
=>
  (retract ?p)
  (modify ?f (CF (- ?c (abs ?pn))))
)

(defrule combine-cf-penalty-lt
  (declare (salience 5))
  ?p <- (cell-cf (x ?x) (y ?y) (CF ?pn&:(< ?pn 0)))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)&:(<  ?c (abs ?pn))))
=>
  (retract ?p)
  (modify ?f (CF 0))
)

; ---------------------------------------------
; Merge percentuale tra positivi:
;   C3 = C1 + C2
;   caso <= 100 e caso che andrebbe a >=0 (clamp a 0)
; ---------------------------------------------

(defrule combine-cf-percent-pos-100
  (declare (salience 5))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
  (test (> (+ ?C1 ?C2) 100))
=>
  (retract ?f1)
  (modify ?f2 (CF 100))
)

(defrule combine-cf-percent-pos
  (declare (salience 5))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
  (test (<= (+ ?C1 ?C2) 100))
=>
  (retract ?f1)
  (modify ?f2 (CF (+ ?C1 ?C2)))
)

; --- Row=0 ⇒ CF=0
(defrule build-cell-cf-row-is-zero (declare (salience 8))
  (k-per-row (row ?x) (num 0))
  (k-per-col (col ?y) (num ?py))
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 0)))
)

; --- Col=0 ⇒ CF=0
(defrule build-cell-cf-col-is-zero (declare (salience 8))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num 0))
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 0)))
)

; --- Media 50/50 con denominatore fisso 10 → CF = 5*(px+py) ≤ 100
(defrule build-cell-cf-avg10-leq100 (declare (salience 7))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (<= (+ ?px ?py) 20))               ; 5*(px+py) ≤ 100
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF (* 5 (+ ?px ?py)))))
)

; --- Clamp a 100
(defrule build-cell-cf-avg10-gt100 (declare (salience 7))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (> (+ ?px ?py) 20))                ; 5*(px+py) > 100
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 100)))
)

; ====== Middle: adiacenze ======
(defrule exp-left-middle
  (declare (salience 4))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content middle))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 50)))
)

(defrule exp-right-middle (declare (salience 4))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content middle))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 50)))
)

(defrule exp-below-middle (declare (salience 4))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content middle))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 50)))
)

(defrule exp-above-middle (declare (salience 4))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content middle))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 50)))
)

; ====== Top/Bot: 100 ======
; Sotto a un top -> nave (100): x = x + 1  ⇒ serve x <= 8
(defrule exp-below-top-100 (declare (salience 4))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content top))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 100)))
)
; Sopra a un bot -> nave (100): x = x - 1  ⇒ serve x >= 1
(defrule exp-above-bot-100
  (declare (salience 4))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content bot))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 100)))
)


; ====== Right/Left forti: 1.0 ======
; A sinistra di un right -> nave (100): y = y - 1  ⇒ serve y >= 1
(defrule exp-left-of-right
  (declare (salience 4))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content right))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 100)))
)

; A destra di un left -> nave (100): y = y + 1  ⇒ serve y <= 8
(defrule exp-right-of-left
  (declare (salience 4))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content left))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 100)))
)


; ====== Boost con step < 5: 80 ======
; (richiede un fatto di stato con lo step corrente)
; Esempio di fatto atteso: (status (step 3))
; Sopra a middle e step<5 -> 80
; Sopra a middle e step<5 -> +20
(defrule exp-above-middle-step
  (declare (salience 4))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content middle))  ; x-1 => x>=1
  (not (k-cell (x =(- ?kx 1)) (y ?ky)))                  
  (not (exp-above-middle-step-mark
         (sx ?kx) (sy ?ky) (x =(- ?kx 1)) (y ?ky)))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 20)))
  (assert (exp-above-middle-step-mark (sx ?kx) (sy ?ky) (x (- ?kx 1)) (y ?ky)))
)

; Sotto a middle e step<5 -> +20
(defrule exp-below-middle-step
  (declare (salience 4))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content middle))  ; x+1 => x<=8
  (not (k-cell (x =(+ ?kx 1)) (y ?ky)))                 
  (not (exp-below-middle-step-mark
         (sx ?kx) (sy ?ky) (x =(+ ?kx 1)) (y ?ky)))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 20)))
  (assert (exp-below-middle-step-mark (sx ?kx) (sy ?ky) (x (+ ?kx 1)) (y ?ky)))
)

; ROW: acqua → +1
(defrule bump-row-from-water
  (declare (salience 3))
  (or (k-cell (x ?x) (y ?y1) (content water))
      (cell-cf (x ?x) (y ?y1) (CF 0)))
  (cell-cf (x ?x) (y ?y2&:(<> ?y2 ?y1)) (CF ?c2))
  (not (k-cell (x ?x) (y ?y2)))  ; non toccare celle note
  (not (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))
=>
  (assert (cell-cf (x ?x) (y ?y2) (CF 1)))
  (assert (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))
)
 
; ROW: pezzo barca → −5
(defrule bump-row-from-boat
  (declare (salience 3))
  (or (k-cell (x ?x) (y ?y1) (content ~water))
      (and (cell-cf (x ?x) (y ?y1) (CF 100))
           (not (k-cell (x ?x) (y ?y1)))))
  (cell-cf (x ?x) (y ?y2&:(<> ?y2 ?y1)) (CF ?c2))
  (not (k-cell (x ?x) (y ?y2)))
  (not (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))     
=>
  (assert (cell-cf (x ?x) (y ?y2) (CF -5)))
  (assert (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))
)
; COL: acqua → +1
(defrule bump-col-from-water
  (declare (salience 3))
  (or (k-cell (x ?x1) (y ?y) (content water))
      (cell-cf (x ?x1) (y ?y) (CF 0)))
  (cell-cf (x ?x2&:(<> ?x2 ?x1)) (y ?y) (CF ?c2))
  (not (k-cell (x ?x2) (y ?y)))  ; non toccare celle note
  (not (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
=>
  (assert (cell-cf (x ?x2) (y ?y) (CF 1)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
)

; COL: pezzo barca → −5
(defrule bump-col-from-boat
  (declare (salience 3))
  (or (k-cell (x ?x1) (y ?y) (content ~water))
      (and (cell-cf (x ?x1) (y ?y) (CF 100))
           (not (k-cell (x ?x1) (y ?y)))))
  (cell-cf (x ?x2&:(<> ?x2 ?x1)) (y ?y) (CF ?c2))
  (not (k-cell (x ?x2) (y ?y)))
  (not (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
=>
  (assert (cell-cf (x ?x2) (y ?y) (CF -5)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
)

(defrule seed-best
  (declare (salience 2))
  (cell-cf (x ?x) (y ?y) (CF ?c))
  (not (k-cell (x ?x) (y ?y)))         ; escludi celle già note (water/boat/middle/etc.)
  (not (exec (x ?x) (y ?y)))           ; non già in esecuzione
  (not (cf-best (x ?) (y ?)))
=>
  (assert (cf-best (x ?x) (y ?y) (CF ?c)))
)



(defrule improve-best
  (declare (salience 2))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?bc))
  (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c ?bc)))
  (not (k-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y)))
=>
  (modify ?b (x ?x) (y ?y) (CF ?c))
)


(defrule act-guess-on-kboat (declare (salience 1))
  (status (step ?s) (currently running))
  (moves (guesses ?ng&:(> ?ng 0)))
  (k-cell (x ?x) (y ?y) (content ?c&~water))
  (not (exec (x ?x) (y ?y)))  
  ?b <- (cf-best (x ?bx) (y ?by))
=>
  (retract ?b)
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (pop-focus)
)

(defrule act-fire-best-when-no-kboat
  (declare (salience 0))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky))))))   
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action fire) (x ?bx) (y ?by)))
  (pop-focus)
)


(defrule act-guess-best-fallback
  (declare (salience 0))
  (status (step ?s) (currently running))
  (moves (fires 0) (guesses ?ng&:(> ?ng 0)))
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky))))))   
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action guess) (x ?bx) (y ?by)))
  (pop-focus)
)





