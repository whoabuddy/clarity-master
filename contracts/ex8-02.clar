
;; title: ex8-02
;; version: 1.0.0
;; summary: nft lottery contract

;; traits
;;
(impl-trait .ex8-sip009.nft-trait)

;; token definitions
;;
(define-non-fungible-token LotteryTicket uint)

;; constants
;;

(define-constant SELF (as-contract tx-sender))

(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_BEFORE_FIRST_ROUND (err u402))
(define-constant ERR_ROUND_NOT_OVER (err u403))
(define-constant ERR_WINNER_NOT_SELECTED (err u404))
(define-constant ERR_WINNER_ALREADY_SELECTED (err u405))
(define-constant ERR_ROUND_ALREADY_CLAIMED (err u406))
(define-constant ERR_NO_ROUND_DATA (err u407))

;; data vars
;;

(define-data-var lastId uint u1) ;; for NFT IDs

(define-data-var ticketCount uint u0) ;; for total NFTs
(define-data-var ticketPrice uint u1000000) ;; 1 STX

(define-data-var lotteryPeriod uint u144) ;; 144 blocks (~1 day)s
(define-data-var lotteryStartHeight uint block-height) ;; start when deployed

;; data maps
;;

;; track stats per round
(define-map LotteryRounds
  uint
  {
    firstNftId: uint,
    stxInPool: uint,
    ticketsSold: uint,
    winner: (optional principal),
    claimed: bool
  }
)

;; track stats per user
(define-map UserStats
  principal
  {
    lastRound: uint,
    totalStxSpent: uint,
    totalTickets: uint,
    totalWon: uint,
  }
)

;; track stats per user per round
(define-map UserRounds
  { user: principal, round: uint }
  { tickets: uint, stxSpent: uint }
)

;; public functions
;;

(define-public (buy-ticket)
  (let
    (
      (round (get-lottery-round))
      (price (var-get ticketPrice))
      (tokenId (var-get lastId))
      (roundStats (map-get? LotteryRounds round))
      (userStats (map-get? UserStats contract-caller))
      (userRoundStats (map-get? UserRounds { user: contract-caller, round: round }))
    )
    ;; update data vars
    (var-set lastId (+ tokenId u1))
    (var-set ticketCount (+ (var-get ticketCount) u1))
    ;; update lottery stats
    (if (is-none roundStats)
      (map-set LotteryRounds round {
        firstNftId: tokenId,
        stxInPool: price,
        ticketsSold: u1,
        winner: none,
        claimed: false
      })
      (map-set LotteryRounds round (merge (unwrap-panic roundStats) {
        stxInPool: (+ (get stxInPool (unwrap-panic roundStats)) price),
        ticketsSold: (+ (get ticketsSold (unwrap-panic roundStats)) u1)
      }))
    )
    ;; update user stats
    (if (is-none userStats)
      (map-set UserStats contract-caller {
        lastRound: round,
        totalStxSpent: price,
        totalTickets: u1,
        totalWon: u0
      })
      (map-set UserStats contract-caller (merge (unwrap-panic userStats) {
        lastRound: round,
        totalStxSpent: (+ (get totalStxSpent (unwrap-panic userStats)) price),
        totalTickets: (+ (get totalTickets (unwrap-panic userStats)) u1)
      }))
    )
    ;; update user round stats
    (if (is-none userRoundStats)
      (map-set UserRounds { user: contract-caller, round: round } {
        tickets: u1,
        stxSpent: price
      })
      (map-set UserRounds { user: contract-caller, round: round } (merge (unwrap-panic userRoundStats) {
        tickets: (+ (get tickets (unwrap-panic userRoundStats)) u1),
        stxSpent: (+ (get stxSpent (unwrap-panic userRoundStats)) price)
      }))
    )
    ;; transfer ticket price to contract
    (try! (stx-transfer? price contract-caller SELF))
    ;; mint nft
    (nft-mint? LotteryTicket tokenId contract-caller)
  )
)

