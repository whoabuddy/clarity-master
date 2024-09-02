# Quiz 10: Security and Optimization

1. True or False: To reduce runtime costs, it is generally a good idea to not read the same variables or map data multiple times.

2. Which of the following is NOT a recommended practice for optimizing Clarity contracts?
   a) Minimizing on-chain storage
   b) Using `asserts!` instead of `if` statements where possible
   c) Always using unwrap! instead of unwrap-panic
   d) Avoiding unnecessary computation in read-only functions

3. True or False: It's good practice to store larger amounts of data on-chain, as long as it doesn’t get updated that often.

4. Which approach is generally recommended for contract upgradeability in Clarity?
   a) Using proxy contracts
   b) Implementing a versioning system within a single contract
   c) Deploying entirely new contracts and migrating data
   d) Using mutable variables to store contract logic

5. True or False: The `contract-call?` function has a fixed cost regardless of the complexity of the called function.

6. Which of the following is considered a security best practice in Clarity?
   a) Using `tx-sender` or `contract-caller` for authorization checks
   b) Using only `tx-sender` for authorization checks
   c) Allowing arbitrary contract calls from any user
   d) Storing sensitive data in clear text on-chain

7. True or False: In Clarity, it's sometimes more cost-effective to remove a loop or iteration where a more sequential approach can be done.

