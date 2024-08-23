;; title: ex4-01
;; version: 1.0.0
;; summary: Personable tuples and lists

;; public functions
;;

;; input: a person tuple
;; output: a person list
(define-public (person-tuple-to-list (person (tuple (name (string-ascii 50)) (age uint))))
  (let
    (
      (nameString (get name person))
      (ageString (int-to-ascii (get age person)))
    )
    (ok (list nameString ageString))
  )
)

;; let's try to golf it!
(define-public (p-to-l (p { n: (string-ascii 50), a: uint }))
  (ok (list (get n p) (int-to-ascii (get a p))))
)

;; test cases
(person-tuple-to-list (tuple (name "Bob") (age u25))) ;; Should return (ok (list "Bob" u25))
(person-tuple-to-list (tuple (name "Alice") (age u30))) ;; Should return (ok (list "Alice" u30))
(p-to-l {n: "Chad", a: u69}) ;; Should return Chuck Norris
