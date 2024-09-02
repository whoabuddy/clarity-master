# Quiz 7: Fungible Tokens

1. Which of the following is NOT a required function in the SIP-010 fungible token standard?

- a) `get-name`
- b) `get-symbol`
- c) `get-decimals`
- d) `get-max-supply`

2. True or False: In a SIP-010 compliant fungible token contract, the transfer function **_can_** be called by any `principal` to transfer tokens they do not own.

3. When implementing a SIP-010 fungible token, what is the correct way to handle the memo parameter in the transfer function?

- a) Always print the memo, even if it's `none`
- b) Ignore the memo parameter entirely
- c) Use `unwrap!` to extract and print the memo
- d) Use `match` to conditionally print the memo if it's not none

4. True or False: In Clarity, it's possible to implement a token contract where the total supply can be increased after the initial deployment without using an explicit mint function.

5. In a SIP-010 compliant fungible token contract, what should the get-balance function return?

- a) (response uint uint)
- b) uint
- c) (optional uint)
- d) (response (optional uint) uint)

6. Which of the following is TRUE about the ft-mint? function in Clarity?

- a) It can only be called by the contract owner
- b) It automatically updates the total supply
- c) It can mint tokens to any principal
- d) It returns a boolean indicating success or failure

7. Which of the following statements about setting a maximum supply for a fungible token in Clarity is TRUE?

- a) A separate `set-max-supply` function must be implemented to limit the total supply
- b) The maximum supply must be set using the `define-fungible-token` function
- c) The maximum supply can be dynamically adjusted after contract deployment
- d) Clarity does not allow setting a maximum supply for fungible tokens

8. True or False: In a Clarity fungible token contract, it's possible to mint tokens beyond the maximum supply if the define-fungible-token function is called with a maximum supply parameter.

**Bonus Coding Challenges**

9. Here's a buggy fungible token contract. Your task is to make the provided test cases fail.

```clojure
(define-fungible-token SimpleToken u1000000)

(define-data-var tokenName (string-utf8 32) u"SimpleToken")

(define-public (mint (amount uint) (recipient principal))
  (ft-mint? SimpleToken amount recipient)
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? SimpleToken amount sender recipient)
)

(define-read-only (get-balance (account principal))
  (ft-get-balance SimpleToken account)
)

(define-public (burn (amount uint) (burner principal))
  (ft-burn? SimpleToken amount burner)
)

(define-read-only (get-total-supply)
  (ft-get-supply SimpleToken)
)

;; Test cases
;; (mint u100 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) ;; This should fail
;; (burn u10 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) ;; This should fail
```

10. Create an implementation of a token faucet that allows users to claim a certain amount of tokens, but with a time-based limit

```clojure
;; Define your SIP10 trait (and make sure to deploy it first)
;; Implement your SIP10 contract here (look into the `impl-trait` function)

(define-fungible-token FaucetToken)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant TOKEN_NAME "The Faucet")
(define-constant TOKEN_SYMBOL "DRIP")
(define-constant TOKEN_DECIMALS u6)

(define-map LastClaimedAtBlock principal uint)

;; SIP-010 functions
;; Implement: transfer, get-name, get-symbol, get-decimals, get-balance, get-total-supply, get-token-uri

;; Faucet functions
(define-public (claim)
  ;; Implement the claim function
)

(define-read-only (time-until-next-claim (user principal))
  ;; Implement the time check function
)

;; Helper functions
(define-private (is-claim-allowed (user principal))
  ;; Implement the claim allowance check
)
```

Here are the requirements:

- Use the SIP-010 fungible token standard.
- Implement a faucet function that allows users to claim 100 tokens.
- Users can only claim tokens once every 24 hours.
- Keep track of the last claim time for each user.
- Implement a function to check when a user can claim again.
