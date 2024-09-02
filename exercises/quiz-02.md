# Quiz 2: Control Flow and Error Handling

1. Which keyword is used for conditional branching in Clarity?

- a) if-else
- b) switch
- c) if
- d) condition

2. True or False: Clarity supports try-catch blocks for error handling.

3. In Clarity, what is a correct usage of the `asserts!` function in a public function?

- a) (asserts! (is-eq 1 1) false)
- b) (asserts! (is-eq 1 2))
- c) (asserts! (is-eq 1 2) (err u1))
- d) Both a or c

4. Which of the following is the correct way to return an error in a public function?

- a) (return-error u1)
- b) (throw-error u1)
- c) (err u1)
- d) (error u1)

5. What is the purpose of the `unwrap!` function in Clarity?

- a) To extract a value from an option type
- b) To handle errors in a try-catch block
- c) To unpack a response type, returning the value or throwing an error
- d) To convert a string to a number

6. Which function is used to check if a response is an "ok" value?

- a) is-ok
- b) check-ok
- c) ok?
- d) response-ok

7. In Clarity, what does the `match` expression do?

- a) Compares two values for equality
- b) Evaluate and de-structure optional and response types
- c) Executes a loop until a condition is met
- d) Defines a new function

8. Which of the following is NOT a valid response type in Clarity?

- a) (ok u1)
- b) (err u2)
- c) (some u3)
- d) (none u4)

**Bonus Coding Challenges**

9. The following code causes an indeterminate error. Resolve the issue inside of `execute` by using the `is-ok` function.

```clojure
;; This function always returns an ok response
(define-public (say-hello)
  (ok "Hello")
)

;; This function attempts to match on a response with an indeterminate err type
(define-public (execute)
  (match (say-hello)
    success (ok success)
    error (err error)
  )
)

;; Test cases
(execute) ;; Should return (ok "Hello")
```

10. Implement a function called `process-transaction` that takes an unsigned integer amount as input. The function should:

- Check if the amount is between 10 and 1000 (inclusive).
- If it is, return an `ok` response with the message “Transaction processed”.
- If it’s less than 10, return an `err` with code `u1`.
- If it’s greater than 1000, return an `err` with code `u2`.

```clojure
(define-public (process-transaction (amount uint))
  ;; Your code here
)

;; Test cases
(process-transaction u5)    ;; Should return (err u1)
(process-transaction u50)   ;; Should return (ok "Transaction processed")
(process-transaction u1500) ;; Should return (err u2)
```

**Hints:**

- You can use `if` or `match` for conditional branching.
- Remember to use the `u` prefix for uint literals.
- The `and` function can be useful for checking multiple conditions.
- Use `ok` and `err` to construct response types.
