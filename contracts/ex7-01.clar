
;; title: ex7-01
;; version: 1.0.0
;; summary: simple token contract

;; traits
;;
(impl-trait .ex7-sip010.sip-010-trait)

;; token definitions
;;

(define-fungible-token SimpleToken u1000000)

;; constants
;;

(define-constant CONTRACT_OWNER tx-sender)
(define-constant SELF (as-contract tx-sender))
(define-constant DECIMALS u6)
(define-constant ERR_UNAUTHORIZED (err u401))

;; public functions
;;

;; restrict transfer to token holder
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq from tx-sender) ERR_UNAUTHORIZED)
    (and (is-some memo) (is-some (print memo)))
    (ft-transfer? SimpleToken amount from to)
  )
)

;; restrict mint to contract owner
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq CONTRACT_OWNER tx-sender) ERR_UNAUTHORIZED)
    (ft-mint? SimpleToken amount recipient)
  )
)

;; restrict burn to token holder
(define-public (burn (amount uint) (burner principal))
  (begin
    (asserts! (is-eq burner tx-sender) ERR_UNAUTHORIZED)
    (ft-burn? SimpleToken amount burner)
  )
)

;; read only functions
;;

(define-read-only (get-name)
  (ok "SimpleToken")
)

(define-read-only (get-symbol)
  (ok "ST")
)

(define-read-only (get-decimals)
  (ok DECIMALS)
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance SimpleToken account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply SimpleToken))
)

(define-read-only (get-token-uri)
  (ok none)
)

;; test cases
;;

;; >> (contract-call? .ex7-01 mint u500 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; {"type":"ft_mint_event","ft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01::SimpleToken","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"500"}}
;; (ok true)
;; >> (contract-call? .ex7-01 mint u100 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
;; {"type":"ft_mint_event","ft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01::SimpleToken","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","amount":"100"}}
;; (ok true)

;; >> (contract-call? .ex7-01 transfer u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 none)
;; {"type":"ft_transfer_event","ft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01::SimpleToken","sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","amount":"100"}}
;; (ok true)
;; >> (contract-call? .ex7-01 transfer u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 (some 0x04)
;; {"type":"contract_event","contract_event":{"contract_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01","topic":"print","value":"(some 0x04)"}}
;; {"type":"ft_transfer_event","ft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01::SimpleToken","sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","amount":"100"}}
;; (ok true)

;; >> ::set_tx_sender STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6
;; tx-sender switched to STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6

;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01 mint u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (err u401)
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01 burn u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (err u401)
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01 transfer u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 none)
;; (err u401)

;; >> ::set_tx_sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
;; tx-sender switched to ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM

;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01 burn u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; {"type":"ft_burn_event","ft_burn_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01::SimpleToken","sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"100"}}
;; (ok true)
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-01 burn u100 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
;; (err u401)