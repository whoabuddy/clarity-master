# Quiz 5: Public, Private, and Read-only Functions

1. Which of the following statements about `public`, `private`, and `read-only` functions in Clarity is true?
   a) Public functions can be called from other contracts, private functions cannot
   b) Read-only functions can not modify contract state
   c) Private functions can be called directly
   d) Both a and b

2. Which of the following is true regarding public functions and a read-only functions in Clarity?
   a) Public functions can modify state, read-only functions cannot
   b) Public functions must return a response type, read-only functions can return any type
   c) Public functions can be called from other contracts, read-only cannot
   d) Both a and b

3. When would you use the `as-contract` function?
   a) To call a private function from outside the contract
   b) To execute code with the contract's principal as the `tx-sender`
   c) To convert a public function to a read-only function
   d) To bypass permission checks in other contracts

4. True or False: In Clarity, private functions can call public functions within the same contract.

5. Which of the following is NOT a valid use case for a private function in Clarity?
   a) Implementing helper functions for internal use
   b) Performing complex calculations before returning a result
   c) Directly interacting with other contracts
   d) Modifying internal contract state

6. What happens if a `read-only` function attempts to modify contract state?
   a) It will throw a runtime error
   b) The state change will be ignored
   c) It will fail at compile-time
   d) The function will be automatically converted to a public function

7. In Clarity, how can you ensure that only the contract owner can call a specific public function?
   a) By using the `private` keyword
   b) By implementing a check on the `sender` and a stored principal representing the owner
   c) By using the `as-contract` function for the contract owner
   d) By marking the function as private with `define-private`

8. True or False: Public functions in Clarity can call other public functions using `contract-call?`.

**Bonus Coding Challenges**

9. Fix the bugs in the following code snippet:

   ```clojure
   (define-data-var txLog (list 100 uint) (list))

   (define-public (add-tx (amount uint))
     (var-set txLog (append txLog amount))
     (ok true)
   )

   (define-read-only (get-last-tx)
     (let
       (
         (logLength (len txLog))
       )
       (if (> logLength u0)
         (ok (element-at? txLog (- logLength u1)))
         (err u0)
       )
     )
   )

   (define-private (clear-log)
     (var-set txLog (list))
     (print "Log cleared")
   )

   (define-public (get-tx-count)
     (ok (len txLog))
   )
   ```

   [Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1kYXRhLXZhciB0eExvZyAobGlzdCAxMDAgdWludCkgKGxpc3QpKQoKKGRlZmluZS1wdWJsaWMgKGFkZC10eCAoYW1vdW50IHVpbnQpKQogICh2YXItc2V0IHR4TG9nIChhcHBlbmQgdHhMb2cgYW1vdW50KSkKICAob2sgdHJ1ZSkKKQoKKGRlZmluZS1yZWFkLW9ubHkgKGdldC1sYXN0LXR4KQogIChsZXQKICAgICgKICAgICAgKGxvZ0xlbmd0aCAobGVuIHR4TG9nKSkKICAgICkKICAgIChpZiAoPiBsb2dMZW5ndGggdTApCiAgICAgIChvayAoZWxlbWVudC1hdD8gdHhMb2cgKC0gbG9nTGVuZ3RoIHUxKSkpCiAgICAgIChlcnIgdTApCiAgICApCiAgKQopCgooZGVmaW5lLXByaXZhdGUgKGNsZWFyLWxvZykKICAodmFyLXNldCB0eExvZyAobGlzdCkpCiAgKHByaW50ICJMb2cgY2xlYXJlZCIpCikKCihkZWZpbmUtcHVibGljIChnZXQtdHgtY291bnQpCiAgKG9rIChsZW4gdHhMb2cpKQop)

   [Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1kYXRhLXZhciB0eExvZyAobGlzdCAxMDAgdWludCkgKGxpc3QpKQoKKGRlZmluZS1wdWJsaWMgKGFkZC10eCAoYW1vdW50IHVpbnQpKQogIChsZXQKICAgICgKICAgICAgKG5ld0xvZyAodW53cmFwISAoYXMtbWF4LWxlbj8gKGFwcGVuZCAodmFyLWdldCB0eExvZykgYW1vdW50KSB1MTAwKSAoZXJyIHUxKSkpCiAgICApCiAgICAoYmVnaW4KICAgICAgKHZhci1zZXQgdHhMb2cgbmV3TG9nKQogICAgICAob2sgdHJ1ZSkKICAgICkKICApCikKCihkZWZpbmUtcmVhZC1vbmx5IChnZXQtbGFzdC10eCkKICAobGV0CiAgICAoCiAgICAgIChsb2dMZW5ndGggKGxlbiAodmFyLWdldCB0eExvZykpKQogICAgKQogICAgKGlmICg-IGxvZ0xlbmd0aCB1MCkKICAgICAgKG9rIChlbGVtZW50LWF0PyAodmFyLWdldCB0eExvZykgKC0gbG9nTGVuZ3RoIHUxKSkpCiAgICAgIChlcnIgdTApCiAgICApCiAgKQopCgooZGVmaW5lLXB1YmxpYyAoY2xlYXItbG9nKQogIChiZWdpbgogICAgKHZhci1zZXQgdHhMb2cgKGxpc3QpKQogICAgKG9rIHRydWUpCiAgKQopCgooZGVmaW5lLXB1YmxpYyAoZ2V0LXR4LWNvdW50KQogIChvayAobGVuICh2YXItZ2V0IHR4TG9nKSkpCik)

