# Quiz 5: Public, Private, and Read-only Functions

## Answer Key

1. d) Both a and b
2. d) Both a and b
3. b) To execute code with the contract's principal as the tx-sender
4. True
5. c) Directly interacting with other contracts
6. a) It will throw a runtime error
7. b) By implementing a check on the sender and a stored principal representing the owner
8. True
9. Code snippet below

```clarity
(define-data-var txLog (list 100 uint) (list))

(define-public (add-tx (amount uint))
  (let
    (
      (newLog (unwrap! (as-max-len? (append (var-get txLog) amount) u100) (err u1)))
    )
    (begin
      (var-set txLog newLog)
      (ok true)
    )
  )
)

(define-read-only (get-last-tx)
  (let
    (
      (logLength (len (var-get txLog)))
    )
    (if (> logLength u0)
      (ok (element-at? (var-get txLog) (- logLength u1)))
      (err u0)
    )
  )
)

(define-public (clear-log)
  (begin
    (var-set txLog (list))
    (ok true)
  )
)

(define-public (get-tx-count)
  (ok (len (var-get txLog)))
)
```

10. Code snippet below

```clarity
(define-constant CONTRACT_OWNER tx-sender)

(define-private (check-owner)
  (is-eq tx-sender CONTRACT_OWNER)
)

(define-public (withdraw (amount uint))
  (begin
    (asserts! (check-owner) (err u1))
    (as-contract (stx-transfer? amount tx-sender CONTRACT_OWNER))
  )
)

;; Test cases (NOTE: change `.your-contract` to the name of your contract, eg `contract-0`, etc)
(stx-transfer? u100 tx-sender .your-contract) ;; transfer funds to the contract for testing withdraw
(contract-call? .your-contract withdraw u100) ;; Should succeed if called by owner
(as-contract (contract-call? .your-contract withdraw u100)) ;; Should fail
```
