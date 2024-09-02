# Quiz 9: Traits and Implementations

1. True or False: Traits in Clarity are used to define a public interface to which a contract can conform either implicitly or explicitly.

2. Which of the following is used to define a trait in Clarity?
   a) define-trait
   b) impl-trait
   c) use-trait
   d) create-trait

3. True or False: When defining a trait, function argument names must be included in the function signatures.

4. What does the `impl-trait` function do in a Clarity contract?
   a) Defines a new trait
   b) Imports a trait from another contract
   c) Asserts that the contract implements a specific trait
   d) Creates a new implementation of a trait

5. True or False: A Clarity contract can implement multiple traits.

6. Which function is used to import a trait from another contract in Clarity?
   a) import-trait
   b) use-trait
   c) get-trait
   d) fetch-trait

7. When passing a trait as an argument to a function, how is the trait type notation represented?
   a) `(trait-name)`
   b) `[trait-name]`
   c) `{trait-name}`
   d) `<trait-name>`

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

   [Problem](https://play.hiro.so/?epoch=2.5&snippet=OzsgRGVmaW5lIGEgdHJhaXQgZm9yIGEgYmFzaWMgdG9rZW4KKGRlZmluZS10cmFpdCB0b2tlbi10cmFpdAogICgKICAgIChnZXQtYmFsYW5jZSAocHJpbmNpcGFsKSAocmVzcG9uc2UgdWludCB1aW50KSkKICAgICh0cmFuc2ZlciAodWludCBwcmluY2lwYWwgcHJpbmNpcGFsKSAocmVzcG9uc2UgYm9vbCB1aW50KSkKICApCikKCjs7IFVuY29tbWVudCB0aGUgY29kZSBiZWxvdyB0byBmaXggdGhlIGVycm9yCgo7OyBJbXBsZW1lbnQgeW91ciB0cmFpdAo7OyAoaW1wbC10cmFpdCAuY29udHJhY3QtMC50b2tlbi10cmFpdCkKCjs7IChkZWZpbmUtZnVuZ2libGUtdG9rZW4gQ2xhcml0eVRva2VuKQoKOzsgKGRlZmluZS1yZWFkLW9ubHkgKGdldC1iYWxhbmNlIChhY2NvdW50IHByaW5jaXBhbCkpCjs7ICAgKG9rIChmdC1nZXQtYmFsYW5jZSBDbGFyaXR5VG9rZW4gYWNjb3VudCkpCjs7ICkKCjs7IChkZWZpbmUtcHVibGljICh0cmFuc2ZlciAoc2VuZGVyIHByaW5jaXBhbCkgKGFtb3VudCB1aW50KSAocmVjaXBpZW50IHByaW5jaXBhbCkpCjs7ICAgKGJlZ2luCjs7ICAgICAoZnQtdHJhbnNmZXI_IENsYXJpdHlUb2tlbiBhbW91bnQgc2VuZGVyIHJlY2lwaWVudCkKOzsgICApCjs7ICkKCjs7IFRlc3QgY2FzZXMKOzsgKGRlZmluZS1jb25zdGFudCBXQUxMRVRfMSAnU1QxUFFIUUtWMFJKWFpGWTFER1g4TU5TTllWRTNWR1pKU1JUUEdaR00pCjs7IChkZWZpbmUtY29uc3RhbnQgV0FMTEVUXzIgJ1NUMkNZNVYzOU5IRFBXU1hNVzlRRFQzSEMzR0Q2UTZYWDRDRlJLOUFHKQoKOzsgTWludCBzb21lIHRva2VucyBmb3IgdGVzdGluZwo7OyAoZnQtbWludD8gQ2xhcml0eVRva2VuIHUxMDAwIFdBTExFVF8xKQoKOzsgVGVzdCBnZXQtYmFsYW5jZQo7OyAocHJpbnQgKGdldC1iYWxhbmNlIFdBTExFVF8xKSkgOzsgU2hvdWxkIHJldHVybiAob2sgdTEwMDApCgo7OyBUT0RPOiBwcm92aWRlIGEgdGVzdCBjYXNlIGZvciB0cmFuc2ZlciAoSElOVDogdGhpcyBpcyB3aGVyZSB0aGUgYnVnIGlzKQoKOzsgKHByaW50IChnZXQtYmFsYW5jZSBXQUxMRVRfMSkpIDs7IFNob3VsZCByZXR1cm4gKG9rIHU1MDApCjs7IChwcmludCAoZ2V0LWJhbGFuY2UgV0FMTEVUXzIpKSA7OyBTaG91bGQgcmV0dXJuIChvayB1NTAwKQ)

   [Solution](https://play.hiro.so/?epoch=2.5&snippet=OzsgRGVmaW5lIGEgdHJhaXQgZm9yIGEgYmFzaWMgdG9rZW4KOzsoZGVmaW5lLXRyYWl0IHRva2VuLXRyYWl0Cjs7ICAoCjs7ICAgIChnZXQtYmFsYW5jZSAocHJpbmNpcGFsKSAocmVzcG9uc2UgdWludCB1aW50KSkKOzsgICAgKHRyYW5zZmVyICh1aW50IHByaW5jaXBhbCBwcmluY2lwYWwpIChyZXNwb25zZSBib29sIHVpbnQpKQo7OyAgKQo7OykKCjs7IFVuY29tbWVudCB0aGUgY29kZSBiZWxvdyB0byBmaXggdGhlIGVycm9yCgo7OyBJbXBsZW1lbnQgeW91ciB0cmFpdAo7OyAoaW1wbC10cmFpdCAuY29udHJhY3QtMC50b2tlbi10cmFpdCkKCjs7IChkZWZpbmUtZnVuZ2libGUtdG9rZW4gQ2xhcml0eVRva2VuKQoKOzsgKGRlZmluZS1yZWFkLW9ubHkgKGdldC1iYWxhbmNlIChhY2NvdW50IHByaW5jaXBhbCkpCjs7ICAgKG9rIChmdC1nZXQtYmFsYW5jZSBDbGFyaXR5VG9rZW4gYWNjb3VudCkpCjs7ICkKCjs7IDs7IEJVRzogdHJhaXQgc3BlY2lmaWVkICh1aW50IHByaW5jaXBhbCBwcmluY2lwYWwpIGZvciB0eXBlIHNpZ25hdHVyZQo7OyAoZGVmaW5lLXB1YmxpYyAodHJhbnNmZXIgKGFtb3VudCB1aW50KSAoc2VuZGVyIHByaW5jaXBhbCkgKHJlY2lwaWVudCBwcmluY2lwYWwpKQo7OyAgIDs7IGFsc28gZGlkbid0IG5lZWQgYSBiZWdpbiAoc2luZ2xlIGFyZywgcmV0dXJucyBvay9lcnIpCjs7ICAgOzsgYnV0IHRlY2huaWNhbGx5IHRoaXMgd291bGQgYmUgd2lkZSBvcGVuIGFueXdheQo7OyAgIChmdC10cmFuc2Zlcj8gQ2xhcml0eVRva2VuIGFtb3VudCBzZW5kZXIgcmVjaXBpZW50KQo7OyAp)

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

    [Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1wdWJsaWMgKGdldC1vd25lci1vZi1uZnQgKG5mdENvbnRyYWN0IHByaW5jaXBhbCkgKHRva2VuSWQgdWludCkpCiAgKG1hdGNoIChjb250cmFjdC1jYWxsPyBuZnRDb250cmFjdCBnZXQtb3duZXIgdG9rZW5JZCkKICAgIG93bmVyUHJpbmNpcGFsIChvayAodW53cmFwLXBhbmljIG93bmVyUHJpbmNpcGFsKSkKICAgIGVyciAoZXJyIHU0MDEpCiAgKQopCgo7OyBUZXN0IGNhc2VzCjs7IChkZWZpbmUtY29uc3RhbnQgTkZUX0NPTlRSQUNUICdTVDFQUUhRS1YwUkpYWkZZMURHWDhNTlNOWVZFM1ZHWkpTUlRQR1pHTS5teS1zaXA5LW5mdCkKOzsgKGdldC1vd25lci1vZi1uZnQgTkZUX0NPTlRSQUNUIHUxKSA7OyBTaG91bGQgcmV0dXJuIChvayBuZnRPd25lclByaW5jaXBhbCk)

    [Solution](https://play.hiro.so/?epoch=2.5&snippet=KHVzZS10cmFpdCBzaXA5IC5jb250cmFjdC0wLnNpcDktdHJhaXQpCgooZGVmaW5lLXB1YmxpYyAoZ2V0LW93bmVyLW9mLW5mdCAobmZ0Q29udHJhY3QgPHNpcDk-KSAodG9rZW5JZCB1aW50KSkKICAobWF0Y2ggKGNvbnRyYWN0LWNhbGw_IG5mdENvbnRyYWN0IGdldC1vd25lciB0b2tlbklkKQogICAgb3duZXJQcmluY2lwYWwgKG9rICh1bndyYXAtcGFuaWMgb3duZXJQcmluY2lwYWwpKQogICAgZXJyIChlcnIgdTQwMSkKICApCikKCjs7IFRlc3QgY2FzZXMKOzsgKGRlZmluZS1jb25zdGFudCBORlRfQ09OVFJBQ1QgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNLm15LXNpcDktbmZ0KQo7OyAoZ2V0LW93bmVyLW9mLW5mdCBORlRfQ09OVFJBQ1QgdTEpIDs7IFNob3VsZCByZXR1cm4gKG9rIG5mdE93bmVyUHJpbmNpcGFsKQ)
