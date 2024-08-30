
;; title: ex10-02
;; version: 1.0.0
;; summary: Vulnerable to greed

;; constants
;;

(define-constant ERR_ONLY_OWNER (err u100))
(define-constant ERR_CAMPAIGN_DOES_NOT_EXISTS (err u101))
(define-constant ERR_CAMPAIGN_NOT_OVER (err u102))

;; data vars
;;

(define-data-var contractOwner principal tx-sender)
(define-data-var nextCampaignId uint u1)

;; data maps
;;

(define-map Campaigns
  uint
  {
    title: (string-ascii 50),
    proposedBy: principal,
    fundsRaised: uint,
    endsAtBlockHeight: uint
  }
)

;; public functions
;;

(define-public (create-campaign (title (string-ascii 50)) (amount uint))
  (let
    (
      (campaignId (var-get nextCampaignId))
    )
    (begin
      ;; FYI could move stx-transfer? to last call so try! isn't needed
      ;; and var-set would be it's own line, no need for (ok ...)
      (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
      (map-set Campaigns campaignId {
        title: title,
        proposedBy: tx-sender,
        fundsRaised: amount,
        endsAtBlockHeight: (+ block-height u144)
      })
      (ok (var-set nextCampaignId (+ campaignId u1)))
    )
  )
)

(define-public (change-owner (newOwner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
    (ok (var-set contractOwner newOwner))
  )
)

;; Only the `contractOwner` can control the withdraw of funds
;; VULNERABILITY: campaign funds can be withdrawn more than once
(define-public (withdraw-funds (campaignId uint) (destinationAddress principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
    (asserts! (is-some (get-campaign campaignId)) ERR_CAMPAIGN_DOES_NOT_EXISTS)
    (if (>= block-height (unwrap-panic (get endsAtBlockHeight (get-campaign campaignId))))
      (as-contract (stx-transfer? (unwrap-panic (get fundsRaised (get-campaign campaignId))) tx-sender destinationAddress))
      ERR_CAMPAIGN_NOT_OVER
    )
  )
)

;; read only functions
;;

(define-read-only (get-campaign (id uint))
  (map-get? Campaigns id)
)

(define-read-only (get-owner)
  (var-get contractOwner)
)
