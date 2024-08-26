
;; title: ex5-02
;; version: 1.0.0
;; summary: So much to do, so much to see, so what's wrong with taking the back streets?

;; constants
;;
(define-constant CONTRACT_OWNER tx-sender)
(define-constant SELF (as-contract tx-sender))
(define-constant ERR_NOT_OWNER (err u403))
(define-constant ERR_INSUFFICIENT_FUNDS (err u404))

;; public functions
;;

(define-public (deposit (amount uint))
  (begin
    (print  { notifcation: "deposit", payload: { amount: amount, contract-caller: contract-caller, tx-sender: tx-sender } })
    (stx-transfer? amount tx-sender SELF)
  )
)

(define-public (withdraw (amount uint))
  (begin
    (asserts! (check-owner true) ERR_NOT_OWNER)
    (asserts! (> (stx-get-balance SELF) amount) ERR_INSUFFICIENT_FUNDS)
    (print  { notifcation: "withdraw", payload: { amount: amount, contract-caller: contract-caller, tx-sender: tx-sender } })
    (as-contract (stx-transfer? amount SELF CONTRACT_OWNER))
  )
)

;; read only functions
;;
(define-read-only (get-contract-balance)
  (stx-get-balance SELF)
)

;; private functions
;;

(define-private (check-owner (strict bool))
  (if strict
    (is-eq CONTRACT_OWNER contract-caller)
    (is-eq CONTRACT_OWNER tx-sender)
  )
)

;; fund contract
(deposit u10000000)
