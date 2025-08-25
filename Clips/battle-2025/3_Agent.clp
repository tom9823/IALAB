;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate water-cell
	(slot x)
	(slot y)
)
(deftemplate mark-perimeter
  (slot x)
  (slot y)
  (slot content (allowed-values sub left right top bot middle))
)

(defrule fire-known-sub (declare (salience 50))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (k-cell (x ?x) (y ?y) (content sub))
  (not (exec (action fire) (x ?x) (y ?y)))   
=>
  (assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
  (assert (mark-perimeter (x ?x) (y ?y) (content sub)))
  (printout t "I fire cell [" ?x ", " ?y "] that contains sub" crlf)
  (pop-focus)
)

(defrule fire-known-boat-part (declare (salience 50))
  (status (step ?s) (currently running))
  (moves (fires ?f&:(> ?f 0)))
  (k-cell (x ?x) (y ?y) (content ?c&~water&~sub))
  (not (exec (action fire) (x ?x) (y ?y)))
=>
  (assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
  (assert (mark-perimeter (x ?x) (y ?y) (content ?c)))
  (printout t "I fire cell [" ?x ", " ?y "] that contains "?c" part of boat" crlf)
  (pop-focus)
)

;---------------------------------------
; 2) ESPANSIONE DEL PERIMETRO: DIAGONALI
;   (valgono per middle|top|bot|left|right)
;---------------------------------------

; NE (+1, -1)
(defrule AGENT::mark-diag-ne (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content ?c&middle|top|bot|left|right))
  (test (and (< (+ ?x 1) 10) (> ?y 0)))
  (not (water-cell
         (x ?nx&:(= ?nx (+ ?x 1)))
         (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " (- ?y 1) "] (diagonal NE of " ?c ")" crlf)
  (assert (water-cell (x (+ ?x 1)) (y (- ?y 1))))
)

; NW (-1, -1)
(defrule AGENT::mark-diag-nw (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content ?c&middle|top|bot|left|right))
  (test (and (> ?x 0) (> ?y 0)))
  (not (water-cell
         (x ?nx&:(= ?nx (- ?x 1)))
         (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " (- ?y 1) "] (diagonal NW of " ?c ")" crlf)
  (assert (water-cell (x (- ?x 1)) (y (- ?y 1))))
)

; SE (+1, +1)
(defrule AGENT::mark-diag-se (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content ?c&middle|top|bot|left|right))
  (test (and (< (+ ?x 1) 10) (< (+ ?y 1) 10)))
  (not (water-cell
         (x ?nx&:(= ?nx (+ ?x 1)))
         (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " (+ ?y 1) "] (diagonal SE of " ?c ")" crlf)
  (assert (water-cell (x (+ ?x 1)) (y (+ ?y 1))))
)

; SW (-1, +1)
(defrule AGENT::mark-diag-sw (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content ?c&middle|top|bot|left|right))
  (test (and (> ?x 0) (< (+ ?y 1) 10)))
  (not (water-cell
         (x ?nx&:(= ?nx (- ?x 1)))
         (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " (+ ?y 1) "] (diagonal SW of " ?c ")" crlf)
  (assert (water-cell (x (- ?x 1)) (y (+ ?y 1))))
)

;---------------------------------------
; 3) ORTOGONALI “ESTERNE” per terminali
;   top:    su, sx, dx
;   bot:    giù, sx, dx
;   left:   sx, su, giù
;   right:  dx, su, giù
;---------------------------------------

; TOP
(defrule AGENT::mark-top-up (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content top))
  (test (> ?y 0))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (- ?y 1) "] (up of top)" crlf)
  (assert (water-cell (x ?x) (y (- ?y 1))))
)
(defrule AGENT::mark-top-left (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content top))
  (test (> ?x 0))
  (not (water-cell (x ?nx&:(= ?nx (- ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " ?y "] (left of top)" crlf)
  (assert (water-cell (x (- ?x 1)) (y ?y)))
)
(defrule AGENT::mark-top-right (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content top))
  (test (< (+ ?x 1) 10))
  (not (water-cell (x ?nx&:(= ?nx (+ ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " ?y "] (right of top)" crlf)
  (assert (water-cell (x (+ ?x 1)) (y ?y)))
)

; BOT
(defrule AGENT::mark-bot-down (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content bot))
  (test (< (+ ?y 1) 10))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (+ ?y 1) "] (down of bot)" crlf)
  (assert (water-cell (x ?x) (y (+ ?y 1))))
)
(defrule AGENT::mark-bot-left (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content bot))
  (test (> ?x 0))
  (not (water-cell (x ?nx&:(= ?nx (- ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " ?y "] (left of bot)" crlf)
  (assert (water-cell (x (- ?x 1)) (y ?y)))
)
(defrule AGENT::mark-bot-right (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content bot))
  (test (< (+ ?x 1) 10))
  (not (water-cell (x ?nx&:(= ?nx (+ ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " ?y "] (right of bot)" crlf)
  (assert (water-cell (x (+ ?x 1)) (y ?y)))
)

; LEFT
(defrule AGENT::mark-left-left (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content left))
  (test (> ?x 0))
  (not (water-cell (x ?nx&:(= ?nx (- ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " ?y "] (left of left)" crlf)
  (assert (water-cell (x (- ?x 1)) (y ?y)))
)
(defrule AGENT::mark-left-up (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content left))
  (test (> ?y 0))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (- ?y 1) "] (up of left)" crlf)
  (assert (water-cell (x ?x) (y (- ?y 1))))
)
(defrule AGENT::mark-left-down (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content left))
  (test (< (+ ?y 1) 10))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (+ ?y 1) "] (down of left)" crlf)
  (assert (water-cell (x ?x) (y (+ ?y 1))))
)

; RIGHT
(defrule AGENT::mark-right-right (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content right))
  (test (< (+ ?x 1) 10))
  (not (water-cell (x ?nx&:(= ?nx (+ ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " ?y "] (right of right)" crlf)
  (assert (water-cell (x (+ ?x 1)) (y ?y)))
)
(defrule AGENT::mark-right-up (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content right))
  (test (> ?y 0))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (- ?y 1) "] (up of right)" crlf)
  (assert (water-cell (x ?x) (y (- ?y 1))))
)
(defrule AGENT::mark-right-down (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content right))
  (test (< (+ ?y 1) 10))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (+ ?y 1) "] (down of right)" crlf)
  (assert (water-cell (x ?x) (y (+ ?y 1))))
)

;---------------------------------------
; 4) SUB (1×1): tutte le 8 adiacenze
;---------------------------------------

; ortogonali
(defrule AGENT::mark-sub-up (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (> ?y 0))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (- ?y 1) "] (up of sub)" crlf)
  (assert (water-cell (x ?x) (y (- ?y 1))))
)
(defrule AGENT::mark-sub-down (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (< (+ ?y 1) 10))
  (not (water-cell (x ?x) (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" ?x ", " (+ ?y 1) "] (down of sub)" crlf)
  (assert (water-cell (x ?x) (y (+ ?y 1))))
)
(defrule AGENT::mark-sub-left (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (> ?x 0))
  (not (water-cell (x ?nx&:(= ?nx (- ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " ?y "] (left of sub)" crlf)
  (assert (water-cell (x (- ?x 1)) (y ?y)))
)
(defrule AGENT::mark-sub-right (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (< (+ ?x 1) 10))
  (not (water-cell (x ?nx&:(= ?nx (+ ?x 1))) (y ?y)))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " ?y "] (right of sub)" crlf)
  (assert (water-cell (x (+ ?x 1)) (y ?y)))
)

; diagonali
(defrule AGENT::mark-sub-diag-nw (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (and (> ?x 0) (> ?y 0)))
  (not (water-cell (x ?nx&:(= ?nx (- ?x 1))) (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " (- ?y 1) "] (diag NW of sub)" crlf)
  (assert (water-cell (x (- ?x 1)) (y (- ?y 1))))
)
(defrule AGENT::mark-sub-diag-ne (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (and (< (+ ?x 1) 10) (> ?y 0)))
  (not (water-cell (x ?nx&:(= ?nx (+ ?x 1))) (y ?ny&:(= ?ny (- ?y 1)))))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " (- ?y 1) "] (diag NE of sub)" crlf)
  (assert (water-cell (x (+ ?x 1)) (y (- ?y 1))))
)
(defrule AGENT::mark-sub-diag-sw (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (and (> ?x 0) (< (+ ?y 1) 10)))
  (not (water-cell (x ?nx&:(= ?nx (- ?x 1))) (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" (- ?x 1) ", " (+ ?y 1) "] (diag SW of sub)" crlf)
  (assert (water-cell (x (- ?x 1)) (y (+ ?y 1))))
)
(defrule AGENT::mark-sub-diag-se (declare (salience 60))
  (mark-perimeter (x ?x) (y ?y) (content sub))
  (test (and (< (+ ?x 1) 10) (< (+ ?y 1) 10)))
  (not (water-cell (x ?nx&:(= ?nx (+ ?x 1))) (y ?ny&:(= ?ny (+ ?y 1)))))
=>
  (printout t "[PERIM] water at [" (+ ?x 1) ", " (+ ?y 1) "] (diag SE of sub)" crlf)
  (assert (water-cell (x (+ ?x 1)) (y (+ ?y 1))))
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

=>
	(assert (exec (step ?s) (action fire) (x 2) (y 4)))
     (pop-focus)

)

(defrule inerzia1
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 2) (y 5)))
=>


	(assert (exec (step ?s) (action fire) (x 2) (y 5)))
     (pop-focus)

)

(defrule inerzia2
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 2) (y 6)))

=>

	(assert (exec (step ?s) (action fire) (x 2) (y 6)))
     (pop-focus)

)

(defrule inerzia3
	(status (step ?s)(currently running))
	(not (exec  (action fire) (x 1) (y 2)))

=>
	(assert (exec (step ?s) (action fire) (x 1) (y 2)))
     (pop-focus)
)


(defrule inerzia4
	(status (step ?s)(currently running))
	(not (exec (action fire) (x 7) (y 5)))
=>

	(assert (exec (step ?s) (action fire) (x 7) (y 5)))
     (pop-focus)



)

(defrule inerzia5
	(status (step ?s)(currently running))

	(not (exec (action fire) (x 8) (y 3)))
=>



	(assert (exec (step ?s) (action fire) (x 8) (y 3)))
     (pop-focus)


)


(defrule inerzia6
	(status (step ?s)(currently running))
		(not (exec  (action fire) (x 8) (y 4)))
=>


	(assert (exec (step ?s) (action fire) (x 8) (y 4)))
     (pop-focus)

	)





(defrule inerzia7
	(status (step ?s)(currently running))
		(not (exec  (action fire) (x 8) (y 5)))
=>


	(assert (exec (step ?s) (action fire) (x 8) (y 5)))
     (pop-focus)

)


(defrule inerzia8
	(status (step ?s)(currently running))
		(not (exec  (action fire) (x 6) (y 9)))
=>


	(assert (exec (step ?s) (action fire) (x 6) (y 9)))
     (pop-focus)
)


(defrule inerzia9
	(status (step ?s)(currently running))
		(not (exec  (action fire) (x 7) (y 9)))
=>


	(assert (exec (step ?s) (action fire) (x 7) (y 9)))
     (pop-focus)
)

(defrule inerzia10 (declare (salience 30))
	(status (step ?s)(currently running))
		(not (exec  (action fire) (x 6) (y 4)))
=>


	(assert (exec (step ?s) (action fire) (x 6) (y 4)))
     (pop-focus)
)

(defrule inerzia11 (declare (salience 30))
	(status (step ?s)(currently running))
		(not (exec  (action guess) (x 7) (y 7)))
=>


	(assert (exec (step ?s) (action guess) (x 7) (y 7)))
     (pop-focus)
)


(defrule inerzia20 (declare (salience 30))
	(status (step ?s)(currently running))
	(not (exec  (action guess) (x 1) (y 3)))
=>


	(assert (exec (step ?s) (action guess) (x 1) (y 3)))
     (pop-focus)

)

(defrule inerzia21  (declare (salience 30))
	(status (step ?s)(currently running))
	(not (exec  (action guess) (x 1) (y 4)))
=>


	(assert (exec (step ?s) (action guess) (x 1) (y 4)))
     (pop-focus)

)





(defrule print-what-i-know-since-the-beginning
	(k-cell (x ?x) (y ?y) (content ?t) )
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

