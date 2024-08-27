
;; title: ex8-01
;; version: 1.0.0
;; summary:

;; traits
;;
(impl-trait .ex8-sip009.nft-trait)

;; token definitions
;;

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;;


(define-non-fungible-token CoolNFT uint)

(define-public (transfer-nft (tokenId uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u1))
    (try! (nft-transfer? CoolNFT tokenId sender recipient))
  )
)

;; Tests (uncomment and run these to check your solution)
;; (define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; (nft-mint? CoolNFT u1 WALLET_1)
;; (transfer-nft u1 WALLET_1 WALLET_2) ;; This should return (ok true)
;; (nft-get-owner? CoolNFT u1) ;; This should return (ok WALLET_2)
