#lang racket/base

; Exercise 1.3
; (define (square-sum-larger a b c)
;   'your-code-here 42)

(define (square-sum-larger a b c)
  (define (square-sum x y)
    (+ (* x x) (* y y))
    )
  (if (and (< a b) (< a c))
    (square-sum b c)    ; a is the smallest, use b and c
    (if (< b c)         ; a is not the smallest, use a and ?
      (square-sum a c)  ; b is the smallest, use a and c
      (square-sum a b)  ; c is the smallest, use a and b
      )
    )
  )

(require rackunit)

(check-equal? (square-sum-larger 1 2 3) 13 "4 + 9 = 13")
(check-equal? (square-sum-larger 1 3 2) 13 "4 + 9 = 13")
(check-equal? (square-sum-larger 2 1 3) 13 "4 + 9 = 13")
(check-equal? (square-sum-larger 2 3 1) 13 "4 + 9 = 13")
(check-equal? (square-sum-larger 3 1 2) 13 "4 + 9 = 13")
(check-equal? (square-sum-larger 3 2 1) 13 "4 + 9 = 13")
(check-equal? (square-sum-larger 3 4 1) 25 "9 + 16 = 25")

(println "Done")
