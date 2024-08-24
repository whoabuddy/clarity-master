
;; title: ex5-01
;; version:
;; summary:
;; description:

;; traits
;;

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

;; 9. Fix the bug in the following code snippet:

(define-data-var txLog (list 100 uint) (list))

(define-public (add-tx (amount uint))
  (var-set txLog (append txLog amount))
  (ok true)
)

(define-read-only (get-last-tx)
  (let
    (
      (logLength (len txLog))
    )
    (if (> logLength u0)
      (ok (element-at? txLog (- logLength u1)))
      (err u0)
    )
  )
)

(define-private (clear-log)
  (var-set txLog (list))
  (print "Log cleared")
)

(define-public (get-tx-count)
  (ok (len txLog))
)