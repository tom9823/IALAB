; ---------------------------------------------
; Modulo e template
; ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

; Marker
(deftemplate advantage-disadvantage
  (slot sx (type INTEGER) (range 0 9))
  (slot sy (type INTEGER) (range 0 9))
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
)

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
  (slot sx (type INTEGER) (range 0 9))   ; sorgente: middle
  (slot sy (type INTEGER) (range 0 9))
  (slot x  (type INTEGER) (range 0 9))   ; target che ha ricevuto il bonus
  (slot y  (type INTEGER) (range 0 9))
)

(deftemplate exp-below-middle-step-mark
  (slot sx (type INTEGER) (range 0 9))
  (slot sy (type INTEGER) (range 0 9))
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
)


(deftemplate cell-hp
  (slot x  (type INTEGER) (range 0 9))
  (slot y  (type INTEGER) (range 0 9))
  (slot row-hp (type INTEGER) (range 0 100))
  (slot col-hp (type INTEGER) (range 0 100))
)
; ---------------------------------------------
; inizializzazioni dipendenti da quote
; ---------------------------------------------
; Inizializza gli HP di ogni cella dalla capacità di riga/colonna
(defrule hp-init-cell-hp (declare (salience 92))
  (cell-cf (x ?x) (y ?y))
  (k-per-row (row ?x) (num ?r))
  (k-per-col (col ?y) (num ?c))
  (not (cell-hp (x ?x) (y ?y)))
=>
  (assert (cell-hp (x ?x) (y ?y) (row-hp ?r) (col-hp ?c)))
  (printout t "[HP-INIT] Cell (" ?x "," ?y ") initialized: row HP = " ?r", col HP = " ?c crlf)
)
; ---------------------------------------------
; seed CF da vincoli di riga/colonna
; ---------------------------------------------
; --- Row=0 ⇒ CF=0
(defrule build-cell-cf-row-is-zero (declare (salience 90))
  (k-per-row (row ?x) (num 0))
  (k-per-col (col ?y) (num ?py))
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 0)))
  (format t "[BUILD] CF=0 at (%d,%d): row quota is 0%n" ?x ?y)
)

; --- Col=0 ⇒ CF=0
(defrule build-cell-cf-col-is-zero (declare (salience 90))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num 0))
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 0)))
  (format t "[BUILD] CF=0 at (%d,%d): column quota is 0%n" ?x ?y)
)

; --- Media 50/50 con denominatore fisso 10 → CF = 5*(px+py) ≤ 100
(defrule build-cell-cf-avg10-leq100 (declare (salience 90))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (<= (+ ?px ?py) 20))               ; 5*(px+py) ≤ 100
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF (* 5 (+ ?px ?py)))))
  (format t "[BUILD] CF=%d at (%d,%d) from row=%d, col=%d%n"
          (* 5 (+ ?px ?py)) ?x ?y ?px ?py)
)
; --- Clamp a 100
(defrule build-cell-cf-avg10-gt100 (declare (salience 90))
  (k-per-row (row ?x) (num ?px))
  (k-per-col (col ?y) (num ?py))
  (test (> (+ ?px ?py) 20))                ; 5*(px+py) > 100
  (not (cell-cf (x ?x) (y ?y)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 100)))
  (format t "[BUILD] CF=100 (clamped) at (%d,%d) from row=%d, col=%d%n"
          ?x ?y ?px ?py)
)

; ---------------------------------------------
; EVIDENCE CF = 0
; ---------------------------------------------
; Se row-hp==0 OPPURE col-hp==0, la cella è impossibile: CF 0
(defrule zero-cf-when-hp-depleted (declare (salience 85))
  (cell-hp (x ?x) (y ?y) (row-hp ?rh) (col-hp ?ch))
  (test (or (= ?rh 0) (= ?ch 0)))
  ; non toccare celle già note come barca
  (not (k-cell (x ?x) (y ?y) (content ~water)))
  ; evita duplicati/inutili
  (not (cell-cf (x ?x) (y ?y) (CF 0)))
  (not (cell-cf (x ?x) (y ?y) (CF 100)))
=>
  (assert (cell-cf (x ?x) (y ?y) (CF 0)))
  (printout t "[CF-SET-0] Cell (" ?x "," ?y ") set to CF=0 (rowHP=" ?rh ", colHP=" ?ch ")." crlf)
)
; -- Diagonale di un pezzo di barca (k-cell ... ~sub&~water)

