
;; title: ex3-01
;; version: 1.0.0
;; summary: Storing basic user profiles on-chain

;; constants
;;

(define-constant ERR_INCORRECT_PARAMS (err u401))

;; data maps
;;

;; define our map for UserProfiles
(define-map UserProfiles
	;; key: address
	principal
	;; profile info as a tuple
	{
		name: (string-ascii 255),
		age: uint,
	}
)

;; public functions
;;

;; simple implementation to add a user to the map
(define-public (add-user (name (string-ascii 255)) (age uint) (who (optional principal)))
  (let
    (
      (user (default-to tx-sender who))
    )
    (asserts! (>= age u0) ERR_INCORRECT_PARAMS)
    (map-set UserProfiles user {
      name: name,
      age: age,
    })
    (print {
      notification: "user-info-updated",
      payload: (get-profile user),
    })
    (ok true)
  )
)


;; read only functions
;;

;; returns (some profile) or (none)
(define-read-only (get-profile (who principal))
	(map-get? UserProfiles who)
)

;; returns formatted info about the user
;; or a message the user wasn't found
(define-read-only (get-profile-info (who (optional principal)))
  (match (get-profile (default-to tx-sender who)) profile
    ;; some branch returns profile object
    (let
      (
        (userName (get name profile))
        (userAge (get age profile))
        (nameMessage (concat "Hello, " (concat userName "!")))
        (userAgeAsText (int-to-ascii userAge))
        (ageMessage (concat "How does it feel to be " (concat userAgeAsText " years old?")))
        (finalMessage (concat nameMessage (concat "\n" ageMessage)))
      )
      (ok finalMessage)
    )
    ;; none branch returns message
    (ok "User not found. We have no idea what your name is or how old you are. Maybe you'd share it with us?")
  )
)

;; can get the name only
(define-read-only (get-profile-name (who (optional principal)))
  (let
    (
      (user (default-to tx-sender who))
      (profile (get-profile user))
    )
    (if (is-some profile)
      (some (get name (unwrap! profile none)))
      none
    )
  )
)

;; can get the age only
(define-read-only (get-profile-age (who (optional principal)))
  (let
    (
      (user (default-to tx-sender who))
      (profile (get-profile user))
    )
    (if (is-some profile)
      (some (get age (unwrap! profile none)))
      none
    )
  )
)

;; test cases
;;

(define-public (run-tests)
  (begin
    (print "TEST CASES")
    ;; adding Alice, (none) for last param would work the same
    (try! (add-user "Alice" u25 (some 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)))
    ;; info for tx-sender, aka ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
    (print {
      get-profile: (get-profile 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM),
      get-profile-info: (get-profile-info none),
      get-profile-name: (get-profile-name none),
      get-profile-age: (get-profile-age none),
    })
    ;; info doesn't exist for unregistered address
    (print {
      get-profile: (get-profile 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5),
      get-profile-info: (get-profile-info (some 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)),
      get-profile-name: (get-profile-name (some 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)),
      get-profile-age: (get-profile-age (some 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)),
    })
    (ok true)
  )
)

;; run the tests
(run-tests)
