
;; title: ex8-02
;; version: 1.0.0
;; summary:

;; traits
;;
(impl-trait .ex8-sip009.nft-trait)

;; token definitions
;;

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;;

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

(define-non-fungible-token Ticket uint)

(define-data-var ticketCounter uint u0)
(define-data-var ticketPrice uint u1000000) ;; 1 STX
(define-data-var lotteryPool uint u0)

(define-public (buy-ticket)
  ;; Implement ticket purchase logic here
)

(define-public (select-winner)
  ;; Implement winner selection logic here (this can be hard coded, or however you prefer)
)

(define-public (claim-prize)
  ;; Implement prize claiming logic here
)

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