(defrule zero-diag-se-of-boat (declare (salience 85))
  (k-cell (x ?cx&:(<= ?cx 8)) (y ?cy&:(<= ?cy 8)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (+ ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal SE from boat at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (+ ?cx 1) (+ ?cy 1))
)

(defrule zero-diag-sw-of-boat (declare (salience 85))
  (k-cell (x ?cx&:(<= ?cx 8)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (- ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal SW from boat at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (+ ?cx 1) (- ?cy 1))
)

(defrule zero-diag-ne-of-boat (declare (salience 85))
  (k-cell (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (+ ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal NE from boat at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (- ?cx 1) (+ ?cy 1))
)

(defrule zero-diag-nw-of-boat (declare (salience 85))
  (k-cell (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (content ?c&~sub&~water))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (- ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal NW from boat at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (- ?cx 1) (- ?cy 1))
)
; -- Nord, est, ovest di un top

(defrule zero-perim-top-w (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content top))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
  (format t "[CF=0] Top at (%d,%d): west cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (- ?sy 1))
)
; E (x, y+1)
(defrule zero-perim-top-e (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content top))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
  (format t "[CF=0] Top at (%d,%d): east cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (+ ?sy 1))
)
(defrule zero-perim-top-n (declare (salience 85))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content top))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Top at (%d,%d): north cell (%d,%d) is impossible%n"
          ?sx ?sy (- ?sx 1) ?sy)
)
; -- Sud, est, ovest di un bot
(defrule zero-perim-bot-w (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content bot))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
  (format t "[CF=0] Bottom at (%d,%d): west cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (- ?sy 1))
)
; E (x, y+1)
(defrule zero-perim-bot-e (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content bot))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
  (format t "[CF=0] Bottom at (%d,%d): east cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (+ ?sy 1))
)
(defrule zero-perim-bot-s (declare (salience 85))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content bot))
=> 
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Bottom at (%d,%d): south cell (%d,%d) is impossible%n"
          ?sx ?sy (+ ?sx 1) ?sy)
)
; -- ovest, sud, nord di un left
(defrule zero-perim-left-w (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content left))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
  (format t "[CF=0] Left at (%d,%d): west cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (- ?sy 1))
)
(defrule zero-perim-left-s (declare (salience 85))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content left))
=> 
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Left at (%d,%d): south cell (%d,%d) is impossible%n"
          ?sx ?sy (+ ?sx 1) ?sy)
)
(defrule zero-perim-left-n (declare (salience 85))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content left))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Left at (%d,%d): north cell (%d,%d) is impossible%n"
          ?sx ?sy (- ?sx 1) ?sy)
)
; -- est, nord, sud di un right
(defrule zero-perim-right-e (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content right))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
  (format t "[CF=0] Right at (%d,%d): east cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (+ ?sy 1))
)
(defrule zero-perim-right-s (declare (salience 85))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content right))
=> 
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Right at (%d,%d): south cell (%d,%d) is impossible%n"
          ?sx ?sy (+ ?sx 1) ?sy)
)
(defrule zero-perim-right-n (declare (salience 85))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content right))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Right at (%d,%d): north cell (%d,%d) is impossible%n"
          ?sx ?sy (- ?sx 1) ?sy)
)

