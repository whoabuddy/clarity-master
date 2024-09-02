# Quiz 6: Contract Calling

1. What is the primary function used to call a public function in another contract?
   a) call-contract
   b) contract-call?
   c) invoke-contract
   d) external-call

2. True or False: When making an external contract call, the called contract can modify the calling contract's state directly.

3. Which of the following statements about the `contract-call?` function in Clarity is TRUE?
   a) It can be used to call public functions within the same contract
   b) It can only be used to call functions in other contracts
   c) It allows calling private functions in other contracts
   d) It automatically handles errors from the called function

4. What happens if a `contract-call?` to another contract returns an err response?
   a) The calling contract continues execution
   b) The calling contract throws an exception
   c) Any state changes in the calling contract are aborted
   d) The called contract is terminated

5. What is one way you can handle potential errors from an external contract call in Clarity?
   a) Using try-catch blocks
   b) By using the `err` function
   c) By using `match` expressions to handle ok and err results
   d) By setting a global error handler for the contract

6. What is the purpose of the `as-contract` function when used with the `contract-call?` function?
   a) To call a private function in another contract
   b) To execute the call with the current contract as the sender
   c) To bypass permission checks in the called contract
   d) To convert the response type to a boolean

7. True or False: In Clarity, you can make an external contract call to a contract that hasn't been deployed yet by using its future contract address.

8. What does the `contract-caller` keyword return when used within a contract that was called by another contract?
   a) The principal of the user who initiated the transaction
   b) The principal of the contract making the `contract-call?`
   c) The principal of the current contract
   d) None of the above

**Bonus Coding Challenges**

9. Spot the bug in the following contract. Find and fix the bug to get the test case to pass.

   ```clojure
   (define-constant CONTRACT_OWNER tx-sender)

   (define-public (transfer (to principal) (amount uint))
     (begin
       (asserts! (is-eq tx-sender CONTRACT_OWNER) (err u401))
       (as-contract (stx-transfer? amount tx-sender to))
     )
   )

   ;; Test cases (replace `your-contract` with your contract address)
   ;; (contract-call? .your-contract transfer 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 u100)
   ```

   [Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1jb25zdGFudCBDT05UUkFDVF9PV05FUiB0eC1zZW5kZXIpCgooZGVmaW5lLXB1YmxpYyAodHJhbnNmZXIgKHRvIHByaW5jaXBhbCkgKGFtb3VudCB1aW50KSkKICAoYmVnaW4KICAgIChhc3NlcnRzISAoaXMtZXEgdHgtc2VuZGVyIENPTlRSQUNUX09XTkVSKSAoZXJyIHU0MDEpKQogICAgKGFzLWNvbnRyYWN0IChzdHgtdHJhbnNmZXI_IGFtb3VudCB0eC1zZW5kZXIgdG8pKQogICkKKQoKOzsgVGVzdCBjYXNlcyAocmVwbGFjZSBgeW91ci1jb250cmFjdGAgd2l0aCB5b3VyIGNvbnRyYWN0IGFkZHJlc3MpCjs7IChjb250cmFjdC1jYWxsPyAueW91ci1jb250cmFjdCB0cmFuc2ZlciAnU1QxU0ozRFRFNURON1g1NFlESDVENjRSM0JDQjZBMkFHMlpROFlQRDUgdTEwMCk)

   [Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1jb25zdGFudCBDT05UUkFDVF9PV05FUiB0eC1zZW5kZXIpCgooZGVmaW5lLXB1YmxpYyAodHJhbnNmZXIgKHRvIHByaW5jaXBhbCkgKGFtb3VudCB1aW50KSkKICAoYmVnaW4KICAgIChhc3NlcnRzISAoaXMtZXEgdHgtc2VuZGVyIENPTlRSQUNUX09XTkVSKSAoZXJyIHU0MDEpKQogICAgKHN0eC10cmFuc2Zlcj8gYW1vdW50IHR4LXNlbmRlciB0bykKICApCikKCihjb250cmFjdC1jYWxsPyAueW91ci1jb250cmFjdCB0cmFuc2ZlciAnU1QxU0ozRFRFNURON1g1NFlESDVENjRSM0JDQjZBMkFHMlpROFlQRDUgdTEwMCk)

10. Implement a smart contract for a time-locked wallet with the following features:

- A user can deploy the contract and lock tokens with a specified unlock height and beneficiary.
- Anyone can send tokens to the contract.
- The beneficiary can claim the tokens once the specified block height is reached.
- The beneficiary can transfer the right to claim the wallet to a different principal.