(define-public (select-winner (round uint))
  (let
    (
      (currentRound (get-lottery-round))
      (roundStats (map-get? LotteryRounds round))
      (userStats (map-get? UserStats contract-caller))
      ;; select winner in a super unfair way
      (winner contract-caller)
    )
    ;; if round is not over, return error
    (asserts! (>= currentRound (+ round u1)) ERR_ROUND_NOT_OVER)
    ;; verify round existed
    (asserts! (is-some roundStats) ERR_NO_ROUND_DATA)
    ;; if winner is already selected, return error
    (asserts! (is-none (get winner (unwrap-panic roundStats))) ERR_WINNER_ALREADY_SELECTED)
    ;; update round stats
    (map-set LotteryRounds round (merge (unwrap-panic roundStats) {
      winner: (some winner)
    }))
    ;; update user 
    (if (is-none userStats)
      (map-set UserStats contract-caller {
        lastRound: round,
        totalStxSpent: u0,
        totalTickets: u0,
        totalWon: u0
      })
      (map-set UserStats winner (merge (unwrap-panic userStats) {
        totalWon: (+ (get totalWon (unwrap-panic userStats)) (get stxInPool (unwrap-panic roundStats)))
      }))
    )
    ;; return winner
    (ok winner)
  )
)

(define-public (claim-prize (round uint))
  (let
    (
      (currentRound (get-lottery-round))
      (roundStats (map-get? LotteryRounds round))
      (winner (get winner roundStats))
      (caller contract-caller)
    )
    ;; if round is not over, return error
    (asserts! (>= currentRound (+ round u1)) ERR_ROUND_NOT_OVER)
    ;; verify round existed
    (asserts! (is-some roundStats) ERR_NO_ROUND_DATA)
    ;; if winner is not selected, return error
    (asserts! (is-some winner) ERR_WINNER_NOT_SELECTED)
    ;; if winner is not caller, return error
    (asserts! (is-eq (some contract-caller) (unwrap-panic winner)) ERR_UNAUTHORIZED)
    ;; if winner already claimed, return error
    (asserts! (not (get claimed (unwrap-panic roundStats))) ERR_ROUND_ALREADY_CLAIMED)
    ;; update round info
    (map-set LotteryRounds round (merge (unwrap-panic roundStats) {
      claimed: true
    }))
    ;; burn nft: skipping this as its more complex than expected
    ;; - a user can purchase more than one ticket
    ;; - providing an identifier is cumbersome
    ;; - burning one if many doesn't help anything
    ;; - cannot get into map without minting to start with
    ;; - could do a "burn your own" function instead
    ;; transfer prize to winner
    (as-contract (stx-transfer? (get stxInPool (unwrap-panic roundStats)) SELF caller))
  )
)

(define-public (transfer (tokenId uint) (sender principal) (recipient principal))
  (let
    (
      (owner (nft-get-owner? LotteryTicket tokenId))
    )
    ;; make sure sender is caller
    (asserts! (is-eq sender contract-caller) ERR_UNAUTHORIZED)
    ;; make sure sender is nft owner
    (asserts! (and (is-some owner) (is-eq (unwrap-panic owner) contract-caller)) ERR_UNAUTHORIZED)
    ;; transfer nft
    (nft-transfer? LotteryTicket tokenId sender recipient)
  )
)

;; read only functions
;;

;; lottery helpers

(define-read-only (get-lottery-round)
  ;; ain't clairty math a hoot?
  (+ (/ (- block-height (var-get lotteryStartHeight)) (var-get lotteryPeriod)) u1)
)

(define-read-only (get-lottery-round-at-block (block uint))
  (if (< block (var-get lotteryStartHeight))
    ERR_BEFORE_FIRST_ROUND
    (ok (+ (/ (- block (var-get lotteryStartHeight)) (var-get lotteryPeriod)) u1))
  )
)

;; data-var getters

(define-read-only (get-ticket-count)
  (ok (var-get ticketCount))
)

(define-read-only (get-ticket-price)
  (ok (var-get ticketPrice))
)

(define-read-only (get-lottery-period)
  (ok (var-get lotteryPeriod))
)

(define-read-only (get-lottery-start-height)
  (ok (var-get lotteryStartHeight))
)

;; define-map getters

(define-read-only (get-round-stats (round uint))
  (ok (map-get? LotteryRounds round))
)

(define-read-only (get-user-stats (user principal))
  (ok (map-get? UserStats user))
)

(define-read-only (get-user-round-stats (user principal) (round uint))
  (ok (map-get? UserRounds { user: user, round: round }))
)

;; sip-009 functions

