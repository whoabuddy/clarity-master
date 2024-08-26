
;; title: ex7-01
;; version:
;; summary:
;; description:

;; traits
;;

;; BUG: NO TRAIT?

;; token definitions
;;

(define-fungible-token SimpleToken u1000000)

;; constants
;;

;; data vars
;;

(define-data-var tokenName (string-utf8 32) u"SimpleToken")

;; data maps
;;

;; public functions
;;

(define-public (mint (amount uint) (recipient principal))
  (ft-mint? SimpleToken amount recipient)
)


(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? SimpleToken amount sender recipient)
)

(define-public (burn (amount uint) (burner principal))
  (ft-burn? SimpleToken amount burner)
)

;; read only functions
;;

(define-read-only (get-balance (account principal))
  (ft-get-balance SimpleToken account)
)

(define-read-only (get-total-supply)
  (ft-get-supply SimpleToken)
)

;; private functions
;;

;; Test cases
;; (mint u100 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) ;; This should fail
;; (burn u10 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) ;; This should fail