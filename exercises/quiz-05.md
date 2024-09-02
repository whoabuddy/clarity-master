# Quiz 5: Public, Private, and Read-only Functions

1. Which of the following statements about `public`, `private`, and `read-only` functions in Clarity is true?

- a) Public functions can be called from other contracts, private functions cannot
- b) Read-only functions can not modify contract state
- c) Private functions can be called directly
- d) Both a and b

2. Which of the following is true regarding public functions and a read-only functions in Clarity?

- a) Public functions can modify state, read-only functions cannot
- b) Public functions must return a response type, read-only functions can return any type
- c) Public functions can be called from other contracts, read-only cannot
- d) Both a and b

3. When would you use the `as-contract` function?

- a) To call a private function from outside the contract
- b) To execute code with the contract's principal as the `tx-sender`
- c) To convert a public function to a read-only function
- d) To bypass permission checks in other contracts

4. True or False: In Clarity, private functions can call public functions within the same contract.

5. Which of the following is NOT a valid use case for a private function in Clarity?

- a) Implementing helper functions for internal use
- b) Performing complex calculations before returning a result
- c) Directly interacting with other contracts
- d) Modifying internal contract state

6. What happens if a `read-only` function attempts to modify contract state?

- a) It will throw a runtime error
- b) The state change will be ignored
- c) It will fail at compile-time
- d) The function will be automatically converted to a public function

7. In Clarity, how can you ensure that only the contract owner can call a specific public function?

- a) By using the `private` keyword
- b) By implementing a check on the `sender` and a stored principal representing the owner
- c) By using the `as-contract` function for the contract owner
- d) By marking the function as private with `define-private`

8. True or False: Public functions in Clarity can call other public functions using `contract-call?`.

**Bonus Coding Challenges**

9. Fix the bugs in the following code snippet:

```clojure
(define-data-var txLog (list 100 uint) (list))

(define-public (add-tx (amount uint))
  (var-set txLog (append txLog amount))
  (ok true)
)

(define-read-only (get-last-tx)
  (let
    (
      (logLength (len txLog))
    )
    (if (> logLength u0)
      (ok (element-at? txLog (- logLength u1)))
      (err u0)
    )
  )
)

(define-private (clear-log)
  (var-set txLog (list))
  (print "Log cleared")
)

(define-public (get-tx-count)
  (ok (len txLog))
)
```

10. Implement a public function called `withdraw` that allows only the contract owner to withdraw funds from the contract. Use a private function to check if the caller is the owner.

```clojure
(define-constant CONTRACT_OWNER tx-sender)

(define-private (check-owner)
  ;; Your code here
)

(define-public (withdraw (amount uint))
  ;; Your code here
)

;; Test cases (NOTE: change `.your-contract` to the name of your contract, eg `contract-0`, etc)
(stx-transfer? u100 tx-sender .your-contract) ;; transfer funds to the contract for testing withdraw
(contract-call? .your-contract withdraw u100) ;; Should succeed if called by owner
(as-contract (contract-call? .your-contract withdraw u100)) ;; Should fail
```