```clojure
;; Time-Locked Wallet

;; Constants and Storage
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_ALREADY_LOCKED (err u101))
(define-constant ERR_NOT_UNLOCKED (err u102))

(define-data-var beneficiary (optional principal) none)
(define-data-var unlockHeight uint u0)
(define-data-var balance uint u0)

;; Public Functions

(define-public (lock (newBeneficiary principal) (unlockAt uint) (amount uint))
  ;; Implement the lock function
)

(define-public (claim)
  ;; Implement the claim function
)

(define-public (bestow (newBeneficiary principal))
  ;; Implement the bestow function
)

;; Read-only Functions

(define-read-only (get-beneficiary)
  (ok (var-get beneficiary))
)

(define-read-only (get-unlock-height)
  (ok (var-get unlockHeight))
)

(define-read-only (get-balance)
  (ok (var-get balance))
)

;; Test cases (uncomment to run)

;; Test: Lock tokens
;; (print (lock tx-sender u100 u1000))
;; (print (get-beneficiary))
;; (print (get-unlock-height))
;; (print (get-balance))

;; Test: Attempt to claim before unlock height
;; (print (claim))

;; Test: Bestow to new beneficiary
;; (define-constant new-beneficiary 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK)
;; (print (bestow new-beneficiary))
;; (print (get-beneficiary))

;; Test: Claim after unlock height (you'll need to advance the block height in your test environment)
;; (print (claim))
;; (print (get-balance))
```

