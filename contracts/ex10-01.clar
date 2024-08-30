
;; title: ex10-01
;; version: 1.0.0
;; summary: Make it work, then make it cheap!

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
  ;; we don't need begin before let
  (let
    (
      ;; technically we could shorten this to ID
      ;; but sometimes descriptive names are better
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
    ;; we don't need to get proposalID again here
    ;; and since var-set returns true we can merge
    ;; it with the ok response
    (ok (var-set proposalId (+ nextProposalId u1)))
  )
)

;; read only functions
;;

;; Optimize this function so that we don't read the same data multiple times
(define-read-only (get-proposal (id uint))
  (let
    (
      ;; get the proposal map once to re-use
      (proposal (map-get? Proposals id))
    )
    ;; set the tuple values using get
    {
      title: (get title proposal),
      description: (get description proposal),
      proposedBy: (get proposedBy proposal),
    }
  )
)