10. Implement a public function called `withdraw` that allows only the contract owner to withdraw funds from the contract. Use a private function to check if the caller is the owner.

    ```clojure
    (define-constant CONTRACT_OWNER tx-sender)

    (define-private (check-owner)
      ;; Your code here
    )

    (define-public (withdraw (amount uint))
      ;; Your code here
    )

    ;; Test cases (NOTE: change `.your-contract` to the name of your contract, eg `contract-0`, etc)
    (stx-transfer? u100 tx-sender .your-contract) ;; transfer funds to the contract for testing withdraw
    (contract-call? .your-contract withdraw u100) ;; Should succeed if called by owner
    (as-contract (contract-call? .your-contract withdraw u100)) ;; Should fail
    ```

    [Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1jb25zdGFudCBDT05UUkFDVF9PV05FUiB0eC1zZW5kZXIpCgooZGVmaW5lLXByaXZhdGUgKGNoZWNrLW93bmVyKQogIDs7IFlvdXIgY29kZSBoZXJlCikKCihkZWZpbmUtcHVibGljICh3aXRoZHJhdyAoYW1vdW50IHVpbnQpKQogIDs7IFlvdXIgY29kZSBoZXJlCikKCjs7IFRlc3QgY2FzZXMgKE5PVEU6IGNoYW5nZSBgLnlvdXItY29udHJhY3RgIHRvIHRoZSBuYW1lIG9mIHlvdXIgY29udHJhY3QsIGVnIGBjb250cmFjdC0wYCwgZXRjKQooc3R4LXRyYW5zZmVyPyB1MTAwIHR4LXNlbmRlciAueW91ci1jb250cmFjdCkgOzsgdHJhbnNmZXIgZnVuZHMgdG8gdGhlIGNvbnRyYWN0IGZvciB0ZXN0aW5nIHdpdGhkcmF3Cihjb250cmFjdC1jYWxsPyAueW91ci1jb250cmFjdCB3aXRoZHJhdyB1MTAwKSA7OyBTaG91bGQgc3VjY2VlZCBpZiBjYWxsZWQgYnkgb3duZXIKKGFzLWNvbnRyYWN0IChjb250cmFjdC1jYWxsPyAueW91ci1jb250cmFjdCB3aXRoZHJhdyB1MTAwKSkgOzsgU2hvdWxkIGZhaWw)

    [Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1jb25zdGFudCBDT05UUkFDVF9PV05FUiB0eC1zZW5kZXIpCgooZGVmaW5lLXByaXZhdGUgKGNoZWNrLW93bmVyKQogIChpcy1lcSB0eC1zZW5kZXIgQ09OVFJBQ1RfT1dORVIpCikKCihkZWZpbmUtcHVibGljICh3aXRoZHJhdyAoYW1vdW50IHVpbnQpKQogIChiZWdpbgogICAgKGFzc2VydHMhIChjaGVjay1vd25lcikgKGVyciB1MSkpCiAgICAoYXMtY29udHJhY3QgKHN0eC10cmFuc2Zlcj8gYW1vdW50IHR4LXNlbmRlciBDT05UUkFDVF9PV05FUikpCiAgKQopCgo7OyBUZXN0IGNhc2VzIChOT1RFOiBjaGFuZ2UgYC55b3VyLWNvbnRyYWN0YCB0byB0aGUgbmFtZSBvZiB5b3VyIGNvbnRyYWN0LCBlZyBgY29udHJhY3QtMGAsIGV0YykKKHN0eC10cmFuc2Zlcj8gdTEwMCB0eC1zZW5kZXIgLnlvdXItY29udHJhY3QpIDs7IHRyYW5zZmVyIGZ1bmRzIHRvIHRoZSBjb250cmFjdCBmb3IgdGVzdGluZyB3aXRoZHJhdwooY29udHJhY3QtY2FsbD8gLnlvdXItY29udHJhY3Qgd2l0aGRyYXcgdTEwMCkgOzsgU2hvdWxkIHN1Y2NlZWQgaWYgY2FsbGVkIGJ5IG93bmVyCihhcy1jb250cmFjdCAoY29udHJhY3QtY2FsbD8gLnlvdXItY29udHJhY3Qgd2l0aGRyYXcgdTEwMCkpIDs7IFNob3VsZCBmYWls)
