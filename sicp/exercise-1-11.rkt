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

; fr 3 -> fi 2 1 0 -> 1*2 + 2*1 + 3*0 = 2 + 2 + 0 = 4
;    f n - 1 = 2
;    f n - 2 = 1
;    f n - 3 = 0
; fr 4 -> fi 4 2 1 -> 1*4 + 2*2 + 3*1 = 4 + 4 + 3 = 11
;    f n - 1 = 4
;    f n - 2 = 2
;    f n - 3 = 1

; so...
;
; each successive step,
; - take the previous 3 numbers (c1, c2, c3)
; - calc the new result from them with the formula (r)
; - throw the oldest away (c3)
; - iterate with (r, c1, c2)
; - stop when... iteration-count >= n ?

(define (fi n)
  (define (calculation x y z)
    (+ x (* 2 y) (* 3 z))
    )

  (define (f-loop r1 r2 r3 count)
    (if (= count 0)
      r1
      (f-loop (calculation r1 r2 r3) r1 r2 (- count 1))
      )
    )

  (if (< n 3)
    n

    ; start at n = 3 (so r1, r2, r3 = 2, 1, 0)
    ; after n - 2 iterations, r1 will be the answer
    (f-loop 2 1 0 (- n 2))
    )
  )

(require rackunit)
(require racket/trace)

(trace fr)

(check-equal? (fr 1)  1 "n < 3")
(check-equal? (fr 2)  2 "n < 3")
(check-equal? (fr 3)  4 "f(3) = 1*2 + 2*1 + 3*0 = 2 + 2 + 0 = 4")
(check-equal? (fr 4) 11 "f(4) = 1*4 + 2*2 + 3*1 = 4 + 4 + 3 = 11")
(check-equal? (fr 5) 25 "f(5) = 1*11 + 2*4 + 3*2 = 11 + 8 + 6 = 25")

(trace fi)

(check-equal? (fi 1)  1 "n < 3")
(check-equal? (fi 2)  2 "n < 3")
(check-equal? (fi 3)  4 "f(3) = 1*2 + 2*1 + 3*0 = 2 + 2 + 0 = 4")
(check-equal? (fi 4) 11 "f(4) = 1*4 + 2*2 + 3*1 = 4 + 4 + 3 = 11")
(check-equal? (fi 5) 25 "f(5) = 1*11 + 2*4 + 3*2 = 11 + 8 + 6 = 25")

(displayln "Done")
