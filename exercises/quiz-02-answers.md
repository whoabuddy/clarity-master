# Quiz 2: Control Flow and Error Handling

## Answer Key

1. c) if
2. False
3. c) (asserts! (is-eq 1 2) (err u1))
4. c) (err u1)
5. a) To extract a value from an option type OR c) To unpack a response type, returning the value or throwing an error
6. a) is-ok
7. b) Evaluate and de-structure optional and response types
8. d) (none u4)
9. Code snippet below

```clarity
;; This function always returns an ok response
(define-public (say-hello)
  (ok "Hello")
)

;; This function attempts to match on a response with an indeterminate err type
(define-public (execute)
  (let
    (
      (result (say-hello))
    )
    (if (is-ok result)
      result
      (err u1)
    )
  )
)

;; Test cases
(execute) ;; Should return (ok "Hello")
```

10. Code snippet below

```clarity
(define-public (process-transaction (amount uint))
  (if (and (>= amount u10) (<= amount u1000))
    (ok "Transaction processed")
    (err (if (< amount u10) u1 u2))
  )
)

;; Test cases
(process-transaction u5)    ;; Should return (err u1)
(process-transaction u50)   ;; Should return (ok "Transaction processed")
(process-transaction u1500) ;; Should return (err u2)
```
