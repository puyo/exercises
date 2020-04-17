#lang racket/base

; Exercise 1.12. The following pattern of numbers is called Pascal's triangle.
;
;      0  1  2  3  4  5
; ---------------------
; 0 -  1
; 1 -  1  1
; 2 -  1  2  1
; 3 -  1  3  3  1
; 4 -  1  4  6  4  1
; 5 -  1  5 10 10  5  1
;
; The numbers at the edge of the triangle are all 1, and each number inside the
; triangle is the sum of the two numbers above it.
;
; Write a procedure that computes elements of Pascal's triangle by means of a
; recursive process. If a number lies outside of the triangle, return 0 (this
; makes sense if we view pascal as the combination function ). Start counting
; rows and columns from 0.

(define (pascal row col)
  (cond
    ((or (< row 0) (< col 0)) 0)
    ((and (= row 0) (= col 0)) 1)
    (else (+
            (pascal (- row 1) (- col 1))
            (pascal (- row 1) col)
            )
          )
    )
  )

(require rackunit)
(require racket/trace)

; (trace pascal)

(check-equal? (pascal -1  0)  0 "pascal(-1,  0)")
(check-equal? (pascal  0 -1)  0 "pascal( 0, -1)")
(check-equal? (pascal  0  0)  1 "pascal( 0,  0)")
(check-equal? (pascal  1  0)  1 "pascal( 1,  0)")
(check-equal? (pascal  1  1)  1 "pascal( 1,  1)")
(check-equal? (pascal  2  1)  2 "pascal( 2,  1)")
(check-equal? (pascal  5  3) 10 "pascal( 5,  3)")

(displayln "Done")
