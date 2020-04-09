#lang racket/base

; Exercise 1.10. The following procedure computes a mathematical function
; called Ackermann's function.

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

; What are the values of the following expressions?

(A 1 10) ; 1024

(A 2 4) ; 65536

(A 3 3) ; 65536

(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))
(define (k n) (* 5 n n))

(displayln "")

(f 0) ; 0
(f 1) ; 2
(f 2) ; 4
(f 3) ; 6
(f 4) ; 8

; f(n) = 2n for n >= 0

(displayln "")

(g 0) ; 0 = (A 1 0)
      ;   = 0 (clause 1 y = 0)
(g 1) ; 2 = (A 1 1)
      ;   = 2 (clause 3 y = 1)
(g 2) ; 4 = (A 1 2)
      ;   = (A 0 (A 1 1))
      ;   = (A 0 2) (clause 3 y = 1)
      ;   = 2n      (clause 2 x = 0)
(g 3) ; 8 = (A 1 3)
      ;   = (A 0 (A 1 2))
      ;   = (A 0 4)
      ;   = 8
(g 4) ; 16

; g(n) = 2^n for n >= 1

(displayln "")

(h 1) ; 2     = 2^1  = 2^1     =    2^(2^0)
(h 2) ; 4     = 2^2  = 2^(2^1) = 2^(2^(2^0))
(h 3) ; 16    = 2^4  = 2^(2^2) = 2^(2^(2^1))
(h 4) ; 65536 = 2^16 = 2^(2^4) = 2^(2^(2^2))

; h(n) = 2^(2^(2^(n - 2))) for n >= 2
