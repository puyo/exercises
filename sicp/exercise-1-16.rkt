#lang racket/base

; Exercise 1.16. Iterative version of this function.

(define (square x) (* x x))

(define (fast-expt-r b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt-r b (/ n 2))))
        (else (* b (fast-expt-r b (- n 1))))))

(define (fast-expt b n)
  (define (fast-expt-iter b n acc)
    (cond ((= n 0) acc)
          ((even? n) (fast-expt-iter (square b) (/ n 2) acc))
          (else (fast-expt-iter b (- n 1) (* b acc)))
          )
    )

  (fast-expt-iter b n 1)
  )

(require rackunit)
(require racket/trace)

(check-equal? (fast-expt-r 2 0)  1 "expt(2 0)")
(check-equal? (fast-expt-r 2 1)  2 "expt(2 1)")
(check-equal? (fast-expt-r 2 2)  4 "expt(2 2)")
(check-equal? (fast-expt-r 3 2)  9 "expt(3 2)")
(check-equal? (fast-expt-r 3 3) 27 "expt(3 3)")

(check-equal? (fast-expt 2 0)  1 "expt(2 0)")
(check-equal? (fast-expt 2 1)  2 "expt(2 1)")
(check-equal? (fast-expt 2 2)  4 "expt(2 2)")
(check-equal? (fast-expt 3 2)  9 "expt(3 2)")
(check-equal? (fast-expt 3 3) 27 "expt(3 3)")

(displayln "Done")
