#lang racket/base

; Exercise 1.8. Newton's method for cube roots is based on the fact that if y
; is an approximation to the cube root of x, then a better approximation is
; given by the value

; ((x / y^2) + 2y) / 3

; Use this formula to implement a cube-root procedure analogous to the
; square-root procedure. (In Section 1.3.4 we will see how to implement
; Newton’s method in general as an abstraction of these square root and
; cube-root procedures.)

(define (average x y)
  (/ (+ x y) 2)
  )

(define (cube-root x)
  ; newton's method for improving guess y for cube root of x
  ; y2 = ((x / y^2) + 2y) / 3
  (define (improved y x)
    (/ (+ (/ x (* y y)) (* 2 y)) 3)
    )

  ; difference between x and guess^3 = how far off are we?
  (define (delta guess x)
    (abs (- (* guess guess guess) x))
    )

  (define (good-enough? guess x)
    #|
    (displayln "")
    (displayln guess)
    (displayln (* guess guess guess))
    (displayln (delta guess x))
    (displayln (tolerance guess))
    |#

    (< (delta guess x) (tolerance guess))
    )

  (define (tolerance guess)
    (* guess 0.001)
    )

  (define (cbrt-iter guess x)
    (if (good-enough? guess x)
      guess
      (cbrt-iter (improved guess x) x))
    )

  (cbrt-iter 1 x)
  )

(require rackunit)

(displayln "cube-root")

(check-within (cube-root 125.0000) 5.0000 0.0001)
(check-within (cube-root 100.0000) 4.6416 0.0001)
