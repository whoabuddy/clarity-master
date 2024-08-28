
;; title: ex8-02
;; version: 1.0.0
;; summary: nft lottery contract

;; traits
;;
;; (impl-trait .ex8-sip009.nft-trait)

;; token definitions
;;
(define-non-fungible-token LotteryTicket uint)

;; constants
;;

;; data vars
;;

(define-data-var ticketCounter uint u0)
(define-data-var ticketPrice uint u1000000) ;; 1 STX

(define-data-var lotteryPeriod uint u144) ;; 144 blocks (~1 day)s
(define-data-var lotteryStartHeight uint block-height) ;; start when deployed

;; data maps
;;

;; track round info
(define-map LotteryRound
  uint
  {
    ticketsSold: uint,
    stxInPool: uint,
    winner: (optional principal)
  }
)

;; track user info
(define-map UserTickets
  principal
  {
    tickets: uint,
    lastRound: uint,
    totalWon: uint,
  }
)

;; public functions
;;

(define-public (buy-ticket)
  ;; we need to know current round
  ;; mint nft to user
  (ok true)
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

;; read only functions
;;
(define-read-only (get-lottery-round)
  ;; ain't clairty math fun?
  (ok (+ (/ (- block-height (var-get lotteryStartHeight)) (var-get lotteryPeriod)) u1))
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