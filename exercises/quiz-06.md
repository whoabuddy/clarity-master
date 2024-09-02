# Quiz 6: Contract Calling

1. What is the primary function used to call a public function in another contract?

- a) call-contract
- b) contract-call?
- c) invoke-contract
- d) external-call

2. True or False: When making an external contract call, the called contract can modify the calling contract's state directly.

3. Which of the following statements about the `contract-call?` function in Clarity is TRUE?

- a) It can be used to call public functions within the same contract
- b) It can only be used to call functions in other contracts
- c) It allows calling private functions in other contracts
- d) It automatically handles errors from the called function

4. What happens if a `contract-call?` to another contract returns an err response?

- a) The calling contract continues execution
- b) The calling contract throws an exception
- c) Any state changes in the calling contract are aborted
- d) The called contract is terminated

5. What is one way you can handle potential errors from an external contract call in Clarity?

- a) Using try-catch blocks
- b) By using the `err` function
- c) By using `match` expressions to handle ok and err results
- d) By setting a global error handler for the contract

6. What is the purpose of the `as-contract` function when used with the `contract-call?` function?

- a) To call a private function in another contract
- b) To execute the call with the current contract as the sender
- c) To bypass permission checks in the called contract
- d) To convert the response type to a boolean

7. True or False: In Clarity, you can make an external contract call to a contract that hasn't been deployed yet by using its future contract address.

8. What does the `contract-caller` keyword return when used within a contract that was called by another contract?

- a) The principal of the user who initiated the transaction
- b) The principal of the contract making the `contract-call?`
- c) The principal of the current contract
- d) None of the above

**Bonus Coding Challenges**

9. Spot the bug in the following contract. Find and fix the bug to get the test case to pass.

```clojure
(define-constant CONTRACT_OWNER tx-sender)

(define-public (transfer (to principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) (err u401))
    (as-contract (stx-transfer? amount tx-sender to))
  )
)

;; Test cases (replace `your-contract` with your contract address)
;; (contract-call? .your-contract transfer 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 u100)
```

10. Implement a smart contract for a time-locked wallet with the following features:

- A user can deploy the contract and lock tokens with a specified unlock height and beneficiary.
- Anyone can send tokens to the contract.
- The beneficiary can claim the tokens once the specified block height is reached.
- The beneficiary can transfer the right to claim the wallet to a different principal.

```clojure
;; Time-Locked Wallet

;; Constants and Storage
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_ALREADY_LOCKED (err u101))
(define-constant ERR_NOT_UNLOCKED (err u102))

(define-data-var beneficiary (optional principal) none)
(define-data-var unlockHeight uint u0)
(define-data-var balance uint u0)

;; Public Functions

(define-public (lock (newBeneficiary principal) (unlockAt uint) (amount uint))
  ;; Implement the lock function
)

(define-public (claim)
  ;; Implement the claim function
)

(define-public (bestow (newBeneficiary principal))
  ;; Implement the bestow function
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

;; Test cases (uncomment to run)

;; Test: Lock tokens
;; (print (lock tx-sender u100 u1000))
;; (print (get-beneficiary))
;; (print (get-unlock-height))
;; (print (get-balance))

;; Test: Attempt to claim before unlock height
;; (print (claim))

;; Test: Bestow to new beneficiary
;; (define-constant new-beneficiary 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK)
;; (print (bestow new-beneficiary))
;; (print (get-beneficiary))

;; Test: Claim after unlock height (you'll need to advance the block height in your test environment)
;; (print (claim))
;; (print (get-balance))
```
