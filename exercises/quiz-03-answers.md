# Quiz 3: Maps and Variables

## Answer Key

1. c) To create a key-value store
2. c) map-get?
3. b) (define-data-var counter int 0)
4. d) It updates the value of an existing variable
5. b) map-set overwrites existing values, while map-insert only adds new entries
6. b) map-delete
7. b) Retrieves the value of a defined variable
8. d) There is no fixed limit
9. b) Use a map with the voter's principal as the key and their vote as the value
10. c) Use a single map with a tuple to store all user information

11. Code snippet below

```clarity
(define-map UserProfiles principal { name: (string-ascii 50), age: uint })

;; Implement the get-balance function here
(define-read-only (get-profile (who principal))
	(map-get? UserProfiles who)
)

(define-read-only (get-name (who principal))
	(get name (get-profile who))
)

;; Test cases
(map-set UserProfiles tx-sender { name: "Ryan", age: u39})
(get-profile 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Should return a user
(get-name 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

12. Code snippet below

```clarity
(define-map Voters principal bool)
(define-map VoteCounts principal uint)
(define-data-var totalVotes uint u0)

(define-public (register-voter (voter principal))
  (if (default-to false (map-get? Voters voter))
    (err u1) ;; Voter already registered
    (ok (map-set Voters voter true))
  )
)

(define-public (cast-vote (voter principal) (candidate principal))
  (let
    (
      (isRegistered (default-to false (map-get? Voters voter)))
    )
    (if (and isRegistered (is-eq (get-vote-count voter) u0))
      (begin
        (map-set VoteCounts candidate (+ (default-to u0 (map-get? VoteCounts candidate)) u1))
        (var-set totalVotes (+ (var-get totalVotes) u1))
        (ok true)
      )
      (err u2) ;; Not registered or already voted
    )
  )
)

(define-read-only (get-vote-count (candidate principal))
  (default-to u0 (map-get? VoteCounts candidate))
)

;; Test cases
(register-voter 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Should return (ok true)
(cast-vote tx-sender 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG) ;; Should return (ok true)
(cast-vote tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Should fail (err u2) already voted
(get-vote-count 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG) ;; Should return (u1)
```
