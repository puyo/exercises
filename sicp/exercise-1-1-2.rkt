#lang racket

(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))

(define a 3)

(define b (+ a 1))

(+ a b (* a b))

(= a b)