; -- Perimetro di un sub: 8 celle attorno a (k-cell ... sub)
; W (x, y-1)
(defrule zero-perim-sub-w (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x ?sx) (y (- ?sy 1)) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): west cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (- ?sy 1))
)
; E (x, y+1)
(defrule zero-perim-sub-e (declare (salience 85))
  (k-cell (x ?sx) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x ?sx) (y (+ ?sy 1)) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): east cell (%d,%d) is impossible%n"
          ?sx ?sy ?sx (+ ?sy 1))
)
; S (x+1, y)
(defrule zero-perim-sub-s (declare (salience 85))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): south cell (%d,%d) is impossible%n"
          ?sx ?sy (+ ?sx 1) ?sy)
)
; N (x-1, y)
(defrule zero-perim-sub-n (declare (salience 85))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y ?sy) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): north cell (%d,%d) is impossible%n"
          ?sx ?sy (- ?sx 1) ?sy)
)
; SW (x+1, y-1)
(defrule zero-perim-sub-sw (declare (salience 85))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (- ?sy 1)) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): SW cell (%d,%d) is impossible%n"
          ?sx ?sy (+ ?sx 1) (- ?sy 1))
)
; NW (x-1, y-1)
(defrule zero-perim-sub-nw (declare (salience 85))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy&:(>= ?sy 1)) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (- ?sy 1)) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): NW cell (%d,%d) is impossible%n"
          ?sx ?sy (- ?sx 1) (- ?sy 1))
)
; SE (x+1, y+1)
(defrule zero-perim-sub-se (declare (salience 85))
  (k-cell (x ?sx&:(<= ?sx 8)) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x (+ ?sx 1)) (y (+ ?sy 1)) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): SE cell (%d,%d) is impossible%n"
          ?sx ?sy (+ ?sx 1) (+ ?sy 1))
)
; NE (x-1, y+1)
(defrule zero-perim-sub-ne (declare (salience 85))
  (k-cell (x ?sx&:(>= ?sx 1)) (y ?sy&:(<= ?sy 8)) (content sub))
=>
  (assert (cell-cf (x (- ?sx 1)) (y (+ ?sy 1)) (CF 0)))
  (format t "[CF=0] Sub at (%d,%d): NE cell (%d,%d) is impossible%n"
          ?sx ?sy (- ?sx 1) (+ ?sy 1))
)
; Water → CF 0
(defrule zero-water (declare (salience 85))
  (k-cell (x ?sx) (y ?sy) (content water))
=>
  (assert (cell-cf (x ?sx) (y ?sy) (CF 0)))
  (format t "[CF=0] Known water at (%d,%d)%n" ?sx ?sy)
)
; -- Diagonale di un k-cell con CF 100

(defrule zero-diag-se-of-cf100 (declare (salience 84))
  (cell-cf (x ?cx&:(<= ?cx 8)) (y ?cy&:(<= ?cy 8)) (CF 100))
=>
  (assert (cell-cf (x (+ ?cx 1)) (y (+ ?cy 1)) (CF 0)))
   (format t "[CF=0] Diagonal SE from CF=100 at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (+ ?cx 1) (+ ?cy 1))
)

(defrule zero-diag-sw-of-cf100 (declare (salience 84))
  (cell-cf (x ?cx&:(<= ?cx 8)) (y ?cy&:(>= ?cy 1)) (CF 100))
=> 
  (assert (cell-cf (x (+ ?cx 1)) (y (- ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal SW from CF=100 at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (+ ?cx 1) (- ?cy 1))
)

(defrule zero-diag-ne-of-cf100 (declare (salience 84))
  (cell-cf (x ?cx&:(>= ?cx 1)) (y ?cy&:(<= ?cy 8)) (CF 100))
=> 
  (assert (cell-cf (x (- ?cx 1)) (y (+ ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal NE from CF=100 at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (- ?cx 1) (+ ?cy 1))
)

(defrule zero-diag-nw-of-cf100 (declare (salience 84))
  (cell-cf (x ?cx&:(>= ?cx 1)) (y ?cy&:(>= ?cy 1)) (CF 100))
=>
  (assert (cell-cf (x (- ?cx 1)) (y (- ?cy 1)) (CF 0)))
  (format t "[CF=0] Diagonal NW from CF=100 at (%d,%d) -> (%d,%d)%n"
          ?cx ?cy (- ?cx 1) (- ?cy 1))
) 
; ---------------------------------------------
; espansioni “forti” (CF=100) da shape
; ---------------------------------------------
; Top/Bot forti: 100 
; Sotto a un top -> nave (100): x = x + 1  ⇒ serve x <= 8
(defrule exp-below-top-100 (declare (salience 80))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content top))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 100)))
  (format t "[EXPAND] Top at (%d,%d): below cell (%d,%d) set CF 100%n"
          ?kx ?ky (+ ?kx 1) ?ky)
)
; Sopra a un bot -> nave (100): x = x - 1  ⇒ serve x >= 1
(defrule exp-above-bot-100 (declare (salience 80))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content bot))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 100)))
  (format t "[EXPAND] Bottom at (%d,%d): above cell (%d,%d) set CF 100%n"
          ?kx ?ky (- ?kx 1) ?ky)
)
; Right/Left forti: 100
; A sinistra di un right -> nave (100): y = y - 1  ⇒ serve y >= 1
(defrule exp-left-of-right (declare (salience 80))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content right))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 100)))
  (format t "[EXPAND] Right at (%d,%d): left cell (%d,%d) set CF 100%n"
          ?kx ?ky ?kx (- ?ky 1))
)

