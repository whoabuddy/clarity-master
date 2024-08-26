
;; title: ex7-02
;; version:
;; summary:
;; description:

;; traits
;;

;; BUG: NO TRAIT?

;; token definitions
;;

(define-fungible-token FaucetToken)

;; constants
;;

(define-constant CONTRACT_OWNER tx-sender)
(define-constant TOKEN_NAME "The Faucet")
(define-constant TOKEN_SYMBOL "DRIP")
(define-constant TOKEN_DECIMALS u6)
(define-constant CLAIM_AMOUNT u100000000) ;; 100 tokens with 6 decimals
(define-constant BLOCKS_BETWEEN_CLAIMS u144) ;; Approximately 24 hours (assuming 10-minute block times)

;; data vars
;;

;; data maps
;;

(define-map LastClaimedAtBlock principal uint)

;; public functions
;;

;; SIP-010 functions: transfer

(define-public (claim)
  ;; Implement the claim function
  (ok true)
)

;; read only functions
;;

;; SIP-010 functions: get-name, get-symbol, get-decimals, get-balance, get-total-supply, get-token-uri

(define-read-only (time-until-next-claim (user principal))
  ;; Implement the time check function
  u0
)

;; private functions
;;

(define-private (is-claim-allowed (user principal))
  ;; Implement the claim allowance check
  true
)

;; Test cases

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