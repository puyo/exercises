#lang racket/base

; Exercise 1.11.
; A function f is defined by the rule that f(n)=n if n<3 and
; f(n)=f(n−1)+2f(n−2)+3f(n−3) if n>3. Write a procedure that computes f by
; means of a recursive process.

; recursive

(define (fr n)
  (if (< n 3)
    n
    (+
      (fr (- n 1))
      (* 2 (fr (- n 2)))
      (* 3 (fr (- n 3)))
      )
    )
  )

; iterative

; f 3 2 1 0 -> 1*2 + 2*1 + 3*0 = 4
;    f n - 1 = 3
;    f n - 2 = 2
;    f n - 3 = 1
; f 4 2 1 0 ->
;    f n - 1 = 4
;    f n - 2 = 3
;    f n - 3 = 2

; so...
;
; each successive step,
; - take the previous 3 numbers (c1, c2, c3)
; - calc the new result from them with the formula (r)
; - throw the oldest away (c3)
; - iterate with (r, c1, c2)
; - stop when... iteration-count >= n ?

(define (fi n)
  (define (calc x y z)
    (+ x (* 2 y) (* 3 z))
    )

  (define (f-iter result c1 c2 c3 count)
    (if (= count 0)
      (calc c1 c2 c3)
      (f-iter n (calc c1 c2 c3) c1 c2 (- count 1))
      )
    )

  (if (< n 3)
    n
    (f-iter 3 2 1 0 (- n 3))
    )
  )

(require rackunit)

(check-equal? (fr 1)  1 "n < 3")
(check-equal? (fr 2)  2 "n < 3")
(check-equal? (fr 3)  4 "f(3) = 1*2 + 2*1 + 3*0 = 2 + 2 + 0 = 4")
(check-equal? (fr 4) 11 "f(4) = 1*4 + 2*2 + 3*1 = 4 + 2 + 3 = 11")
(check-equal? (fr 5) 25 "f(5) = 1*11 + 2*4 + 3*2 = 11 + 8 + 6 = 25")

(require racket/trace)
(trace fi)

(check-equal? (fi 1)  1 "n < 3")
(check-equal? (fi 2)  2 "n < 3")
(check-equal? (fi 3)  4 "f(3) = 1*2 + 2*1 + 3*0 = 2 + 2 + 0 = 4")
(check-equal? (fi 4) 11 "f(4) = 1*4 + 2*2 + 3*1 = 4 + 2 + 3 = 11")
(check-equal? (fi 5) 25 "f(5) = 1*11 + 2*4 + 3*2 = 11 + 8 + 6 = 25")

(displayln "Done")