; A destra di un left -> nave (100): y = y + 1  ⇒ serve y <= 8
(defrule exp-right-of-left (declare (salience 80))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content left))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 100)))
  (format t "[EXPAND] Left at (%d,%d): right cell (%d,%d) set CF 100%n"
          ?kx ?ky ?kx (+ ?ky 1))
)
; ---------------------------------------------
; Vantaggi a distanza (solo DIS2 e DIS3)
;  - DIS2: 3/7 => CF 43
;  - DIS3: 1/7 => CF 14
; Salience: 79 (tra le espansioni forti 80 e le adiacenze 78)
; ---------------------------------------------

; ===== TOP → si scende (x+2, x+3) =====
(defrule adv-below-top-dis2-43
  (declare (salience 79))
  (k-cell (x ?kx&:(<= ?kx 7)) (y ?ky) (content top))
=>
  (assert (cell-cf (x (+ ?kx 2)) (y ?ky) (CF 43)))
  (format t "[ADV] Top at (%d,%d): dist+2 -> (%d,%d) +CF 43%n"
          ?kx ?ky (+ ?kx 2) ?ky)
)

(defrule adv-below-top-dis3-14
  (declare (salience 79))
  (k-cell (x ?kx&:(<= ?kx 6)) (y ?ky) (content top))
=>
  (assert (cell-cf (x (+ ?kx 3)) (y ?ky) (CF 14)))
  (format t "[ADV] Top at (%d,%d): dist+3 -> (%d,%d) +CF 14%n"
          ?kx ?ky (+ ?kx 3) ?ky)
)

; ===== BOT → si sale (x-2, x-3) =====
(defrule adv-above-bot-dis2-43
  (declare (salience 79))
  (k-cell (x ?kx&:(>= ?kx 2)) (y ?ky) (content bot))
=>
  (assert (cell-cf (x (- ?kx 2)) (y ?ky) (CF 43)))
  (format t "[ADV] Bot at (%d,%d): dist-2 -> (%d,%d) +CF 43%n"
          ?kx ?ky (- ?kx 2) ?ky)
)

(defrule adv-above-bot-dis3-14
  (declare (salience 79))
  (k-cell (x ?kx&:(>= ?kx 3)) (y ?ky) (content bot))
=>
  (assert (cell-cf (x (- ?kx 3)) (y ?ky) (CF 14)))
  (format t "[ADV] Bot at (%d,%d): dist-3 -> (%d,%d) +CF 14%n"
          ?kx ?ky (- ?kx 3) ?ky)
)

; ===== RIGHT → si estende a SINISTRA (y-2, y-3) =====
(defrule adv-left-of-right-dis2-43
  (declare (salience 79))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 2)) (content right))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 2)) (CF 43)))
  (format t "[ADV] Right at (%d,%d): dist-2 -> (%d,%d) +CF 43%n"
          ?kx ?ky ?kx (- ?ky 2))
)

(defrule adv-left-of-right-dis3-14
  (declare (salience 79))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 3)) (content right))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 3)) (CF 14)))
  (format t "[ADV] Right at (%d,%d): dist-3 -> (%d,%d) +CF 14%n"
          ?kx ?ky ?kx (- ?ky 3))
)

; ===== LEFT → si estende a DESTRA (y+2, y+3) =====
(defrule adv-right-of-left-dis2-43
  (declare (salience 79))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 7)) (content left))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 2)) (CF 43)))
  (format t "[ADV] Left at (%d,%d): dist+2 -> (%d,%d) +CF 43%n"
          ?kx ?ky ?kx (+ ?ky 2))
)

