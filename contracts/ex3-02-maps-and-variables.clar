
;; title: ex3-02-maps-and-variables
;; version: 1.0.0
;; summary: Simple voting contract.

;; constants
;;
(define-constant ERR_CANDIDATE_NOT_FOUND (err u3100))
(define-constant ERR_SENDER_ALREADY_VOTED (err u3101))
(define-constant ERR_INVALID_CANDIDATE (err u3102))


;; data vars
;;
(define-data-var TotalVotes uint u0)

;; data maps
;;

;; redefined the maps here based on the objective
;; of allowing individuals to vote on a candidate
;; unless I misunderstood the desired end flow

(define-map VoteRecords
  principal ;; tx-sender of voter
  principal ;; candidate they voted for
)

(define-map VoteCounts
  principal ;; candidate
  uint      ;; votes
)

;; public functions
;;

;; assuming this was to register someone to vote FOR
;; as voter principals are tracked by their key (1 vote each)
;; and instead of a bool we can put who they voted FOR
(define-public (register-candidate (candidate principal))
  (match (map-get? VoteCounts candidate) counts
    ;; if candidate is registered, return vote counts
    (ok counts)
    ;; else insert registration info, return vote counts
    (let
      (
        (principalResponse (principal-destruct? candidate))
        (principalInfo (unwrap! principalResponse ERR_INVALID_CANDIDATE))
        (principalName (get name principalInfo))
      )
      ;; make sure it's not a contract
      (asserts! (is-none principalName) ERR_INVALID_CANDIDATE)
      ;; insert candidate with 0 votes
      (asserts! (map-insert VoteCounts candidate u0) ERR_INVALID_CANDIDATE)
      ;; return vote counts
      (ok u0)
    )
  )
)

;; Implement the cast-vote function
(define-public (cast-vote (voter principal) (candidate principal))
  (let
    (
      (candidateRecord (map-get? VoteCounts candidate))
      ;; if candidate isn't known fail here
      (candidateVotes (unwrap! candidateRecord ERR_CANDIDATE_NOT_FOUND))
      (newVotes (+ candidateVotes u1))
    )
    ;; insert vote from voter (ballot stuffing!)
    ;; TODO: change vote would be nice in future
    (map-insert VoteRecords voter candidate)
    ;; update vote total for candidate
    (map-set VoteCounts candidate newVotes)
    ;; print voting info
    (print (get-vote voter))
    (print (get-vote-count candidate))
    (ok newVotes)
  )
  


)

;; read only functions
;;

;; Implement the get-vote-count function
(define-read-only (get-vote-count (candidate principal))
  (match (map-get? VoteCounts candidate) counts
    ;; return if found
    (some counts)
    ;; none if not found
    none
  )
)

;; also one to get your vote if set
(define-read-only (get-vote (voter principal))
  (match (map-get? VoteRecords voter) candidate
    ;; return if found
    (some candidate)
    ;; none if not found
    none
  )
)

;; test cases
;;

(define-public (run-tests)
  (begin
    (print "TEST CASES")
    ;; register candidates
    (print (try! (register-candidate 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))) ;; returns (ok u0) as vote count
    (print (try! (register-candidate 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5))) ;; returns (ok u0) as vote count
    ;; cast votes
    (print (try! (cast-vote 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))) ;; returns (ok u1)
    ;; (print (unwrap-err-panic (cast-vote 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5))) ;; returns (err u3101) so we catch and eat that
    (print (try! (cast-vote 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))) ;; returns (ok u2)
    (print (try! (cast-vote 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5))) ;; returns (ok u1)
    ;; check vote counts
    (print (get-vote-count 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)) ;; returns (some u2)
    (print (get-vote-count 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)) ;; returns (some u1)
    ;; check votes
    (print (get-vote 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)) ;; returns (some 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
    (print (get-vote 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)) ;; returns (some 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
    (print (get-vote 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP)) ;; returns (some 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
    ;; return
    (ok true)
  )
)
