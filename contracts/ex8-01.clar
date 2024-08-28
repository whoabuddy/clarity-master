
;; title: ex8-01
;; version: 1.0.0
;; summary: understanding control flows

;; traits
;;
;; (impl-trait .ex8-sip009.nft-trait)

;; token definitions
;;
(define-non-fungible-token CoolNFT uint)

;; public functions
;;
(define-public (transfer-nft (tokenId uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u1))
    ;; try unwraps the return value and throws an error if there is one
    ;; since the return value is already (ok true) or error, we can run it directly
    ;; if we remove the try, the function will return the result of nft-transfer?
    (nft-transfer? CoolNFT tokenId sender recipient)
  )
)

;; Tests (uncomment and run these to check your solution)
(define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

(print {
  step-1: (nft-mint? CoolNFT u1 WALLET_1),
  step-2: (transfer-nft u1 WALLET_1 WALLET_2),
  step-3: (nft-get-owner? CoolNFT u1)
})