(defrule adv-right-of-left-dis3-14
  (declare (salience 79))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 6)) (content left))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 3)) (CF 14)))
  (format t "[ADV] Left at (%d,%d): dist+3 -> (%d,%d) +CF 14%n"
          ?kx ?ky ?kx (+ ?ky 3))
)

; ---------------------------------------------
; Middle: adiacenze
; ---------------------------------------------
(defrule exp-left-middle (declare (salience 78))
  (k-cell (x ?kx) (y ?ky&:(>= ?ky 1)) (content middle))
=>
  (assert (cell-cf (x ?kx) (y (- ?ky 1)) (CF 50)))
  (format t "[EXPAND] Middle at (%d,%d): left neighbor (%d,%d) +CF 50%n"
          ?kx ?ky ?kx (- ?ky 1))
)

(defrule exp-right-middle (declare (salience 78))
  (k-cell (x ?kx) (y ?ky&:(<= ?ky 8)) (content middle))
=>
  (assert (cell-cf (x ?kx) (y (+ ?ky 1)) (CF 50)))
  (format t "[EXPAND] Middle at (%d,%d): right neighbor (%d,%d) +CF 50%n"
          ?kx ?ky ?kx (+ ?ky 1))
)

(defrule exp-below-middle (declare (salience 78))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content middle))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 50)))
  (format t "[EXPAND] Middle at (%d,%d): below neighbor (%d,%d) +CF 50%n"
          ?kx ?ky (+ ?kx 1) ?ky)
)

(defrule exp-above-middle (declare (salience 78))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content middle))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 50)))
  (format t "[EXPAND] Middle at (%d,%d): above neighbor (%d,%d) +CF 50%n"
          ?kx ?ky (- ?kx 1) ?ky)
)

; ---------------------------------------------
; bonus temporizzati (step<5)
; ---------------------------------------------
(defrule exp-above-middle-step (declare (salience 76))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx&:(>= ?kx 1)) (y ?ky) (content middle))  ; x-1 => x>=1
  (not (k-cell (x =(- ?kx 1)) (y ?ky)))                  
  (not (exp-above-middle-step-mark
         (sx ?kx) (sy ?ky) (x =(- ?kx 1)) (y ?ky)))
=>
  (assert (cell-cf (x (- ?kx 1)) (y ?ky) (CF 20)))
  (assert (exp-above-middle-step-mark (sx ?kx) (sy ?ky) (x (- ?kx 1)) (y ?ky)))
  (format t "[BOOST] Step %d: middle at (%d,%d) -> above (%d,%d) +20%n"
          ?s ?kx ?ky (- ?kx 1) ?ky)
)

; Sotto a middle e step<5 -> +20
(defrule exp-below-middle-step (declare (salience 76))
  (status (step ?s&:(< ?s 5)))
  (k-cell (x ?kx&:(<= ?kx 8)) (y ?ky) (content middle))  ; x+1 => x<=8
  (not (k-cell (x =(+ ?kx 1)) (y ?ky)))                 
  (not (exp-below-middle-step-mark
         (sx ?kx) (sy ?ky) (x =(+ ?kx 1)) (y ?ky)))
=>
  (assert (cell-cf (x (+ ?kx 1)) (y ?ky) (CF 20)))
  (assert (exp-below-middle-step-mark (sx ?kx) (sy ?ky) (x (+ ?kx 1)) (y ?ky)))
  (format t "[BOOST] Step %d: middle at (%d,%d) -> below (%d,%d) +20%n"
          ?s ?kx ?ky (+ ?kx 1) ?ky)
)
; ---------------------------------------------
; micro-influenze riga/colonna (+1 / −5 con HP--)
; ---------------------------------------------
; ROW: acqua → +1
(defrule bump-row-from-water (declare (salience 70))
  (or (k-cell (x ?x) (y ?y1) (content water))
      (cell-cf (x ?x) (y ?y1) (CF 0)))
  (cell-cf (x ?x) (y ?y2&:(<> ?y2 ?y1)) (CF ?c2))
  (not (k-cell (x ?x) (y ?y2)))  ; non toccare celle note
  (not (cell-cf (x ?x) (y ?y2) (CF 100)))
  (not (cell-cf (x ?x) (y ?y2) (CF 0)))
  (not (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))
=>
  (assert (cell-cf (x ?x) (y ?y2) (CF 1)))
  (assert (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))
  (format t "[ROW-BUMP] Water at (%d,%d): +1 to (%d,%d)%n"
          ?x ?y1 ?x ?y2)
)
 
