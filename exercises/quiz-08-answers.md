# Quiz 8: Non-Fungible Tokens (NFTs)

## Answer Key

1. d) burn
2. False
3. c) (impl-trait .sip009.trait)
4. c) A link to the token's metadata
5. False
6. c) The sender is equal to the contract-caller
7. b) The sender does not own the asset
8. b) The asset identifier already exists
9. Code snippet below

```clarity
(define-non-fungible-token CoolNFT uint)

(define-public (transfer-nft (tokenId uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u1))
    (nft-transfer? CoolNFT tokenId sender recipient)
  )
)

;; Tests (uncomment and run these to check your solution)
;; (define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; (nft-mint? CoolNFT u1 WALLET_1)
;; (transfer-nft u1 WALLET_1 WALLET_2) ;; This should return (ok true)
;; (nft-get-owner? CoolNFT u1) ;; This should return (ok WALLET_2)
```

10. Code snippet below

```clarity
(define-non-fungible-token Ticket uint)

(define-data-var ticketCounter uint u0)
(define-data-var ticketPrice uint u1000000) ;; 1 STX
(define-data-var lotteryPool uint u0)
(define-data-var currentWinner (optional principal) none)

(define-public (buy-ticket)
  (let
    (
      (caller tx-sender)
    )
    (asserts! (is-none (var-get currentWinner)) (err u100)) ;; Ensure no winner has been selected
    (try! (stx-transfer? (var-get ticketPrice) caller (as-contract tx-sender)))
    (try! (nft-mint? Ticket (var-get ticketCounter) caller))
    (var-set ticketCounter (+ (var-get ticketCounter) u1))
    (var-set lotteryPool (+ (var-get lotteryPool) (var-get ticketPrice)))
    (ok (var-get ticketCounter))
  )
)

(define-public (select-winner)
  (let
    (
      (total-tickets (var-get ticketCounter))
    )
    (asserts! (> total-tickets u0) (err u101)) ;; Ensure tickets have been sold
    (asserts! (is-none (var-get currentWinner)) (err u102)) ;; Ensure no winner has been selected yet
    (let
      (
        (winner-ticket-id (mod block-height total-tickets))
        (winner (unwrap! (nft-get-owner? Ticket winner-ticket-id) (err u103)))
      )
      (var-set currentWinner (some winner))
      (ok winner)
    )
  )
)

(define-public (claim-prize)
  (let
    (
      (winner (unwrap! (var-get currentWinner) (err u104))) ;; Ensure a winner has been selected
      (prize (var-get lotteryPool))
    )
    (asserts! (is-eq tx-sender winner) (err u105)) ;; Ensure the caller is the winner
    (try! (as-contract (stx-transfer? prize tx-sender winner)))
    (var-set lotteryPool u0)
    (var-set currentWinner none)
    (var-set ticketCounter u0)
    (ok prize)
  )
)

(define-read-only (get-ticket-price)
  (ok (var-get ticketPrice))
)

(define-read-only (get-tickets-sold)
  (ok (var-get ticketCounter))
)

(define-read-only (get-lottery-pool)
  (ok (var-get lotteryPool))
)
```