8. When dealing with large amounts of data that need to be referenced in a contract, which of the following is considered a best practice?
   a) Storing the entire dataset as a string on-chain
   b) Using a hash or merkle root of the data and storing only that on-chain
   c) Store the data off-chain, it doesn’t need to be referenced on-chain
   d) Storing the data in multiple separate contracts to distribute and reduce the cost

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

   [Problem](https://play.hiro.so/?epoch=2.5&snippet=OzsgUHJvcG9zYWwgQ29udHJhY3QKCihkZWZpbmUtZGF0YS12YXIgcHJvcG9zYWxJZCB1aW50IHUwKQoKKGRlZmluZS1tYXAgUHJvcG9zYWxzIHVpbnQgewogIHRpdGxlOiAoc3RyaW5nLWFzY2lpIDUwKSwKICBkZXNjcmlwdGlvbjogKHN0cmluZy1hc2NpaSAyNTApLAogIHByb3Bvc2VkQnk6IHByaW5jaXBhbCwKICBzdGFydEF0QmxvY2tIZWlnaHQ6IHVpbnQsCiAgZW5kQXRCbG9ja0hlaWdodDogdWludCwKICBleGVjdXRlOiBib29sCn0pCgo7OyBUaGVyZSBhcmUgc29tZSB1bm5lY2Vzc2FyeSBleHByZXNzaW9ucyB1c2VkIGluIHRoaXMgZnVuY3Rpb24sIHJlbW92ZSB0aGVtIAooZGVmaW5lLXB1YmxpYyAoY3JlYXRlLXByb3Bvc2FsICh0aXRsZSAoc3RyaW5nLWFzY2lpIDUwKSkgKGRlc2NyaXB0aW9uIChzdHJpbmctYXNjaWkgMjUwKSkpCiAgKGJlZ2luCiAgICAobGV0CiAgICAgICgKICAgICAgICAobmV4dFByb3Bvc2FsSWQgKHZhci1nZXQgcHJvcG9zYWxJZCkpCiAgICAgICkKICAgICAgKG1hcC1zZXQgUHJvcG9zYWxzIG5leHRQcm9wb3NhbElkIHsgdGl0bGU6IHRpdGxlLCBkZXNjcmlwdGlvbjogZGVzY3JpcHRpb24sIHByb3Bvc2VkQnk6IHR4LXNlbmRlciwgc3RhcnRBdEJsb2NrSGVpZ2h0OiAoKyBibG9jay1oZWlnaHQgdTE0NCksIGVuZEF0QmxvY2tIZWlnaHQ6ICgrIGJsb2NrLWhlaWdodCB1MTAwOCksIGV4ZWN1dGU6IGZhbHNlIH0pCiAgICAgICh2YXItc2V0IHByb3Bvc2FsSWQgKCsgKHZhci1nZXQgcHJvcG9zYWxJZCkgdTEpKQogICAgICAob2sgdHJ1ZSkKICAgICkKICApCikKCjs7IE9wdGltaXplIHRoaXMgZnVuY3Rpb24gc28gdGhhdCB3ZSBkb24ndCByZWFkIHRoZSBzYW1lIGRhdGEgbXVsdGlwbGUgdGltZXMKKGRlZmluZS1yZWFkLW9ubHkgKGdldC1wcm9wb3NhbCAoaWQgdWludCkpCiAgKGxldAogICAgKAogICAgICAodGl0bGUgKGdldCB0aXRsZSAobWFwLWdldD8gUHJvcG9zYWxzIGlkKSkpCiAgICAgIChkZXNjcmlwdGlvbiAoZ2V0IGRlc2NyaXB0aW9uIChtYXAtZ2V0PyBQcm9wb3NhbHMgaWQpKSkKICAgICAgKHByb3Bvc2VkQnkgKGdldCBwcm9wb3NlZEJ5IChtYXAtZ2V0PyBQcm9wb3NhbHMgaWQpKSkKICAgICkKICAgIHsgdGl0bGU6IHRpdGxlLCBkZXNjcmlwdGlvbjogZGVzY3JpcHRpb24sIHByb3Bvc2VkQnk6IHByb3Bvc2VkQnkgfQogICkKKQ)

   [Solution](https://play.hiro.so/?epoch=2.5&snippet=OzsgUHJvcG9zYWwgQ29udHJhY3QKCihkZWZpbmUtZGF0YS12YXIgcHJvcG9zYWxJZCB1aW50IHUwKQoKKGRlZmluZS1tYXAgUHJvcG9zYWxzIHVpbnQgewogIHRpdGxlOiAoc3RyaW5nLWFzY2lpIDUwKSwKICBkZXNjcmlwdGlvbjogKHN0cmluZy1hc2NpaSAyNTApLAogIHByb3Bvc2VkQnk6IHByaW5jaXBhbCwKICBzdGFydEF0QmxvY2tIZWlnaHQ6IHVpbnQsCiAgZW5kQXRCbG9ja0hlaWdodDogdWludCwKICBleGVjdXRlOiBib29sCn0pCgooZGVmaW5lLXB1YmxpYyAoY3JlYXRlLXByb3Bvc2FsICh0aXRsZSAoc3RyaW5nLWFzY2lpIDUwKSkgKGRlc2NyaXB0aW9uIChzdHJpbmctYXNjaWkgMjUwKSkpCiAgKGxldAogICAgKAogICAgICAobmV4dFByb3Bvc2FsSWQgKHZhci1nZXQgcHJvcG9zYWxJZCkpCiAgICApCiAgICAobWFwLXNldCBQcm9wb3NhbHMgbmV4dFByb3Bvc2FsSWQgeyB0aXRsZTogdGl0bGUsIGRlc2NyaXB0aW9uOiBkZXNjcmlwdGlvbiwgcHJvcG9zZWRCeTogdHgtc2VuZGVyLCBzdGFydEF0QmxvY2tIZWlnaHQ6ICgrIGJsb2NrLWhlaWdodCB1MTQ0KSwgZW5kQXRCbG9ja0hlaWdodDogKCsgYmxvY2staGVpZ2h0IHUxMDA4KSwgZXhlY3V0ZTogZmFsc2UgfSkKICAgIChvayAodmFyLXNldCBwcm9wb3NhbElkICgrICh2YXItZ2V0IHByb3Bvc2FsSWQpIHUxKSkpCiAgKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LXByb3Bvc2FsIChpZCB1aW50KSkKICAobWF0Y2ggKG1hcC1nZXQ_IFByb3Bvc2FscyBpZCkgcHJvcG9zYWwKICAgIChzb21lIHsgCiAgICAgIHRpdGxlOiAoZ2V0IHRpdGxlIHByb3Bvc2FsKSwgCiAgICAgIGRlc2NyaXB0aW9uOiAoZ2V0IGRlc2NyaXB0aW9uIHByb3Bvc2FsKSwgCiAgICAgIHByb3Bvc2VkQnk6IChnZXQgcHJvcG9zZWRCeSBwcm9wb3NhbCkgCiAgICB9KQogICAgbm9uZQogICkKKQ)

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

  [Problem](https://play.hiro.so/?epoch=2.5&snippet=OzsgVnVsbmVyYWJsZSBjb250cmFjdAoKKGRlZmluZS1jb25zdGFudCBFUlJfT05MWV9PV05FUiAoZXJyIHUxMDApKQooZGVmaW5lLWNvbnN0YW50IEVSUl9DQU1QQUlHTl9ET0VTX05PVF9FWElTVFMgKGVyciB1MTAxKSkKKGRlZmluZS1jb25zdGFudCBFUlJfQ0FNUEFJR05fTk9UX09WRVIgKGVyciB1MTAyKSkKCihkZWZpbmUtZGF0YS12YXIgY29udHJhY3RPd25lciBwcmluY2lwYWwgdHgtc2VuZGVyKQooZGVmaW5lLWRhdGEtdmFyIG5leHRDYW1wYWlnbklkIHVpbnQgdTEpCgooZGVmaW5lLW1hcCBDYW1wYWlnbnMgdWludCB7IHRpdGxlOiAoc3RyaW5nLWFzY2lpIDUwKSwgcHJvcG9zZWRCeTogcHJpbmNpcGFsLCBmdW5kc1JhaXNlZDogdWludCwgZW5kc0F0QmxvY2tIZWlnaHQ6IHVpbnQgfSkKCihkZWZpbmUtcHVibGljIChjcmVhdGUtY2FtcGFpZ24gKHRpdGxlIChzdHJpbmctYXNjaWkgNTApKSAoYW1vdW50IHVpbnQpKQogIChsZXQKICAgICgKICAgICAgKGNhbXBhaWduSWQgKHZhci1nZXQgbmV4dENhbXBhaWduSWQpKQogICAgKQogICAgKGJlZ2luCiAgICAgICh0cnkhIChzdHgtdHJhbnNmZXI_IGFtb3VudCB0eC1zZW5kZXIgKGFzLWNvbnRyYWN0IHR4LXNlbmRlcikpKQogICAgICAobWFwLXNldCBDYW1wYWlnbnMgY2FtcGFpZ25JZCB7IHRpdGxlOiB0aXRsZSwgcHJvcG9zZWRCeTogdHgtc2VuZGVyLCBmdW5kc1JhaXNlZDogYW1vdW50LCBlbmRzQXRCbG9ja0hlaWdodDogKCsgYmxvY2staGVpZ2h0IHUxNDQpIH0pCiAgICAgIChvayAodmFyLXNldCBuZXh0Q2FtcGFpZ25JZCAoKyBjYW1wYWlnbklkIHUxKSkpCiAgICApCiAgKQopCgooZGVmaW5lLXB1YmxpYyAoY2hhbmdlLW93bmVyIChuZXdPd25lciBwcmluY2lwYWwpKQogIChiZWdpbgogICAgKGFzc2VydHMhIChpcy1lcSB0eC1zZW5kZXIgKHZhci1nZXQgY29udHJhY3RPd25lcikpIEVSUl9PTkxZX09XTkVSKQogICAgKG9rICh2YXItc2V0IGNvbnRyYWN0T3duZXIgbmV3T3duZXIpKQogICkKKQoKOzsgT25seSB0aGUgYGNvbnRyYWN0T3duZXJgIGNhbiBjb250cm9sIHRoZSB3aXRoZHJhdyBvZiBmdW5kcwooZGVmaW5lLXB1YmxpYyAod2l0aGRyYXctZnVuZHMgKGNhbXBhaWduSWQgdWludCkgKGRlc3RpbmF0aW9uQWRkcmVzcyBwcmluY2lwYWwpKQogIChiZWdpbgogICAgKGFzc2VydHMhIChpcy1lcSB0eC1zZW5kZXIgKHZhci1nZXQgY29udHJhY3RPd25lcikpIEVSUl9PTkxZX09XTkVSKQogICAgKGFzc2VydHMhIChpcy1zb21lIChnZXQtY2FtcGFpZ24gY2FtcGFpZ25JZCkpIEVSUl9DQU1QQUlHTl9ET0VTX05PVF9FWElTVFMpCiAgICAoaWYgKD49IGJsb2NrLWhlaWdodCAodW53cmFwLXBhbmljIChnZXQgZW5kc0F0QmxvY2tIZWlnaHQgKGdldC1jYW1wYWlnbiBjYW1wYWlnbklkKSkpKQogICAgICAoYXMtY29udHJhY3QgKHN0eC10cmFuc2Zlcj8gKHVud3JhcC1wYW5pYyAoZ2V0IGZ1bmRzUmFpc2VkIChnZXQtY2FtcGFpZ24gY2FtcGFpZ25JZCkpKSB0eC1zZW5kZXIgZGVzdGluYXRpb25BZGRyZXNzKSkKICAgICAgRVJSX0NBTVBBSUdOX05PVF9PVkVSCiAgICApCiAgKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LWNhbXBhaWduIChpZCB1aW50KSkKICAobWFwLWdldD8gQ2FtcGFpZ25zIGlkKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LW93bmVyKQogICh2YXItZ2V0IGNvbnRyYWN0T3duZXIpCikKCjs7IFN0ZXBzCjs7IDEuIFRoZSB2dWxuZXJhYmxlIGNvbnRyYWN0IHNob3VsZCBiZSBkZXBsb3llZCBhdCBgY29udHJhY3QtMGAsIHNvIG1ha2Ugc3VyZSB0byByZWZlcmVuY2UgaXQuCjs7IDIuIFdyaXRlIHlvdXIgY29udHJhY3QgYXR0ZW1wdGluZyB0byBleHBsb2l0IHRoZSB2dWxuZXJhYmxlIGNvbnRyYWN0Lgo7OyAzLiBEZXBsb3kgYW4gdXBkYXRlZCB2dWxuZXJhYmxlIGNvbnRyYWN0IHdpdGggdGhlIG5lY2Vzc2FyeSBjaGFuZ2VzIHRoYXQgd291bGQgcHJldmVudCB5b3VyIGV4cGxvaXQu)
  [Solution](https://play.hiro.so/?epoch=2.5&snippet=OzsgVnVsbmVyYWJsZSBjb250cmFjdAoKOzsgKGRlZmluZS1jb25zdGFudCBFUlJfT05MWV9PV05FUiAoZXJyIHUxMDApKQo7OyAoZGVmaW5lLWNvbnN0YW50IEVSUl9DQU1QQUlHTl9ET0VTX05PVF9FWElTVFMgKGVyciB1MTAxKSkKOzsgKGRlZmluZS1jb25zdGFudCBFUlJfQ0FNUEFJR05fTk9UX09WRVIgKGVyciB1MTAyKSkKCjs7IChkZWZpbmUtZGF0YS12YXIgY29udHJhY3RPd25lciBwcmluY2lwYWwgdHgtc2VuZGVyKQo7OyAoZGVmaW5lLWRhdGEtdmFyIG5leHRDYW1wYWlnbklkIHVpbnQgdTEpCgo7OyAoZGVmaW5lLW1hcCBDYW1wYWlnbnMgdWludCB7IHRpdGxlOiAoc3RyaW5nLWFzY2lpIDUwKSwgcHJvcG9zZWRCeTogcHJpbmNpcGFsLCBmdW5kc1JhaXNlZDogdWludCwgZW5kc0F0QmxvY2tIZWlnaHQ6IHVpbnQgfSkKCjs7IChkZWZpbmUtcHVibGljIChjcmVhdGUtY2FtcGFpZ24gKHRpdGxlIChzdHJpbmctYXNjaWkgNTApKSAoYW1vdW50IHVpbnQpKQo7OyAgIChsZXQKOzsgICAgICgKOzsgICAgICAgKGNhbXBhaWduSWQgKHZhci1nZXQgbmV4dENhbXBhaWduSWQpKQo7OyAgICAgKQo7OyAgICAgKGJlZ2luCjs7ICAgICAgICh0cnkhIChzdHgtdHJhbnNmZXI_IGFtb3VudCB0eC1zZW5kZXIgKGFzLWNvbnRyYWN0IHR4LXNlbmRlcikpKQo7OyAgICAgICAobWFwLXNldCBDYW1wYWlnbnMgY2FtcGFpZ25JZCB7IHRpdGxlOiB0aXRsZSwgcHJvcG9zZWRCeTogdHgtc2VuZGVyLCBmdW5kc1JhaXNlZDogYW1vdW50LCBlbmRzQXRCbG9ja0hlaWdodDogKCsgYmxvY2staGVpZ2h0IHUxNDQpIH0pCjs7ICAgICAgIChvayAodmFyLXNldCBuZXh0Q2FtcGFpZ25JZCAoKyBjYW1wYWlnbklkIHUxKSkpCjs7ICAgICApCjs7ICAgKQo7OyApCgo7OyAoZGVmaW5lLXB1YmxpYyAoY2hhbmdlLW93bmVyIChuZXdPd25lciBwcmluY2lwYWwpKQo7OyAgIChiZWdpbgo7OyAgICAgKGFzc2VydHMhIChpcy1lcSB0eC1zZW5kZXIgKHZhci1nZXQgY29udHJhY3RPd25lcikpIEVSUl9PTkxZX09XTkVSKQo7OyAgICAgKG9rICh2YXItc2V0IGNvbnRyYWN0T3duZXIgbmV3T3duZXIpKQo7OyAgICkKOzsgKQoKOzsgOzsgT25seSB0aGUgYGNvbnRyYWN0T3duZXJgIGNhbiBjb250cm9sIHRoZSB3aXRoZHJhdyBvZiBmdW5kcwo7OyAoZGVmaW5lLXB1YmxpYyAod2l0aGRyYXctZnVuZHMgKGNhbXBhaWduSWQgdWludCkgKGRlc3RpbmF0aW9uQWRkcmVzcyBwcmluY2lwYWwpKQo7OyAgIChiZWdpbgo7OyAgICAgKGFzc2VydHMhIChpcy1lcSB0eC1zZW5kZXIgKHZhci1nZXQgY29udHJhY3RPd25lcikpIEVSUl9PTkxZX09XTkVSKQo7OyAgICAgKGFzc2VydHMhIChpcy1zb21lIChnZXQtY2FtcGFpZ24gY2FtcGFpZ25JZCkpIEVSUl9DQU1QQUlHTl9ET0VTX05PVF9FWElTVFMpCjs7ICAgICAoaWYgKD49IGJsb2NrLWhlaWdodCAodW53cmFwLXBhbmljIChnZXQgZW5kc0F0QmxvY2tIZWlnaHQgKGdldC1jYW1wYWlnbiBjYW1wYWlnbklkKSkpKQo7OyAgICAgICAoYXMtY29udHJhY3QgKHN0eC10cmFuc2Zlcj8gKHVud3JhcC1wYW5pYyAoZ2V0IGZ1bmRzUmFpc2VkIChnZXQtY2FtcGFpZ24gY2FtcGFpZ25JZCkpKSB0eC1zZW5kZXIgZGVzdGluYXRpb25BZGRyZXNzKSkKOzsgICAgICAgRVJSX0NBTVBBSUdOX05PVF9PVkVSCjs7ICAgICApCjs7ICAgKQo7OyApCgo7OyAoZGVmaW5lLXJlYWQtb25seSAoZ2V0LWNhbXBhaWduIChpZCB1aW50KSkKOzsgICAobWFwLWdldD8gQ2FtcGFpZ25zIGlkKQo7OyApCgo7OyAoZGVmaW5lLXJlYWQtb25seSAoZ2V0LW93bmVyKQo7OyAgICh2YXItZ2V0IGNvbnRyYWN0T3duZXIpCjs7ICkKCjs7IC0tLS0tCgo7OyBFeHBsb2l0IENvbnRyYWN0CgooZGVmaW5lLW5vbi1mdW5naWJsZS10b2tlbiBUcmlja3lORlQgdWludCkKKGRlZmluZS1kYXRhLXZhciBsYXN0SWQgdWludCB1MCkKCihkZWZpbmUtcHVibGljIChtaW50KQogIChsZXQKICAgICgKICAgICAgKG5ld0lkICgrICh2YXItZ2V0IGxhc3RJZCkgdTEpKQogICAgKSAKICAgIChpcy1vayAoY29udHJhY3QtY2FsbD8gLmNvbnRyYWN0LTAgY2hhbmdlLW93bmVyIENPTlRSQUNUX09XTkVSKSkgOzsgaWYgdGhlIGNvbnRyYWN0IG93bmVyIGdvZXMgdG8gbWludCB0aGlzIG5mdCwgaXQgd2lsbCB1bndpbGxpbmdseSBnbyBhbmQgdXBkYXRlIHRoZSBvd25lciBvZiB0aGUgY29udHJhY3QKICAgICh2YXItc2V0IGxhc3RJZCBuZXdJZCkKICAgIChuZnQtbWludD8gRmFuY3lORlQgbmV3SWQgdHgtc2VuZGVyKQogICkKKQoKOzsgVGhlIEZJWAo7OyBVc2UgYGNvbnRyYWN0LWNhbGxlcmAgaW5zdGVhZCBvZiBgdHgtc2VuZGVyYCwgd2hpY2ggd2lsbCBjaGFuZ2UgdGhlIGNvbnRleHQgb2YgdGhlIHByaW5jaXBhbCBjYWxsaW5nIGludG8gdGhlIHZ1bG5lcmFibGUgY29udHJhY3QKCjs7IChkZWZpbmUtcHVibGljIChjaGFuZ2Utb3duZXIgKG5ld093bmVyIHByaW5jaXBhbCkpCjs7ICAgKGJlZ2luCjs7ICAgICAoYXNzZXJ0cyEgKGlzLWVxIGNvbnRyYWN0LWNhbGxlciAodmFyLWdldCBjb250cmFjdE93bmVyKSkgRVJSX09OTFlfT1dORVIpCjs7ICAgICAob2sgKHZhci1zZXQgY29udHJhY3RPd25lciBuZXdPd25lcikpCjs7ICAgKQo7OyApCgo7OyBTdGVwcwo7OyAxLiBUaGUgdnVsbmVyYWJsZSBjb250cmFjdCBzaG91bGQgYmUgZGVwbG95ZWQgYXQgYGNvbnRyYWN0LTBgLCBzbyBtYWtlIHN1cmUgdG8gcmVmZXJlbmNlIGl0Lgo7OyAyLiBXcml0ZSB5b3VyIGNvbnRyYWN0IGF0dGVtcHRpbmcgdG8gZXhwbG9pdCB0aGUgdnVsbmVyYWJsZSBjb250cmFjdC4KOzsgMy4gRGVwbG95IGFuIHVwZGF0ZWQgdnVsbmVyYWJsZSBjb250cmFjdCB3aXRoIHRoZSBuZWNlc3NhcnkgY2hhbmdlcyB0aGF0IHdvdWxkIHByZXZlbnQgeW91ciBleHBsb2l0Lg)
