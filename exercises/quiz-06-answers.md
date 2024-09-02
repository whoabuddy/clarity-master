# Quiz 6: Contract Calling

## Answer Key

1. b) contract-call?
2. False
3. b) It can only be used to call functions in other contracts
4. c) Any state changes in the calling contract are aborted
5. c) By using match expressions to handle ok and err results
6. b) To execute the call with the current contract as the sender
7. False
8. b) The principal of the contract making the contract-call?
9. Code snippet below

```clarity
(define-constant CONTRACT_OWNER tx-sender)

(define-public (transfer (to principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) (err u401))
    (stx-transfer? amount tx-sender to)
  )
)

(contract-call? .your-contract transfer 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 u100)
```

10. Code snippet below

```clarity
;; Time-Locked Wallet

;; Constants and Storage
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_ALREADY_LOCKED (err u101))
(define-constant ERR_NOT_UNLOCKED (err u102))
(define-constant ERR_NO_VALUE (err u103))

(define-data-var beneficiary (optional principal) none)
(define-data-var unlockHeight uint u0)
(define-data-var balance uint u0)

;; Public Functions

(define-public (lock (newBeneficiary principal) (unlockAt uint) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) ERR_NOT_AUTHORIZED)
    (asserts! (is-none (var-get beneficiary)) ERR_ALREADY_LOCKED)
    (asserts! (> amount u0) ERR_NO_VALUE)
    (asserts! (> unlockAt block-height) ERR_ALREADY_LOCKED)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set beneficiary (some newBeneficiary))
    (var-set unlockHeight unlockAt)
    (var-set balance amount)
    (ok true))
)

(define-public (claim)
  (let
    (
      (currentBeneficiary (unwrap! (var-get beneficiary) ERR_NOT_AUTHORIZED))
      (currentBalance (var-get balance))
    )
    (asserts! (is-eq currentBeneficiary tx-sender) ERR_NOT_AUTHORIZED)
    (asserts! (>= block-height (var-get unlockHeight)) ERR_NOT_UNLOCKED)
    (asserts! (> currentBalance u0) ERR_NO_VALUE)
    (var-set balance u0)
    (as-contract (stx-transfer? currentBalance tx-sender currentBeneficiary)))
)

(define-public (bestow (newBeneficiary principal))
  (begin
    (asserts! (is-eq (some tx-sender) (var-get beneficiary)) ERR_NOT_AUTHORIZED)
    (var-set beneficiary (some newBeneficiary))
    (ok true)
  )
)

;; Read-only Functions

(define-read-only (get-beneficiary)
  (ok (var-get beneficiary))
)

(define-read-only (get-unlock-height)
  (ok (var-get unlockHeight))
)

(define-read-only (get-balance)
  (ok (var-get balance))
)

;; Test cases

;; Test: Lock tokens
;; (print (lock tx-sender u100 u1000))
;; (print (get-beneficiary))
;; (print (get-unlock-height))
;; (print (get-balance))

;; Test: Attempt to claim before unlock height
;; (print (claim))

;; Test: Bestow to new beneficiary
;; (define-constant NEW_BENEFICIARY 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK)
;; (print (bestow NEW_BENEFICIARY))
;; (print (get-beneficiary))

;; Test: Claim after unlock height (you'll need to advance the block height in your test environment)
;; (print (claim))
;; (print (get-balance))
```
