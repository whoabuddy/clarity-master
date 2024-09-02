# Quiz 1: Clarity Types and Basic Functions

## Answer Key

1. True
2. c) float
3. b) (define-public (my-function))
4. c) define-map
5. c) The sender of the current transaction
6. a) get-block-height
7. b) (define-constant MY_CONSTANT 42)
8. a) (list 10 int)
9. Code snippet below

```clarity
(define-read-only (get-todos (todos (list 10 int)))
  (print todos)
)

(get-todos (list 1 2 3 4 5))
```

10. Code snippet below

```clarity
(define-public (calculate-average (numbers (list 10 uint)))
  (let
    (
      (listLength (len numbers))
      (sum (fold + numbers u0))
    )
    (if (> listLength u0)
      (ok (/ sum listLength))
      (err u1)
    )
  )
)

(calculate-average (list u1 u2 u3))
(calculate-average (list))
```
