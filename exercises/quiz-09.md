# Quiz 9: Traits and Implementations

1. True or False: Traits in Clarity are used to define a public interface to which a contract can conform either implicitly or explicitly.

2. Which of the following is used to define a trait in Clarity?

- a) define-trait
- b) impl-trait
- c) use-trait
- d) create-trait

3. True or False: When defining a trait, function argument names must be included in the function signatures.

4. What does the `impl-trait` function do in a Clarity contract?

- a) Defines a new trait
- b) Imports a trait from another contract
- c) Asserts that the contract implements a specific trait
- d) Creates a new implementation of a trait

5. True or False: A Clarity contract can implement multiple traits.

6. Which function is used to import a trait from another contract in Clarity?

- a) import-trait
- b) use-trait
- c) get-trait
- d) fetch-trait

7. When passing a trait as an argument to a function, how is the trait type notation represented?

- a) `(trait-name)`
- b) `[trait-name]`
- c) `{trait-name}`
- d) `<trait-name>`

8. True or False: Trait conformance requires a contract to implement all functions defined in the trait, but it can also include additional functions not specified in the trait.

**Bonus Coding Challenges**

9. The following code snippet has a bug. Fix it to get your contract to deploy.

```clojure
;; Define a trait for a basic token
(define-trait token-trait
  (
    (get-balance (principal) (response uint uint))
    (transfer (uint principal principal) (response bool uint))
  )
)

;; Uncomment the code below to fix the error

;; Implement your trait
;; (impl-trait .contract-0.token-trait)

;; (define-fungible-token ClarityToken)

;; (define-read-only (get-balance (account principal))
;;   (ok (ft-get-balance ClarityToken account))
;; )

;; (define-public (transfer (sender principal) (amount uint) (recipient principal))
;;   (begin
;;     (ft-transfer? ClarityToken amount sender recipient)
;;   )
;; )

;; Test cases
;; (define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; (define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; Mint some tokens for testing
;; (ft-mint? ClarityToken u1000 WALLET_1)

;; Test get-balance
;; (print (get-balance WALLET_1)) ;; Should return (ok u1000)

;; TODO: provide a test case for transfer (HINT: this is where the bug is)

;; (print (get-balance WALLET_1)) ;; Should return (ok u500)
;; (print (get-balance WALLET_2)) ;; Should return (ok u500)
```

10. Spot and fix the bug. Given the following Clarity contract that implements a proposal system using NFTs, find and fix the bug by using a trait.

```clojure
(define-public (get-owner-of-nft (nftContract principal) (tokenId uint))
  (match (contract-call? nftContract get-owner tokenId)
    ownerPrincipal (ok (unwrap-panic ownerPrincipal))
    err (err u401)
  )
)

;; Test cases
;; (define-constant NFT_CONTRACT 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.my-sip9-nft)
;; (get-owner-of-nft NFT_CONTRACT u1) ;; Should return (ok nftOwnerPrincipal)
```

**Hint**:

- You will need to define and implement the SIP009 NFT trait ([reference](https://book.clarity-lang.org/ch10-01-sip009-nft-standard.html)).
