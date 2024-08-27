;; title: ex7-02
;; version: 1.0.0
;; summary: drippity drop

;; traits
;;

(impl-trait .ex7-sip010.sip-010-trait)

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
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant CLAIM_TOO_SOON (err u403))

;; data maps
;;

(define-map LastClaimedAtBlock principal uint)

;; public functions
;;

;; restrict transfer to token holder
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq from tx-sender) ERR_UNAUTHORIZED)
    (and (is-some memo) (is-some (print memo)))
    (ft-transfer? FaucetToken amount from to)
  )
)

;; restrict mint to claim process
(define-public (claim)
  (begin
    ;; verify claim is allowed
    (try! (is-claim-allowed tx-sender))
    ;; set map with current block height
    (map-set LastClaimedAtBlock tx-sender block-height)
    ;; mint tokens to claimant
    (ft-mint? FaucetToken CLAIM_AMOUNT tx-sender)
  )
)

;; restrict burn to token holder
(define-public (burn (amount uint) (burner principal))
  (begin
    (asserts! (is-eq burner tx-sender) ERR_UNAUTHORIZED)
    (ft-burn? FaucetToken amount burner)
  )
)

;; read only functions
;;

;; SIP-010 functions

(define-read-only (get-name)
  (ok TOKEN_NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance FaucetToken account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply FaucetToken))
)

(define-read-only (get-token-uri)
  (ok none)
)

(define-read-only (get-token-info)
  {
    name: (get-name),
    symbol: (get-symbol),
    decimals: (get-decimals),
    balance: (get-balance tx-sender),
    totalSupply: (get-total-supply),
    uri: (get-token-uri)
  }
)

(define-read-only (time-until-next-claim (user principal))
  ;; check if we have a record
  (match (map-get? LastClaimedAtBlock user) lastClaim
    ;; some branch
    (if (> block-height (+ lastClaim BLOCKS_BETWEEN_CLAIMS))
      (some u0)
      (some (- (+ lastClaim BLOCKS_BETWEEN_CLAIMS) block-height))
    )
    ;; none branch
    none
  )
)

;; private functions
;;

(define-private (is-claim-allowed (user principal))
  (match (time-until-next-claim user) time
    ;; some branch
    (if (is-eq time u0)
      (begin
        (print {
          user: user,
          lastClaim: (map-get? LastClaimedAtBlock user),
          blockHeight: block-height,
          unlockHeight: (+ block-height BLOCKS_BETWEEN_CLAIMS),
          time: time
        })
        (ok time)
      )
      CLAIM_TOO_SOON
    )
    ;; none branch
    (ok u0)
  )
)

;; test cases
;;

;; SIP-010 functions

;; >> (contract-call? .ex7-02 get-token-info)
;; (tuple (balance (ok u0)) (decimals (ok u6)) (name (ok "The Faucet")) (symbol (ok "DRIP")) (totalSupply (ok u0)) (uri (ok none)))

;; Claim function

;; >> (contract-call? .ex7-02 claim)
;; {"type":"ft_mint_event","ft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02::FaucetToken","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"100000000"}}
;; (ok true)
;; >> (contract-call? .ex7-02 claim)
;; (err u403)
;; >> (contract-call? .ex7-02 get-balance 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (ok u100000000)

;; >> ::advance_chain_tip 5
;; 5 blocks simulated, new height: 6
;; >> ::set_tx_sender STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6
;; tx-sender switched to STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6

;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 claim)
;; {"type":"ft_mint_event","ft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02::FaucetToken","recipient":"STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6","amount":"100000000"}}
;; (ok true)
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 claim)
;; (err u403)

;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 get-balance 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)
;; (ok u100000000)

;; time-until-next-claim function

;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 time-until-next-claim 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (some u139)
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 time-until-next-claim 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)
;; (some u144)
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 time-until-next-claim 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
;; none

;; transfer function

;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02 transfer u100 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM none)
;; {"type":"ft_transfer_event","ft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02::FaucetToken","sender":"STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"100"}}
;; (ok true)

;; ::set_tx_sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
;; tx-sender switched to ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM

;; >> (contract-call? .ex7-02 transfer u100 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM none)
;; (err u401)

;; >> (contract-call? .ex7-02 transfer u100 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 none)
;; {"type":"ft_transfer_event","ft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02::FaucetToken","sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","amount":"100"}}
;; (ok true)

;; balance checks

;; >> (contract-call? .ex7-02 get-balance 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (ok u100000000)
;; >> (contract-call? .ex7-02 get-balance 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)
;; (ok u99999900)
;; >> (contract-call? .ex7-02 get-balance 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
;; (ok u100)

;; future claims

;; >> ::advance_chain_tip 144
;; 144 blocks simulated, new height: 150

;; >> (contract-call? .ex7-02 claim)
;; {"type":"contract_event","contract_event":{"contract_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02","topic":"print","value":"{blockHeight: u150, lastClaim: (some u1), time: u0, unlockHeight: u294, user: ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM}"}}
;; {"type":"ft_mint_event","ft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex7-02::FaucetToken","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"100000000"}}
;; (ok true)
;; >> (contract-call? .ex7-02 claim)
;; (err u403)