; ROW: pezzo barca → −5
(defrule bump-row-from-boat (declare (salience 70))
  (or (k-cell (x ?x) (y ?y1) (content ~water))
      (and (cell-cf (x ?x) (y ?y1) (CF 100))
           (not (k-cell (x ?x) (y ?y1)))))
  (cell-cf (x ?x) (y ?y2&:(<> ?y2 ?y1)) (CF ?c2))
  (not (k-cell (x ?x) (y ?y2)))
  (not (cell-cf (x ?x) (y ?y2) (CF 100)))
  (not (cell-cf (x ?x) (y ?y2) (CF 0)))
  (not (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))   
  ?hp <- (cell-hp (x ?x) (y ?y2) (row-hp ?rh) (col-hp ?ch))
=>
  (modify ?hp (row-hp (max 0 (- ?rh 1))))
  (assert (cell-cf (x ?x) (y ?y2) (CF -5)))
  (assert (advantage-disadvantage (sx ?x) (sy ?y1) (x ?x) (y ?y2)))
  (format t "[ROW-BUMP] Boat at (%d,%d): -5 to (%d,%d), rowHP %d->%d%n"
          ?x ?y1 ?x ?y2 ?rh (max 0 (- ?rh 1)))
)
; COL: acqua → +1
(defrule bump-col-from-water (declare (salience 70))
  (or (k-cell (x ?x1) (y ?y) (content water))
      (cell-cf (x ?x1) (y ?y) (CF 0)))
  (cell-cf (x ?x2&:(<> ?x2 ?x1)) (y ?y) (CF ?c2))
  (not (k-cell (x ?x2) (y ?y)))  ; non toccare celle note
  (not (cell-cf (x ?x2) (y ?y) (CF 100)))
  (not (cell-cf (x ?x2) (y ?y) (CF 0)))
  (not (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
=>
  (assert (cell-cf (x ?x2) (y ?y) (CF 1)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
  (format t "[COL-BUMP] Water at (%d,%d): +1 to (%d,%d)%n"
          ?x1 ?y ?x2 ?y)
)

; COL: pezzo barca → −5
(defrule bump-col-from-boat (declare (salience 70))
  (or (k-cell (x ?x1) (y ?y) (content ~water))
      (and (cell-cf (x ?x1) (y ?y) (CF 100))
           (not (k-cell (x ?x1) (y ?y)))))
  (cell-cf (x ?x2&:(<> ?x2 ?x1)) (y ?y) (CF ?c2))
  (not (k-cell (x ?x2) (y ?y)))
  (not (cell-cf (x ?x2) (y ?y) (CF 100)))
  (not (cell-cf (x ?x2) (y ?y) (CF 0)))
  (not (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
  ?hp <- (cell-hp (x ?x2) (y ?y) (row-hp ?rh) (col-hp ?ch))
=>
  (modify ?hp (col-hp (max 0 (- ?ch 1))))
  (assert (cell-cf (x ?x2) (y ?y) (CF -5)))
  (assert (advantage-disadvantage (sx ?x1) (sy ?y) (x ?x2) (y ?y)))
  (format t "[COL-BUMP] Boat at (%d,%d): -5 to (%d,%d), colHP %d->%d%n"
          ?x1 ?y ?x2 ?y ?ch (max 0 (- ?ch 1)))
)
; ---------------------------------------------
; priorità assolute di merge
; ---------------------------------------------

(defrule combine-cf-zero-wins (declare (salience 62))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 0))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c))
  (test (neq ?z ?f))
=>
  (retract ?f)
  (format t "[COMBINE] Cell (%d,%d): CF 0 wins over %d%n" ?x ?y ?c)
)
(defrule combine-cf-100-wins (declare (salience 62))
  ?z <- (cell-cf (x ?x) (y ?y) (CF 100))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c))
  (test (neq ?z ?f))
=>
  (retract ?f)
  (format t "[COMBINE] Cell (%d,%d): CF 100 wins over %d%n" ?x ?y ?c)
)

