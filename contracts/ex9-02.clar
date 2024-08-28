
;; title: ex9-02
;; version: 1.0.0
;; summary: if you don't use it you lose it

;; traits
;;
(use-trait sip009 .ex8-sip009.nft-trait)

;; public functions
;;

;; BUG: nftContract needs to use the trait
(define-public (get-owner-of-nft (nftContract <sip009>) (tokenId uint))
  (match (contract-call? nftContract get-owner tokenId)
    ;; had to remove unwrap-panic here, none value aborted for me!
    ownerPrincipal (ok ownerPrincipal)
    err (err u401)
  )
)

;; Test cases

;; >> (contract-call? .ex9-02 get-owner-of-nft .ex8-02 u1)
;; (ok none)

;; >> (contract-call? .ex8-02 buy-ticket)
;; Events emitted
;; {"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02","amount":"1000000","memo":""}}
;; {"type":"nft_mint_event","nft_mint_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.ex8-02::LotteryTicket","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","value":"u1"}}
;; (ok true)

;; >> (contract-call? .ex9-02 get-owner-of-nft .ex8-02 u1)
;; (ok (some ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))

