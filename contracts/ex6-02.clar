
;; title: ex6-02
;; version: 1.0.0
;; summary: Time-Locked Wallet Example

;; Modified slightly based on requirements to eliminate the need for a map
;; of locked tokens and multiple block heights. It's either locked or not
;; and beneficiary can withdraw an amount or the full balance by default.

;; The contract owner retains the ability to use protected function as
;; a backup and as an initial beneficiary. The contract owner can also
;; bestow the beneficiary role to another principal.

;; constants
;;
(define-constant CONTRACT_OWNER tx-sender)
(define-constant SELF (as-contract tx-sender))

(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_ALREADY_LOCKED (err u101))
(define-constant ERR_NOT_UNLOCKED (err u102))
(define-constant ERR_NO_VALUE (err u103))
(define-constant ERR_INVALID_LOCK_HEIGHT (err u104))
(define-constant ERR_NO_BENEFICIARY_SET (err u105))
(define-constant ERR_SAME_ADDRESS (err u106))

;; data vars
;;

(define-data-var beneficiary (optional principal) none)
(define-data-var walletLocked bool false)
(define-data-var unlockHeight uint u0)

;; public functions
;;

(define-public (lock-wallet (unlockAt uint) (newBeneficiary (optional principal)))
  (begin
    ;; check if the caller is the owner or beneficiary
    (asserts! (check-owner-or-beneficiary true) ERR_NOT_AUTHORIZED)
    ;; check if wallet is already locked
    (asserts! (not (var-get walletLocked)) ERR_ALREADY_LOCKED)
    (var-set walletLocked true)
    ;; check that unlock height is valid
    (asserts! (> unlockAt block-height) ERR_INVALID_LOCK_HEIGHT)
    (var-set unlockHeight unlockAt)
    ;; set beneficiary
    (if (is-some newBeneficiary)
      (var-set beneficiary newBeneficiary)
      (var-set beneficiary (some contract-caller))
    )
    ;; print event and return
    (ok (print {
      notification: "wallet-locked",
      payload: {
        unlockHeight: unlockAt,
        beneficiary: (var-get beneficiary),
        tx-sender: tx-sender,
        contract-caller: contract-caller
      }
    }))
  )
)

(define-public (claim-wallet-contents (amount (optional uint)))
  (let
    (
      (locked (var-get walletLocked))
      (recipient (unwrap! (var-get beneficiary) ERR_NO_BENEFICIARY_SET))
    )
    ;; check if the caller is the owner or beneficiary
    (asserts! (check-owner-or-beneficiary true) ERR_NOT_AUTHORIZED)
    ;; check if wallet is already locked
    ;; or if unlock height is in the past
    (asserts! (or (not locked) (< (var-get unlockHeight) block-height)) ERR_ALREADY_LOCKED)
    ;; reset lock status if needed
    (and locked (var-set walletLocked false))
    ;; transfer amount if specified or balance if not
    (if (is-some amount)
      (as-contract (try! (stx-transfer? (unwrap! amount ERR_NO_VALUE) SELF recipient)))
      (as-contract (try! (stx-transfer? (stx-get-balance SELF) SELF recipient)))
    )
    ;; print event and return
    (ok (print {
      notification: "wallet-contents-claimed",
      payload: {
        amount: amount,
        recipient: recipient,
        tx-sender: tx-sender,
        contract-caller: contract-caller
      }
    }))
  )
)

(define-public (bestow (newBeneficiary principal))
  (begin
    ;; check if the caller is the owner or beneficiary
    (asserts! (check-owner-or-beneficiary true) ERR_NOT_AUTHORIZED)
    ;; check that beneficiary is empty 
    ;; or the caller isn't already the beneficiary
    (asserts! (or
      (is-none (var-get beneficiary))
      (not (is-eq (unwrap-panic (var-get beneficiary)) newBeneficiary))
    ) ERR_SAME_ADDRESS)
    ;; set new beneficiary
    (var-set beneficiary (some newBeneficiary))
    ;; print event and return
    (ok (print {
      notification: "beneficiary-bestowed",
      payload: {
        newBeneficiary: newBeneficiary,
        tx-sender: tx-sender,
        contract-caller: contract-caller
      }
    }))
  )
)

;; read only functions
;;

(define-read-only (get-owner)
  (ok CONTRACT_OWNER)
)

(define-read-only (get-beneficiary)
  (ok (var-get beneficiary))
)

(define-read-only (get-lock-status)
  (ok (var-get walletLocked))
)

(define-read-only (get-unlock-height)
  (ok (var-get unlockHeight))
)

(define-read-only (get-balance)
  (stx-get-balance SELF)
)

(define-read-only (get-all-info)
  (ok {
    owner: (get-owner),
    beneficiary: (get-beneficiary),
    locked: (get-lock-status),
    unlockHeight: (get-unlock-height),
    balance: (get-balance)
  })
)

;; private functions
;;
(define-private (check-owner (strict bool))
  (if strict
    (is-eq CONTRACT_OWNER contract-caller)
    (is-eq CONTRACT_OWNER tx-sender)
  )
)

(define-private (check-beneficiary (strict bool))
  (if strict
    (is-eq (unwrap! (var-get beneficiary) false) contract-caller)
    (is-eq (unwrap! (var-get beneficiary) false) tx-sender)
  )
)

(define-private (check-owner-or-beneficiary (strict bool))
  (if strict
    (or (check-owner true) (check-beneficiary true))
    (or (check-owner false) (check-beneficiary false))
  )
)

;; Test cases
;; 

;; fund contract
(stx-transfer? u1000000000 tx-sender SELF)


;; lock wallet
;; (contract-call? .ex6-02 lock-wallet u10000 none)
;; (ok (tuple (notification "wallet-locked") (payload (tuple (beneficiary (some ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)) (contract-caller ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) (tx-sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) (unlockHeight u10000)))))

;; get all info (should show locked: true)
;; (contract-call? .ex6-02 get-all-info)
;; (ok (tuple (balance u1000000000) (beneficiary (ok (some ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))) (locked (ok true)) (owner (ok ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)) (unlockHeight (ok u10000))))

;; attempt claim too early
;; (contract-call? .ex6-02 claim-wallet-contents none)
;; (err u101) ERR_ALREADY_LOCKED

;; update beneficiary
;; (contract-call? .ex6-02 bestow 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK)
;; (ok (tuple (notification "beneficiary-bestowed") (payload (tuple (contract-caller ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) (newBeneficiary ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK) (tx-sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)))))

;; ::advance_chain_tip 10001
;; 10001 blocks simulated, new height: 10002

;; claim from random address (fails)
;; ::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5
;; (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex6-02 claim-wallet-contents none)
;; (err u100) ERR_NOT_AUTHORIZED

;; claim from contract owner (succeeds)
;; ::set_tx_sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
;; (contract-call? .ex6-02 claim-wallet-contents (some u100))
;; (ok (tuple (notification "wallet-contents-claimed") (payload (tuple (amount (some u100)) (contract-caller ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) (recipient ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK) (tx-sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)))))

;; claim remaining balance from new beneficiary
;; ::set_tx_sender ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK
;; (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex6-02 claim-wallet-contents none)
;; (ok (tuple (notification "wallet-contents-claimed") (payload (tuple (amount none) (contract-caller ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK) (recipient ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK) (tx-sender ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK)))))

;; get all info
;; (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex6-02 get-all-info)
;; (ok (tuple (balance u0) (beneficiary (ok (some ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK))) (locked (ok false)) (owner (ok ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)) (unlockHeight (ok u10000))))