; ---------------------------------------------
; fusioni/somma/clamp/penalità
; ---------------------------------------------
; Normalizza CF molto alti a 100 (ma non toccare celle note)
(defrule cf-cap-strong-to-100 (declare (salience 61))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(>= ?c 70)&:(< ?c 100)))
  (not (k-cell (x ?x) (y ?y)))
=>
  (modify ?f (CF 100))
  (format t "[NORM] CF at (%d,%d): %d -> 100 (strong and certain)%n" ?x ?y ?c)
)

(defrule combine-cf-penalty-ge (declare (salience 60))
  ?p <- (cell-cf (x ?x) (y ?y) (CF ?pn&:(< ?pn 0)))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)&:(>= ?c (abs ?pn))))
=>
  (retract ?p)
  (modify ?f (CF (- ?c (abs ?pn))))
  (format t "[COMBINE] Cell (%d,%d): %d + penalty %d -> %d%n"
          ?x ?y ?c ?pn (- ?c (abs ?pn)))
)

(defrule combine-cf-penalty-lt (declare (salience 60))
  ?p <- (cell-cf (x ?x) (y ?y) (CF ?pn&:(< ?pn 0)))
  ?f <- (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c 0)&:(<  ?c (abs ?pn))))
=>
  (retract ?p)
  (modify ?f (CF 0))
  (format t "[COMBINE] Cell (%d,%d): %d + penalty %d -> clamped to 0%n"
          ?x ?y ?c ?pn)
)

(defrule combine-cf-percent-pos-100 (declare (salience 60))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
  (test (> (+ ?C1 ?C2) 100))
=>
  (retract ?f1)
  (modify ?f2 (CF 100))
  (format t "[COMBINE] Cell (%d,%d): %d + %d -> clamped to 100%n"
          ?x ?y ?C1 ?C2)
)

(defrule combine-cf-percent-pos (declare (salience 60))
  ?f1 <- (cell-cf (x ?x) (y ?y) (CF ?C1&:(> ?C1 0)&:(<= ?C1 100)))
  ?f2 <- (cell-cf (x ?x) (y ?y) (CF ?C2&:(> ?C2 0)&:(<= ?C2 100)))
  (test (neq ?f1 ?f2))
  (test (<= (+ ?C1 ?C2) 100))
=>
  (retract ?f1)
  (modify ?f2 (CF (+ ?C1 ?C2)))
  (format t "[COMBINE] Cell (%d,%d): %d + %d -> %d%n"
          ?x ?y ?C1 ?C2 (+ ?C1 ?C2))
)



; ---------------------------------------------
; tracking del massimo corrente
; ---------------------------------------------

(defrule seed-best (declare (salience 30))
  (cell-cf (x ?x) (y ?y) (CF ?c))
  (not (k-cell (x ?x) (y ?y)))         
  (not (exec (x ?x) (y ?y)))           
  (not (cf-best (x ?) (y ?)))
=>
  (assert (cf-best (x ?x) (y ?y) (CF ?c)))
  (format t "[BEST] Seed best: cell (%d,%d) with CF=%d%n" ?x ?y ?c)
)


(defrule improve-best (declare (salience 30))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?bc))
  (cell-cf (x ?x) (y ?y) (CF ?c&:(> ?c ?bc)))
  (not (k-cell (x ?x) (y ?y)))
  (not (exec (x ?x) (y ?y)))
=>
  (modify ?b (x ?x) (y ?y) (CF ?c))
  (format t "[BEST] Update: (%d,%d, CF=%d) -> (%d,%d, CF=%d)%n"
          ?bx ?by ?bc ?x ?y ?c)
)

