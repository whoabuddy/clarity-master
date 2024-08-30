
;; title: ex10-01
;; version: 1.0.0
;; summary: Make it work, then make it cheap!

;; constants
;;

;; data vars
;;

(define-data-var proposalId uint u0)

;; data maps
;;

(define-map Proposals uint {
  title: (string-ascii 50),
  description: (string-ascii 250),
  proposedBy: principal,
  startAtBlockHeight: uint,
  endAtBlockHeight: uint,
  execute: bool
})

;; public functions
;;

;; There are some unnecessary expressions used in this function, remove them 
(define-public (create-proposal (title (string-ascii 50)) (description (string-ascii 250)))
  (begin
    (let
      (
        (nextProposalId (var-get proposalId))
      )
      (map-set Proposals nextProposalId {
        title: title,
        description: description,
        proposedBy: tx-sender,
        startAtBlockHeight: (+ block-height u144),
        endAtBlockHeight: (+ block-height u1008),
        execute: false
      })
      (var-set proposalId (+ (var-get proposalId) u1))
      (ok true)
    )
  )
)

;; read only functions
;;

;; Optimize this function so that we don't read the same data multiple times
(define-read-only (get-proposal (id uint))
  (let
    (
      (title (get title (map-get? Proposals id)))
      (description (get description (map-get? Proposals id)))
      (proposedBy (get proposedBy (map-get? Proposals id)))
    )
    { title: title, description: description, proposedBy: proposedBy }
  )
)






