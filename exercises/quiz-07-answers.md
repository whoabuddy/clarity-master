# Quiz 7: Fungible Tokens

## Answer Key

1. d) get-max-supply
2. True
3. c) Use unwrap! to extract and print the memo OR d) Use match to conditionally print the memo if it's not none
4. False
5. a) (response uint uint)
6. b) It automatically updates the total supply or c) It can mint tokens to any principal
7. b) The maximum supply must be set using the define-fungible-token function
8. False
9. Code snippet below

```clarity
(define-fungible-token SimpleToken u1000000)

(define-data-var tokenName (string-utf8 32) u"SimpleToken")

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender recipient) (err u401))
    (ft-mint? SimpleToken amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) (err u401))
    (try! (ft-transfer? SimpleToken amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(define-read-only (get-balance (account principal))
  (ft-get-balance SimpleToken account)
)

(define-public (burn (amount uint) (burner principal))
  (begin
    (asserts! (is-eq tx-sender burner) (err u401))
    (ft-burn? SimpleToken amount burner)
  )
)

(define-read-only (get-total-supply)
  (ft-get-supply SimpleToken)
)
```

10. Code snippet below

```clarity
;; Implement your SIP10 contract here (look into the `impl-trait` function)
(impl-trait .contract-1.sip-010-trait)

(define-fungible-token FaucetToken)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant TOKEN_NAME "The Faucet")
(define-constant TOKEN_SYMBOL "DRIP")
(define-constant TOKEN_DECIMALS u6)
(define-constant CLAIM_AMOUNT u100000000) ;; 100 tokens with 6 decimals
(define-constant BLOCKS_BETWEEN_CLAIMS u144) ;; Approximately 24 hours (assuming 10-minute block times)

(define-map LastClaimedAtBlock principal uint)

;; SIP-010 functions
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) (err u4))
    (ft-transfer? FaucetToken amount sender recipient)
  )
)

(define-read-only (get-name)
  (ok TOKEN_NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance FaucetToken who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply FaucetToken))
)

(define-read-only (get-token-uri)
  (ok none)
)

;; Faucet functions
(define-public (claim)
  (let
    (
      (caller tx-sender)
    )
    (asserts! (is-claim-allowed caller) (err u1))
    (try! (ft-mint? FaucetToken CLAIM_AMOUNT caller))
    (map-set LastClaimedAtBlock caller block-height)
    (ok true)
  )
)

(define-read-only (time-until-next-claim (user principal))
  (let
    (
      (lastClaimed (default-to u0 (map-get? LastClaimedAtBlock user)))
      (blocksSinceLastClaim (- block-height last-claimed))
    )
    (if (>= blocksSinceLastClaim BLOCKS_BETWEEN_CLAIMS)
      u0
      (- BLOCKS_BETWEEN_CLAIMS blocksSinceLastClaim)
    )
  )
)

;; Helper functions
(define-private (is-claim-allowed (user principal))
  (let
    (
      (lastClaimed (default-to u0 (map-get? LastClaimedAtBlock user)))
      (blocksSinceLastClaim (- block-height lastClaimed))
    )
    (>= blocksSinceLastClaim BLOCKS_BETWEEN_CLAIMS)
  )
)

;; Test cases (uncomment and run these to check your implementation)

;; Test SIP-010 functions
;; (print (get-name))
;; (print (get-symbol))
;; (print (get-decimals))
;; (print (get-balance tx-sender))
;; (print (get-total-supply))
;; (print (get-token-uri))

;; Test claim function
;; (print (claim))
;; (print (get-balance tx-sender))
;; (print (claim)) ;; Should fail if called twice in a row

;; Test time-until-next-claim function
;; (print (time-until-next-claim tx-sender))

;; Test transfer function
;; (define-constant recipient 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK)
;; (print (transfer u50000000 tx-sender recipient none))
;; (print (get-balance tx-sender))
;; (print (get-balance recipient))

;; Advanced test: Multiple users
;; (define-constant user2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
;; (print (as-contract (transfer CLAIM_AMOUNT tx-sender user2 none)))
;; (print (get-balance user2))
;; (print (as-contract (claim)))
;; (print (as-contract (time-until-next-claim tx-sender)))
```
