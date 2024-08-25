
;; title: ex5-01
;; version: 1.0.0
;; summary: I should be sleeping but I'm addicted to writing Clarity.

;; constants
;;
(define-constant ERR_LIST_FULL (err u401))

;; data vars
;;
(define-data-var txLog (list 100 uint) (list))

;; public functions
;;

;; bug 1: 2 action being performed. needs to be in a begin or let block,
;; or simplified to a single action since var-set returns true.
;; bug 2: txLog needs a getter function to access the data
;; bug 3: append increases list length by 1, need to check and limit
(define-public (add-tx (amount uint))
  (let 
    (
      (currentList (var-get txLog))
      (newList (append currentList amount))
      (updatedList (unwrap! (as-max-len? newList u100) ERR_LIST_FULL))
    )
    (ok (var-set txLog updatedList))
  )
)

;; read only functions
;;

;; bug 1: txLog needs a getter function to access the data
;; could do all throughout, or define in let first and reuse
(define-read-only (get-last-tx)
  (let
    (
      (log (var-get txLog))
      (logLength (len log))
    )
    (if (> logLength u0)
      (ok (element-at? log (- logLength u1)))
      (err u0)
    )
  )
)

;; converted to read-only (no need for tx)
;; bug 1: txLog needs a getter function to access the data
(define-read-only (get-tx-count)
  (ok (len (var-get txLog)))
)


;; private functions
;;

;; bug 1: needs begin or let for multiple actions
(define-private (clear-log)
  (begin
    (var-set txLog (list))
    (print "Log cleared")
  )
)