(define-read-only (get-last-token-id)
  (ok (- (var-get lastId) u1))
)

(define-read-only (get-token-uri (tokenId uint))
  (ok (some (int-to-ascii tokenId)))
)

(define-read-only (get-owner (tokenId uint))
  (ok (nft-get-owner? LotteryTicket tokenId))
)

;; greedy read-only functions

(define-read-only (get-config-info)
  {
    ticketCount: (get-ticket-count),
    ticketPrice: (get-ticket-price),
    lotteryPeriod: (get-lottery-period),
    lotteryStartHeight: (get-lottery-start-height),
    lastTokenId: (get-last-token-id),
  }
)

(define-read-only (get-round-info (round uint) (user principal))
  {
    roundStats: (get-round-stats round),
    userStats: (get-user-stats user),
    userRoundStats: (get-user-round-stats user round),
  }
)

;; Test cases

;; >> (contract-call? .ex8-02 get-config-info)
;; (tuple (lastTokenId (ok u0)) (lotteryPeriod (ok u144)) (lotteryStartHeight (ok u0)) (ticketCount (ok u0)) (ticketPrice (ok u1000000)))
;; >> (contract-call? .ex8-02 get-lottery-round)
;; u1
;; >> ::advance_chain_tip 144
;; 144 blocks simulated, new height: 145
;; >> (contract-call? .ex8-02 get-lottery-round)
;; u2
;; >> (contract-call? .ex8-02 buy-ticket)
;; Events emitted
;; {"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02","amount":"1000000","memo":""}}
;; {"type":"nft_mint_event","nft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02::LotteryTicket","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","value":"u1"}}
;; (ok true)
;; >> (contract-call? .ex8-02 buy-ticket)
;; Events emitted
;; {"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02","amount":"1000000","memo":""}}
;; {"type":"nft_mint_event","nft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02::LotteryTicket","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","value":"u2"}}
;; (ok true)
;; >> ::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5
;; tx-sender switched to ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5
;; >> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02 buy-ticket)
;; Events emitted
;; {"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02","amount":"1000000","memo":""}}
;; {"type":"nft_mint_event","nft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02::LotteryTicket","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","value":"u3"}}
;; (ok true)
;; >> ::set_tx_sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
;; tx-sender switched to ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
;; >> (contract-call? .ex8-02 get-round-info u1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (tuple (roundStats (ok none)) (userRoundStats (ok none)) (userStats (ok (some (tuple (lastRound u2) (totalStxSpent u2000000) (totalTickets u2) (totalWon u0))))))
;; >> (contract-call? .ex8-02 get-round-info u2 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (tuple (roundStats (ok (some (tuple (claimed false) (firstNftId u1) (stxInPool u3000000) (ticketsSold u3) (winner none))))) (userRoundStats (ok (some (tuple (stxSpent u2000000) (tickets u2))))) (userStats (ok (some (tuple (lastRound u2) (totalStxSpent u2000000) (totalTickets u2) (totalWon u0))))))
;; >> (contract-call? .ex8-02 select-winner u1)
;; (err u407)
;; >> (contract-call? .ex8-02 select-winner u2)
;; (err u403)
;; >> ::advance_chain_tip 144
;; 144 blocks simulated, new height: 289
;; >> (contract-call? .ex8-02 select-winner u2)
;; (ok ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; >> (contract-call? .ex8-02 claim-prize u1)
;; (err u407)
;; >> (contract-call? .ex8-02 claim-prize u2)
;; Events emitted
;; {"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"3000000","memo":""}}
;; (ok true)
;; >> (contract-call? .ex8-02 get-round-info u2 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (tuple (roundStats (ok (some (tuple (claimed false) (firstNftId u1) (stxInPool u3000000) (ticketsSold u3) (winner (some ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)))))) (userRoundStats (ok (some (tuple (stxSpent u2000000) (tickets u2))))) (userStats (ok (some (tuple (lastRound u2) (totalStxSpent u2000000) (totalTickets u2) (totalWon u3000000))))))
;; >> ::advance_chain_tip 20736
;; 20736 blocks simulated, new height: 21025
;; >> (contract-call? .ex8-02 get-lottery-round)
;; u147
;; >> (contract-call? .ex8-02 claim-prize u2)
;; (err u406)
