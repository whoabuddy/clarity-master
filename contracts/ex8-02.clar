
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
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_BEFORE_FIRST_ROUND (err u402))

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
    winner: (optional principal)
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
        winner: none
      })
      (map-set LotteryRounds round (merge (unwrap-panic roundStats) {
        stxInPool: (+ (get stxInPool roundStats) price),
        ticketsSold: (+ (get ticketsSold roundStats) u1)
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
        totalStxSpent: (+ (get totalStxSpent userStats) price),
        totalTickets: (+ (get totalTickets userStats) u1)
      }))
    )
    ;; update user round stats
    (if (is-none userRoundStats)
      (map-set UserRounds { user: contract-caller, round: round } {
        tickets: u1,
        stxSpent: price
      })
      (map-set UserRounds { user: contract-caller, round: round } (merge (unwrap-panic userRoundStats) {
        tickets: (+ (get tickets userRoundStats) u1),
        stxSpent: (+ (get stxSpent userRoundStats) price)
      }))
    )
    ;; transfer ticket price to contract
    (try! (stx-transfer? contract-caller SELF price))
    ;; mint nft
    (nft-mint? LotteryTicket tokenId contract-caller)
  )
)

(define-public (select-winner)
  ;; we need to know current round
  ;; if round is not over, return error
  ;; if winner is already selected, return error
  ;; closes out the old round
  (ok true)
)

(define-public (claim-prize)
  ;; we need to know current round
  ;; if round is not over, return error
  ;; if winner is not selected, return error (or select one?)
  ;; if winner is not caller, return error
  ;; burn nft
  ;; transfer prize to winner
  (ok true)
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

;; TODO: getters for each map

(define-read-only (get-last-token-id)
  (ok (- (var-get lastId) u1))
)

(define-read-only (get-token-uri)
  (ok none)
)

(define-read-only (get-owner (tokenId uint))
  (ok (nft-get-owner? LotteryTicket tokenId))
)

;; private functions
;;

;; 10. Your task is to create a simple NFT lottery contract where users can purchase
;; lottery tickets (as NFTs) by sending STX. Your contract must meet the requirements below.

;; Here are the requirements:
;; - Define an NFT for lottery tickets
;; - Create a function to purchase a ticket by sending STX
;; - Create a function to select a winner (does not need to be random)
;; - Allow the winner to claim their prize

;; rounds happen every so many blocks (say 144)
;; map of round number to total tickets (also total STX if mutiplied)
;; each round has a winner determined after round ends (+1 block)
;; winner gets ???
;; ticket price is fixed at 1 STX
;; claiming prize burns the nft


;; Test cases

;; Buy a ticket successfully
;; (contract-call? .lottery buy-ticket) ;; Should `mint` NFT to your address
;; ticketCounter should be 1, lotteryPool should be 1000000

;; Select a winner
;; (contract-call? .lottery select-winner)
;; Should return (ok principal) where principal is the winner's address

;; Claim prize (assuming the caller is the winner)
;; (contract-call? .lottery claim-prize) ;; Should return (ok u...)
;; The winner's balance should increase by 3000000, lotteryPool should be 0

;; Attempt to select winner when no tickets are sold
;; First, reset the contract state or deploy a fresh instance
;; (contract-call? .lottery select-winner)
;; Should return an error (err u...) indicating no tickets sold

;; Buy a ticket after a winner has been selected
;; Assuming a winner has been selected in a previous test
;; (contract-call? .lottery buy-ticket)
;; Should return an error (err u...) or start a new lottery round

;; Get current ticket price
;; (contract-call? .lottery get-ticket-price)
;; Should return price of ticket

;; Get total tickets sold
;; (contract-call? .lottery get-tickets-sold)
;; Should return the number of tickets sold (uint)

;; Get current lottery pool
;; (contract-call? .lottery get-lottery-pool)
;; Should return the current amount in the lottery pool (uint)