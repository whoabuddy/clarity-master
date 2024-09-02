# Quiz 9: Traits and Implementations

## Answer Key

1. True
2. a) define-trait
3. False
4. c) Asserts that the contract implements a specific trait
5. True
6. b) use-trait
7. d) `<trait-name>`
8. True
9. Code snippet below

```clarity
;; Define a trait for a basic token
;;(define-trait token-trait
;;  (
;;    (get-balance (principal) (response uint uint))
;;    (transfer (uint principal principal) (response bool uint))
;;  )
;;)

;; Uncomment the code below to fix the error

;; Implement your trait
;; (impl-trait .contract-0.token-trait)

;; (define-fungible-token ClarityToken)

;; (define-read-only (get-balance (account principal))
;;   (ok (ft-get-balance ClarityToken account))
;; )

;; ;; BUG: trait specified (uint principal principal) for type signature
;; (define-public (transfer (amount uint) (sender principal) (recipient principal))
;;   ;; also didn't need a begin (single arg, returns ok/err)
;;   ;; but technically this would be wide open anyway
;;   (ft-transfer? ClarityToken amount sender recipient)
;; )
```

10. Code snippet below

```clarity
(use-trait sip9 .contract-0.sip9-trait)

(define-public (get-owner-of-nft (nftContract <sip9>) (tokenId uint))
  (match (contract-call? nftContract get-owner tokenId)
    ownerPrincipal (ok (unwrap-panic ownerPrincipal))
    err (err u401)
  )
)

;; Test cases
;; (define-constant NFT_CONTRACT 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.my-sip9-nft)
;; (get-owner-of-nft NFT_CONTRACT u1) ;; Should return (ok nftOwnerPrincipal)
```
