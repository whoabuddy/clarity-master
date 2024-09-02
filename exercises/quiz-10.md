# Quiz 10: Security and Optimization

1. True or False: To reduce runtime costs, it is generally a good idea to not read the same variables or map data multiple times.

2. Which of the following is NOT a recommended practice for optimizing Clarity contracts?

- a) Minimizing on-chain storage
- b) Using `asserts!` instead of `if` statements where possible
- c) Always using unwrap! instead of unwrap-panic
- d) Avoiding unnecessary computation in read-only functions

3. True or False: It's good practice to store larger amounts of data on-chain, as long as it doesn’t get updated that often.

4. Which approach is generally recommended for contract upgradeability in Clarity?

- a) Using proxy contracts
- b) Implementing a versioning system within a single contract
- c) Deploying entirely new contracts and migrating data
- d) Using mutable variables to store contract logic

5. True or False: The `contract-call?` function has a fixed cost regardless of the complexity of the called function.

6. Which of the following is considered a security best practice in Clarity?

- a) Using `tx-sender` or `contract-caller` for authorization checks
- b) Using only `tx-sender` for authorization checks
- c) Allowing arbitrary contract calls from any user
- d) Storing sensitive data in clear text on-chain

7. True or False: In Clarity, it's sometimes more cost-effective to remove a loop or iteration where a more sequential approach can be done.

8. When dealing with large amounts of data that need to be referenced in a contract, which of the following is considered a best practice?

- a) Storing the entire dataset as a string on-chain
- b) Using a hash or merkle root of the data and storing only that on-chain
- c) Store the data off-chain, it doesn’t need to be referenced on-chain
- d) Storing the data in multiple separate contracts to distribute and reduce the cost

**Bonus Coding Challenges**

9. Here we have a `proposals` contract. There are several parts of this contract where we can optimize our runtime costs. Identify and fix these areas.

```clojure
;; Proposal Contract

(define-data-var proposalId uint u0)

(define-map Proposals uint {
  title: (string-ascii 50),
  description: (string-ascii 250),
  proposedBy: principal,
  startAtBlockHeight: uint,
  endAtBlockHeight: uint,
  execute: bool
})

;; There are some unnecessary expressions used in this function, remove them
(define-public (create-proposal (title (string-ascii 50)) (description (string-ascii 250)))
  (begin
    (let
      (
        (nextProposalId (var-get proposalId))
      )
      (map-set Proposals nextProposalId { title: title, description: description, proposedBy: tx-sender, startAtBlockHeight: (+ block-height u144), endAtBlockHeight: (+ block-height u1008), execute: false })
      (var-set proposalId (+ (var-get proposalId) u1))
      (ok true)
    )
  )
)

;; Optimize this function so that we don't read the same data multiple times
(define-read-only (get-proposal (id uint))
  (let
    (
      (title (get title (map-get? Proposals id)))
      (description (get description (map-get? Proposals id)))
      (proposedBy (get proposedBy (map-get? Proposals id)))
    )
    { title: title, description: description, proposedBy: proposedBy }
  )
)
```

10. Time to put on your white hat, hacker! There is a dangerous bug lurking inside the following campaign funding contract. Your task is to:

- Write another contract that demonstrates how you could potentially exploit the vulnerable fundraising contract.
- Provide a fix to the existing vulnerable contract, protecting it against your exploit.

```clojure
;; Vulnerable contract

(define-constant ERR_ONLY_OWNER (err u100))
(define-constant ERR_CAMPAIGN_DOES_NOT_EXISTS (err u101))
(define-constant ERR_CAMPAIGN_NOT_OVER (err u102))

(define-data-var contractOwner principal tx-sender)
(define-data-var nextCampaignId uint u1)

(define-map Campaigns uint { title: (string-ascii 50), proposedBy: principal, fundsRaised: uint, endsAtBlockHeight: uint })

(define-public (create-campaign (title (string-ascii 50)) (amount uint))
  (let
    (
      (campaignId (var-get nextCampaignId))
    )
    (begin
      (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
      (map-set Campaigns campaignId { title: title, proposedBy: tx-sender, fundsRaised: amount, endsAtBlockHeight: (+ block-height u144) })
      (ok (var-set nextCampaignId (+ campaignId u1)))
    )
  )
)

(define-public (change-owner (newOwner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
    (ok (var-set contractOwner newOwner))
  )
)

;; Only the `contractOwner` can control the withdraw of funds
(define-public (withdraw-funds (campaignId uint) (destinationAddress principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contractOwner)) ERR_ONLY_OWNER)
    (asserts! (is-some (get-campaign campaignId)) ERR_CAMPAIGN_DOES_NOT_EXISTS)
    (if (>= block-height (unwrap-panic (get endsAtBlockHeight (get-campaign campaignId))))
      (as-contract (stx-transfer? (unwrap-panic (get fundsRaised (get-campaign campaignId))) tx-sender destinationAddress))
      ERR_CAMPAIGN_NOT_OVER
    )
  )
)

(define-read-only (get-campaign (id uint))
  (map-get? Campaigns id)
)

(define-read-only (get-owner)
  (var-get contractOwner)
)

;; Steps
;; 1. The vulnerable contract should be deployed at `contract-0`, so make sure to reference it.
;; 2. Write your contract attempting to exploit the vulnerable contract.
;; 3. Deploy an updated vulnerable contract with the necessary changes that would prevent your exploit.
```
