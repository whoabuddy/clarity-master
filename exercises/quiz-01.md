# Quiz 1: Clarity Types and Basic Functions

1.  True or False: In Clarity, all variables must be explicitly typed.

2.  Which of the following is not a valid Clarity type?
    a) uint
    b) principal
    c) float
    d) bool

3.  What is the correct way to define a public function in Clarity?
    a) (public-function (my-function))
    b) (define-public (my-function))
    c) (function-public my-function)
    d) (public my-function)

4.  Which function is used to create a new map in Clarity?
    a) create-map
    b) new-map
    c) define-map
    d) map-define

5.  What does the `tx-sender` keyword represent?
    a) The contract’s address
    b) The current block miner
    c) The sender of the current transaction
    d) The recipient of the current transaction

6.  Which of the following is not a valid Clarity keyword?
    a) get-block-height
    b) block-height
    c) burn-block-height
    d) contract-caller

7.  Which of the following is a valid way to define a constant in Clarity?
    a) (const MY_CONSTANT 42)
    b) (define-constant MY_CONSTANT 42)
    c) (define-data-const MY_CONSTANT 42)
    d) (set-constant MY_CONSTANT 42)

8.  What is the correct way to define a function argument type as a list of integers with a maximum length of 10 in Clarity?
    a) (list 10 int)
    b) (list int 10)
    c) (define-list int 10)
    d) (int-list 10)

**Bonus Coding Challenges**

9. Fix the bug in the following code snippet:

```clarity
(define-read-only (get-todos (list 10 int))
  (print todos)
)

(get-todos (list 1 2 3 4 5))
```

10. Implement a function called `calculate-average` that takes a list of unsigned integers and returns the average as a response type. Handle the case where the list is empty.

```clarity
(define-public (calculate-average (numbers (list 10 uint)))
  ;; Your code here
)

;; Test cases
(calculate-average (list u1 u2 u3))  ;; Should return (ok u2)
(calculate-average (list))  ;; Should return an error response
```

**Hints:**

- Take a look at the `len` function to get the length of a list.
- The `fold` function can be useful for summing up all numbers in the list.
- Remember to handle the case where the list is empty to avoid division by zero.
- Use `if` to check conditions and return appropriate responses.