[Problem](https://play.hiro.so/?epoch=2.5&snippet=OzsgVGltZS1Mb2NrZWQgV2FsbGV0Cgo7OyBDb25zdGFudHMgYW5kIFN0b3JhZ2UKKGRlZmluZS1jb25zdGFudCBFUlJfTk9UX0FVVEhPUklaRUQgKGVyciB1MTAwKSkKKGRlZmluZS1jb25zdGFudCBFUlJfQUxSRUFEWV9MT0NLRUQgKGVyciB1MTAxKSkKKGRlZmluZS1jb25zdGFudCBFUlJfTk9UX1VOTE9DS0VEIChlcnIgdTEwMikpCihkZWZpbmUtY29uc3RhbnQgRVJSX05PX1ZBTFVFIChlcnIgdTEwMykpCgooZGVmaW5lLWRhdGEtdmFyIGJlbmVmaWNpYXJ5IChvcHRpb25hbCBwcmluY2lwYWwpIG5vbmUpCihkZWZpbmUtZGF0YS12YXIgdW5sb2NrSGVpZ2h0IHVpbnQgdTApCihkZWZpbmUtZGF0YS12YXIgYmFsYW5jZSB1aW50IHUwKQoKOzsgUHVibGljIEZ1bmN0aW9ucwoKKGRlZmluZS1wdWJsaWMgKGxvY2sgKG5ld0JlbmVmaWNpYXJ5IHByaW5jaXBhbCkgKHVubG9ja0F0IHVpbnQpIChhbW91bnQgdWludCkpCiAgOzsgSW1wbGVtZW50IHRoZSBsb2NrIGZ1bmN0aW9uCikKCihkZWZpbmUtcHVibGljIChjbGFpbSkKICA7OyBJbXBsZW1lbnQgdGhlIGNsYWltIGZ1bmN0aW9uCikKCihkZWZpbmUtcHVibGljIChiZXN0b3cgKG5ld0JlbmVmaWNpYXJ5IHByaW5jaXBhbCkpCiAgOzsgSW1wbGVtZW50IHRoZSBiZXN0b3cgZnVuY3Rpb24KKQoKOzsgUmVhZC1vbmx5IEZ1bmN0aW9ucwoKKGRlZmluZS1yZWFkLW9ubHkgKGdldC1iZW5lZmljaWFyeSkKICAob2sgKHZhci1nZXQgYmVuZWZpY2lhcnkpKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LXVubG9jay1oZWlnaHQpCiAgKG9rICh2YXItZ2V0IHVubG9ja0hlaWdodCkpCikKCihkZWZpbmUtcmVhZC1vbmx5IChnZXQtYmFsYW5jZSkKICAob2sgKHZhci1nZXQgYmFsYW5jZSkpCikKCjs7IFRlc3QgY2FzZXMKCjs7IFRlc3Q6IExvY2sgdG9rZW5zCjs7IChwcmludCAobG9jayB0eC1zZW5kZXIgdTEwMCB1MTAwMCkpCjs7IChwcmludCAoZ2V0LWJlbmVmaWNpYXJ5KSkKOzsgKHByaW50IChnZXQtdW5sb2NrLWhlaWdodCkpCjs7IChwcmludCAoZ2V0LWJhbGFuY2UpKQoKOzsgVGVzdDogQXR0ZW1wdCB0byBjbGFpbSBiZWZvcmUgdW5sb2NrIGhlaWdodAo7OyAocHJpbnQgKGNsYWltKSkKCjs7IFRlc3Q6IEJlc3RvdyB0byBuZXcgYmVuZWZpY2lhcnkKOzsgKGRlZmluZS1jb25zdGFudCBORVdfQkVORUZJQ0lBUlkgJ1NUMUo0RzZSUjY0M0JDRzhHOFNSNk0yRDlaOUtYVDJOSkRSSzNGQlRLKQo7OyAocHJpbnQgKGJlc3RvdyBORVdfQkVORUZJQ0lBUlkpKQo7OyAocHJpbnQgKGdldC1iZW5lZmljaWFyeSkpCgo7OyBUZXN0OiBDbGFpbSBhZnRlciB1bmxvY2sgaGVpZ2h0ICh5b3UnbGwgbmVlZCB0byBhZHZhbmNlIHRoZSBibG9jayBoZWlnaHQgaW4geW91ciB0ZXN0IGVudmlyb25tZW50KQo7OyAocHJpbnQgKGNsYWltKSkKOzsgKHByaW50IChnZXQtYmFsYW5jZSkp)
[Solution](https://play.hiro.so/?epoch=2.5&snippet=OzsgVGltZS1Mb2NrZWQgV2FsbGV0Cgo7OyBDb25zdGFudHMgYW5kIFN0b3JhZ2UKKGRlZmluZS1jb25zdGFudCBFUlJfTk9UX0FVVEhPUklaRUQgKGVyciB1MTAwKSkKKGRlZmluZS1jb25zdGFudCBFUlJfQUxSRUFEWV9MT0NLRUQgKGVyciB1MTAxKSkKKGRlZmluZS1jb25zdGFudCBFUlJfTk9UX1VOTE9DS0VEIChlcnIgdTEwMikpCihkZWZpbmUtY29uc3RhbnQgRVJSX05PX1ZBTFVFIChlcnIgdTEwMykpCgooZGVmaW5lLWRhdGEtdmFyIGJlbmVmaWNpYXJ5IChvcHRpb25hbCBwcmluY2lwYWwpIG5vbmUpCihkZWZpbmUtZGF0YS12YXIgdW5sb2NrSGVpZ2h0IHVpbnQgdTApCihkZWZpbmUtZGF0YS12YXIgYmFsYW5jZSB1aW50IHUwKQoKOzsgUHVibGljIEZ1bmN0aW9ucwoKKGRlZmluZS1wdWJsaWMgKGxvY2sgKG5ld0JlbmVmaWNpYXJ5IHByaW5jaXBhbCkgKHVubG9ja0F0IHVpbnQpIChhbW91bnQgdWludCkpCiAgKGJlZ2luCiAgICAoYXNzZXJ0cyEgKGlzLWVxIHR4LXNlbmRlciBjb250cmFjdC1jYWxsZXIpIEVSUl9OT1RfQVVUSE9SSVpFRCkKICAgIChhc3NlcnRzISAoaXMtbm9uZSAodmFyLWdldCBiZW5lZmljaWFyeSkpIEVSUl9BTFJFQURZX0xPQ0tFRCkKICAgIChhc3NlcnRzISAoPiBhbW91bnQgdTApIEVSUl9OT19WQUxVRSkKICAgIChhc3NlcnRzISAoPiB1bmxvY2tBdCBibG9jay1oZWlnaHQpIEVSUl9BTFJFQURZX0xPQ0tFRCkKICAgICh0cnkhIChzdHgtdHJhbnNmZXI_IGFtb3VudCB0eC1zZW5kZXIgKGFzLWNvbnRyYWN0IHR4LXNlbmRlcikpKQogICAgKHZhci1zZXQgYmVuZWZpY2lhcnkgKHNvbWUgbmV3QmVuZWZpY2lhcnkpKQogICAgKHZhci1zZXQgdW5sb2NrSGVpZ2h0IHVubG9ja0F0KQogICAgKHZhci1zZXQgYmFsYW5jZSBhbW91bnQpCiAgICAob2sgdHJ1ZSkpCikKCihkZWZpbmUtcHVibGljIChjbGFpbSkKICAobGV0CiAgICAoCiAgICAgIChjdXJyZW50QmVuZWZpY2lhcnkgKHVud3JhcCEgKHZhci1nZXQgYmVuZWZpY2lhcnkpIEVSUl9OT1RfQVVUSE9SSVpFRCkpCiAgICAgIChjdXJyZW50QmFsYW5jZSAodmFyLWdldCBiYWxhbmNlKSkKICAgICkKICAgIChhc3NlcnRzISAoaXMtZXEgY3VycmVudEJlbmVmaWNpYXJ5IHR4LXNlbmRlcikgRVJSX05PVF9BVVRIT1JJWkVEKQogICAgKGFzc2VydHMhICg-PSBibG9jay1oZWlnaHQgKHZhci1nZXQgdW5sb2NrSGVpZ2h0KSkgRVJSX05PVF9VTkxPQ0tFRCkKICAgIChhc3NlcnRzISAoPiBjdXJyZW50QmFsYW5jZSB1MCkgRVJSX05PX1ZBTFVFKQogICAgKHZhci1zZXQgYmFsYW5jZSB1MCkKICAgIChhcy1jb250cmFjdCAoc3R4LXRyYW5zZmVyPyBjdXJyZW50QmFsYW5jZSB0eC1zZW5kZXIgY3VycmVudEJlbmVmaWNpYXJ5KSkpCikKCihkZWZpbmUtcHVibGljIChiZXN0b3cgKG5ld0JlbmVmaWNpYXJ5IHByaW5jaXBhbCkpCiAgKGJlZ2luCiAgICAoYXNzZXJ0cyEgKGlzLWVxIChzb21lIHR4LXNlbmRlcikgKHZhci1nZXQgYmVuZWZpY2lhcnkpKSBFUlJfTk9UX0FVVEhPUklaRUQpCiAgICAodmFyLXNldCBiZW5lZmljaWFyeSAoc29tZSBuZXdCZW5lZmljaWFyeSkpCiAgICAob2sgdHJ1ZSkKICApCikKCjs7IFJlYWQtb25seSBGdW5jdGlvbnMKCihkZWZpbmUtcmVhZC1vbmx5IChnZXQtYmVuZWZpY2lhcnkpCiAgKG9rICh2YXItZ2V0IGJlbmVmaWNpYXJ5KSkKKQoKKGRlZmluZS1yZWFkLW9ubHkgKGdldC11bmxvY2staGVpZ2h0KQogIChvayAodmFyLWdldCB1bmxvY2tIZWlnaHQpKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LWJhbGFuY2UpCiAgKG9rICh2YXItZ2V0IGJhbGFuY2UpKQopCgo7OyBUZXN0IGNhc2VzCgo7OyBUZXN0OiBMb2NrIHRva2Vucwo7OyAocHJpbnQgKGxvY2sgdHgtc2VuZGVyIHUxMDAgdTEwMDApKQo7OyAocHJpbnQgKGdldC1iZW5lZmljaWFyeSkpCjs7IChwcmludCAoZ2V0LXVubG9jay1oZWlnaHQpKQo7OyAocHJpbnQgKGdldC1iYWxhbmNlKSkKCjs7IFRlc3Q6IEF0dGVtcHQgdG8gY2xhaW0gYmVmb3JlIHVubG9jayBoZWlnaHQKOzsgKHByaW50IChjbGFpbSkpCgo7OyBUZXN0OiBCZXN0b3cgdG8gbmV3IGJlbmVmaWNpYXJ5Cjs7IChkZWZpbmUtY29uc3RhbnQgTkVXX0JFTkVGSUNJQVJZICdTVDFKNEc2UlI2NDNCQ0c4RzhTUjZNMkQ5WjlLWFQyTkpEUkszRkJUSykKOzsgKHByaW50IChiZXN0b3cgTkVXX0JFTkVGSUNJQVJZKSkKOzsgKHByaW50IChnZXQtYmVuZWZpY2lhcnkpKQoKOzsgVGVzdDogQ2xhaW0gYWZ0ZXIgdW5sb2NrIGhlaWdodCAoeW91J2xsIG5lZWQgdG8gYWR2YW5jZSB0aGUgYmxvY2sgaGVpZ2h0IGluIHlvdXIgdGVzdCBlbnZpcm9ubWVudCkKOzsgKHByaW50IChjbGFpbSkpCjs7IChwcmludCAoZ2V0LWJhbGFuY2UpKQ)
