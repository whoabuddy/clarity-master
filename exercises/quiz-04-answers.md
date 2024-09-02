# Quiz 4: Tuples and Lists

## Answer Key

1. d) Both a and b
2. True
3. c) (element-at? my-list u0)
4. b) append
5. a) The contract is trying to access or set a tuple field that doesn't exist
6. c) Use a single map with a tuple to store all user information
7. False
8. b) u5
9. Code snippet below

```clarity
;; Implement the person-tuple-to-list function here
(define-read-only (person-tuple-to-list (person (tuple (name (string-ascii 50)) (age uint))))
  (list (get name person) (int-to-ascii (get age person)))
)

;; Test cases
(person-tuple-to-list (tuple (name "Bob") (age u25))) ;; Should return (ok (list "Bob" u25))
(person-tuple-to-list (tuple (name "Alice") (age u30))) ;; Should return (ok (list "Alice" u30))
```

10. Code snippet below

```clarity
(define-data-var recentTodos (list 5 (string-ascii 50)) (list))

(define-public (add-todo (todo (string-ascii 50)))
  (let
    (
      (currentTodos (var-get recentTodos))
      (newTodos (unwrap! (as-max-len? (append currentTodos todo) u5) (err u1)))
    )
    (var-set recentTodos newTodos)
    (ok newTodos)
  )
)

;; Test cases
(add-todo "Buy groceries")
(add-todo "Call mom")
(add-todo "Finish report")
(add-todo "Go to gym")
(add-todo "Read book")
(add-todo "Learn Clarity") ;; This should return an error
```
