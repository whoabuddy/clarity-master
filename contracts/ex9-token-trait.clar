
;; title: ex9-token-trait
;; version: 1.0.0
;; summary:

;; traits
;;
(define-trait token-trait
  (
    (get-balance (principal) (response uint uint))
    (transfer (uint principal principal) (response bool uint))
  )
)
