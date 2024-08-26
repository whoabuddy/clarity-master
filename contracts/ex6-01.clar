
;; title: ex6-01
;; version: 1.0.0
;; summary: Turok: Dinosaur Hunter

;; constants
;;
(define-constant CONTRACT_OWNER tx-sender)
(define-constant SELF (as-contract tx-sender))

;; public functions
;;

;; Bug: there is no bug? details in comments
(define-public (transfer (to principal) (amount uint))
  (begin
    ;; this checks the tx-sender is the contract owner
    ;; it could be done with contract-caller (more secure)
    (asserts! (is-eq tx-sender CONTRACT_OWNER) (err u401))
    ;; this fails with (err u1) as a default (not enough funds)
    ;; we could check the contract balance or validate a principal
    ;; but in its basic form this is a functioning transfer
    (as-contract (stx-transfer? amount tx-sender to))
  )
)

;; Bug: there were no funds in the contract
;; so if we add some, transfer magically works!
(stx-transfer? u100 tx-sender SELF)

;; Test cases (replace `your-contract` with your contract address)
;; (contract-call? .your-contract transfer 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 u100) ;; This should return (ok true)

;; >> (contract-call? .ex6-01 transfer 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 u100)
;; Events emitted
;; {"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex6-01","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","amount":"100","memo":""}}
;; (ok true)