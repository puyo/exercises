#lang racket/base

; Exercise 1.7. The good-enough? test used in computing square roots will not
; be very effective for finding the square roots of very small numbers. Also,
; in real computers, arithmetic operations are almost always performed with
; limited precision. This makes our test inadequate for very large numbers.
; Explain these statements, with examples showing how the test fails for small
; and large numbers.

; An alternative strategy for implementing good-enough? is to watch how guess
; changes from one iteration to the next and to stop when the change is a very
; small fraction of the guess. Design a square-root procedure that uses this
; kind of end test. Does this work better for small and large numbers?

; (define (my-sqrt x)
;   'your-code-here 42)

; (define (my-sqrt x)
;   'your-code-here 42)

; (square (sqrt 0.0009))
; 0.0016241401856992538

; (square (my-sqrt 0.0009))
; 1764

; ----------------------------------------------------------------------

(define (square x)
  (* x x)
  )

(define (average x y)
  (/ (+ x y) 2)
  )

; ----------------------------------------------------------------------

(define (my-sqrt1 x)

  (define (improve guess x)
    (average guess (/ x guess))
    )

  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001)
    )

  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x))
    )

  (sqrt-iter 1 x)
  )

; ----------------------------------------------------------------------

(define (my-sqrt2 x)
  ; This version picks a tolerance dynamically as a fraction of the current
  ; guess, so the scale of x doesn't matter as much.

  ; newton's method for improving guess
  (define (improved guess x)
    (average guess (/ x guess))
    )

  ; difference between x and guess^2 = how far off are we?
  (define (delta guess x)
    (abs (- (square guess) x))
    )

  (define (good-enough? guess x)
    (< (delta guess x) (tolerance guess))
    )

  (define (tolerance guess)
    (* guess 0.001)
    )

  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
      guess
      (sqrt-iter (improved guess x) x))
    )

  (sqrt-iter 1 x)
  )

; ----------------------------------------------------------------------

(require rackunit)

(println "sqrt")

(check-within     (sqrt 9.0000)  3.000 0.0000) ; ok
(check-within     (sqrt 0.0009)  0.030 0.0000) ; ok

(println "my-sqrt1")

(check-within (my-sqrt1 9.0000)  3.000 0.0001) ; ok
(check-within (my-sqrt1 0.0009)  0.030 0.0001) ; fails 0.04030062264654547

(println "my-sqrt2")

(check-within (my-sqrt2 9.0000)  3.000 0.0001) ; ok
(check-within (my-sqrt2 0.0009)  0.030 0.0001) ; ok

; question: could you pick a tolerance as a fraction of x, not guess?

