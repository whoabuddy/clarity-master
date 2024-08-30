
;; title: ex10-02
;; version: 1.0.0
;; summary: Invulnerable to greed

;; constants
;;

(define-constant ERR_ONLY_OWNER (err u100))
(define-constant ERR_CAMPAIGN_DOES_NOT_EXISTS (err u101))
(define-constant ERR_CAMPAIGN_NOT_OVER (err u102))
(define-constant ERR_CAMPAIGN_ALREADY_CLAIMED (err u103))

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
    endsAtBlockHeight: uint,
    ;; add value to track if claimed
    claimed: bool,
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
      (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
      (map-set Campaigns campaignId {
        title: title,
        proposedBy: tx-sender,
        fundsRaised: amount,
        endsAtBlockHeight: (+ block-height u144),
        ;; set claimed to false
        claimed: false,
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
(define-public (withdraw-funds (campaignId uint) (destinationAddress principal))
  (let
    (
      (campaign (get-campaign campaignId))
    )
    (asserts! (is-some campaign) ERR_CAMPAIGN_DOES_NOT_EXISTS)
    (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
    ;; add check to see if campaign is claimed
    (asserts! (is-eq false (unwrap-panic (get claimed (get-campaign campaignId)))) ERR_CAMPAIGN_ALREADY_CLAIMED)
    ;; set claimed to true
    (map-set Campaigns campaignId (merge (unwrap-panic campaign) { claimed: true }))
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