; ---------------------------------------------
; Azioni — Strategia di selezione della mossa
; Ordine di priorità (salience alta → bassa):
;  1) GUESS su barca nota (k-cell ~water).
;  2) GUESS su best con CF ≥ 90, solo se non esistono k-cell non ancora guessate.
;  3) FIRE “esplorativo” su best con 25 ≤ CF < 50, solo se non esistono k-cell non-guessate.
;  4) FIRE “fallback” su best, solo se non esistono k-cell non-guessate.
;  5) GUESS “fallback” su best
;  6) FIRE generico “fallback” sul best (copertura finale), sempre evitando k-cell non-guessate.
;  7) SOLVE per chiudere il turno (attiva la fase ENV).
; ---------------------------------------------
(defrule act-guess-on-kboat
  (declare (salience 13))
  (status (step ?s) (currently running))
  (moves (guesses ?ng&:(> ?ng 0)))
  (k-cell (x ?x) (y ?y) (content ?c&~water))
  ; consenti GUESS anche se c'è stato un FIRE prima
  (not (exec (x ?x) (y ?y) (action guess)))
  ?b <- (cf-best (x ?bx) (y ?by))
=>
  (retract ?b)
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (format t "[ACT] Step %d: GUESS on known-boat cell (%d,%d)%n" ?s ?x ?y)
  (pop-focus)
)

; Alta certezza: GUESS su CF >= 90 (se non ci sono barche non-guessate)
(defrule act-guess-on-cell-cf-ge-90
  (declare (salience 12))
  (status (step ?s) (currently running))
  (moves (guesses ?ng&:(> ?ng 0)))
  ; blocca se esiste una barca NON ancora guessata
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky) (action guess))))))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c&:(>= ?c 90)))
  (not (exec (x ?bx) (y ?by) (action guess)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action guess) (x ?bx) (y ?by)))
  (format t "[ACT] Step %d: GUESS high-CF (%d,%d) CF=%d%n" ?s ?bx ?by ?c)
  (pop-focus)
)

; Esplorazione: FIRE su CF medio [25,50) se non ci sono barche non-guessate
(defrule act-fire-best-explore
  (declare (salience 11))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky) (action guess))))))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c&:(>= ?c 25)&:(< ?c 50)))
  (not (exec (x ?bx) (y ?by) (action fire)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action fire) (x ?bx) (y ?by)))
  (format t "[ACT] Step %d: FIRE explore (%d,%d) CF=%d in [30,75)%n"
          ?s ?bx ?by ?c)
  (pop-focus)
)

; Fallback con FIRE (evita sprechi su CF >= 75)
(defrule act-fire-best-when-no-kboat (declare (salience 10))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky) (action guess))))))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c&:(< ?c 50)))
  (not (exec (x ?bx) (y ?by) (action fire)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action fire) (x ?bx) (y ?by)))
  (format t "[ACT] Step %d: FIRE fallback (%d,%d) CF=%d (<75)%n"
          ?s ?bx ?by ?c)
  (pop-focus)
)

; usa GUESS sul best
(defrule act-guess-best-fallback (declare (salience 9))
  (status (step ?s) (currently running))
  (moves (guesses ?ng&:(> ?ng 0)))
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky) (action guess))))))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by) (action guess)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action guess) (x ?bx) (y ?by)))
  (format t "[ACT] Step %d: GUESS fallback (%d,%d) CF=%d%n"
          ?s ?bx ?by ?c)
  (pop-focus)
)
; Fallback con FIRE 
(defrule act-fire-best (declare (salience 8))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (not (exists (and (k-cell (x ?kx) (y ?ky) (content ?kc&~water))
                    (not (exec (x ?kx) (y ?ky) (action guess))))))
  ?b <- (cf-best (x ?bx) (y ?by) (CF ?c))
  (not (exec (x ?bx) (y ?by) (action fire)))
=>
  (retract ?b)
  (assert (exec (step ?s) (action fire) (x ?bx) (y ?by)))
  (format t "[ACT] Step %d: FIRE fallback (%d,%d) CF=%d (<75)%n"
          ?s ?bx ?by ?c)
  (pop-focus)
)


(defrule act-finish-the-game (declare (salience 7))
  (status (step ?s) (currently running))
=>
  (assert (exec (step ?s) (action solve)))
  (format t "[ACT] Step %d: SOLVE%n" ?s)
  (pop-focus)
)
