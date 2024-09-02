# Quiz 8: Non-Fungible Tokens (NFTs)

1. Which of the following is NOT a function required by the SIP009 NFT trait?

- a) get-last-token-id
- b) get-token-uri
- c) get-owner
- d) burn

2. True or False: The asset identifier for an NFT type must be an unsigned integer (`uint`).

3. What is an example of the correct way to assert conformity to the SIP009 NFT trait in a Clarity contract?

- a) (use-trait .sip009.trait)
- b) (implement-trait .sip009.trait)
- c) (impl-trait .sip009.trait)
- d) (assert-trait .sip009.trait)

4. In the context of SIP009 NFTs, what does the `get-token-uri` function typically return?

- a) The owner's principal
- b) The token's unique identifier
- c) A link to the token's metadata
- d) The token's transfer history

5. True or False: The SIP009 standard provides a specification for what should exist at the URI returned by `get-token-uri`.

6. In a typical SIP009 NFT implementation, what should the transfer function typically assert before allowing a token transfer? (Choose the most important check)

- a) The recipient has enough balance to receive the token
- b) The token ID is less than the last token ID
- c) The sender is equal to the `contract-caller`
- d) The sender is the contract owner

7. What does the error code `(err u1)` typically indicate when returned by the `nft-transfer?` function?

- a) The asset identifier does not exist
- b) The sender does not own the asset
- c) The sender and recipient are the same principal
- d) The NFT has already been minted

8. When attempting to mint an NFT, what is the most likely cause of receiving an `(err u1)` response?

- a) The NFT contract has reached its maximum supply
- b) The asset identifier already exists
- c) The recipient's address is invalid
- d) The contract caller is not authorized to mint

**Bonus Coding Challenges**

9. Debug this NFT transfer function error: `detected two execution paths, returning two different expression types`

```clojure
(define-non-fungible-token CoolNFT uint)

(define-public (transfer-nft (tokenId uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u1))
    (try! (nft-transfer? CoolNFT tokenId sender recipient))
  )
)

;; Test cases
;; (define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; (nft-mint? CoolNFT u1 WALLET_1)
;; (transfer-nft u1 WALLET_1 WALLET_2) ;; This should return (ok true)
;; (nft-get-owner? CoolNFT u1) ;; This should return (ok WALLET_2)
```

10. Your task is to create a simple NFT lottery contract where users can purchase lottery tickets (as NFTs) by sending a certain amount of STX. Here are the requirements:

- Define an NFT for lottery tickets
- Create a function to purchase a ticket by sending STX
- Create a function to select a winner (does not need to be random)
- Allow the winner to claim their prize

```clojure
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
```
