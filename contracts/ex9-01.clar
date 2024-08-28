
;; title: ex9-01
;; version: 1.0.0
;; summary: no arg names but type specific

;; traits
;;
(impl-trait .ex9-token-trait.token-trait)

;; token definitions
;;
(define-fungible-token ClarityToken)

;; public functions
;;

;; BUG: trait specified (uint principal principal) for type signature
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  ;; also didn't need a begin (single arg, returns ok/err)
  ;; but technically this would be wide open anyway
  (ft-transfer? ClarityToken amount sender recipient)
)

;; read only functions
;;

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance ClarityToken account))
)

;; Test cases
(define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; Mint some tokens for testing
(ft-mint? ClarityToken u1000 WALLET_1)

;; run tests using print
(print {
  a: (get-balance WALLET_1),
  b: (transfer u69 WALLET_1 WALLET_2),
  c: (get-balance WALLET_1),
  d: (get-balance WALLET_2),
})
