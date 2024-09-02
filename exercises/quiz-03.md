# Quiz 3: Maps and Variables

1. What is the primary purpose of `define-map` in Clarity?
   a) To create a new variable
   b) To define a new function
   c) To create a key-value store
   d) To import external libraries

2. Which function is used to retrieve an entry from a map in Clarity?
   a) map-get
   b) map-set
   c) map-get?
   d) map-retrieve

3. What is the correct way to define a new variable in Clarity?
   a) (define-var counter into 0)
   b) (define-data-var counter int 0)
   c) (var-define counter int 0)
   d) (define-data-var int 0)

4. Which of the following is true about `**var-set`\*\* in Clarity?
   a) It creates a new variable
   b) It always returns false
   c) It can only be used with maps
   d) It updates the value of an existing variable

5. What is the difference between `**map-set`** and `**map-insert`\*\* in Clarity?
a) There is no difference, they are interchangeable
b) `map-set`overwrites existing values, while`map-insert`only adds new entries
c)`map-set`is for maps, while`map-insert`is for lists
d)`map-set`is read-only, while`map-insert` allows modifications

6. Which function is used to remove an entry from a map in Clarity?
   a) map-remove
   b) map-delete
   c) map-erase
   d) map-clear

7. What does the `**var-get`\*\* function do in Clarity?
   a) Creates a new variable
   b) Retrieves the value of a defined variable
   c) Checks if a variable exists
   d) Deletes a variable

8. In Clarity, what is the maximum number of entries a map can hold?
   a) 100
   b) 1,000
   c) 4,999
   d) There is no fixed limit

9. You're building a voting system where each user can only vote once. Which of the following approaches is the most efficient and secure way to track votes?
   a) Use a data variable to store a `list` of all voters
   b) Use a `map` with the voter's principal as the key and their vote as the value
   c) Use a data variable to store the total vote count and check off-chain if a user has voted
   d) Use a `map` with `uint` representing the Proposal ID as the key and a `list` of voters as the value

10. Consider the following Clarity code snippet:

```clojure
(define-data-var userName (string-ascii 50) "")
(define-data-var userAge uint u0)
(define-data-var userBalance uint u0)
(define-data-var userActive bool false)
```

If I wanted a way to retrieve a specific user, what would be the most efficient way to improve this code structure?
a) Use a `list` to store all user information
b) Create separate maps for each user using a unique identifier as the key
c) Use a single `map` with a tuple to store all user information
d) Keep the current structure as it's already optimal

**Bonus Coding Challenges**

11. Create a map called `UserProfiles` that stores a name and age for a `principal`. Then, write a function to get an entry for a user. (If you’re feeling extra, see if you can `get` a specific property from the entry like `name` or `age`)

```clojure
(define-read-only (get-profile (who principal))
	;; Your code here
)

;; Test cases
(get-profile 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Should return a user
```

[Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1yZWFkLW9ubHkgKGdldC1wcm9maWxlICh3aG8gcHJpbmNpcGFsKSkKCTs7IFlvdXIgY29kZSBoZXJlCikKCjs7IFRlc3QgY2FzZXMKKGdldC1wcm9maWxlICdTVDFQUUhRS1YwUkpYWkZZMURHWDhNTlNOWVZFM1ZHWkpTUlRQR1pHTSkgOzsgU2hvdWxkIHJldHVybiBhIHVzZXI)

[Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1tYXAgVXNlclByb2ZpbGVzIHByaW5jaXBhbCB7IG5hbWU6IChzdHJpbmctYXNjaWkgNTApLCBhZ2U6IHVpbnQgfSkKCjs7IEltcGxlbWVudCB0aGUgZ2V0LWJhbGFuY2UgZnVuY3Rpb24gaGVyZQooZGVmaW5lLXJlYWQtb25seSAoZ2V0LXByb2ZpbGUgKHdobyBwcmluY2lwYWwpKQoJKG1hcC1nZXQ_IFVzZXJQcm9maWxlcyB3aG8pCikKCihkZWZpbmUtcmVhZC1vbmx5IChnZXQtbmFtZSAod2hvIHByaW5jaXBhbCkpCgkoZ2V0IG5hbWUgKGdldC1wcm9maWxlIHdobykpCikKCjs7IFRlc3QgY2FzZXMKKG1hcC1zZXQgVXNlclByb2ZpbGVzIHR4LXNlbmRlciB7IG5hbWU6ICJSeWFuIiwgYWdlOiB1Mzl9KQooZ2V0LXByb2ZpbGUgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNKSA7OyBTaG91bGQgcmV0dXJuIGEgdXNlcgooZ2V0LW5hbWUgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNKQ)

12. Implement a simple voting system using maps and variables. Create functions to register voters, cast votes, and get the current vote count for candidates. Ensure that each voter can only vote once and only registered voters can cast votes.

```clojure
(define-map Voters principal bool)
(define-map VoteCounts principal uint)
(define-data-var TotalVotes uint u0)

;; Implement the register-voter function
(define-public (register-voter (voter principal))
  ;; Your code here
)

;; Implement the cast-vote function
(define-public (cast-vote (voter principal) (candidate principal))
  ;; Your code here
)

;; Implement the get-vote-count function
(define-read-only (get-vote-count (candidate principal))
  ;; Your code here
)

;; Test cases
(register-voter 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(cast-vote 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
(cast-vote 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Should fail (already voted)
(get-vote-count 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG) ;; Should return (ok u1)
```

[Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1tYXAgVm90ZXJzIHByaW5jaXBhbCBib29sKQooZGVmaW5lLW1hcCBWb3RlQ291bnRzIHByaW5jaXBhbCB1aW50KQooZGVmaW5lLWRhdGEtdmFyIFRvdGFsVm90ZXMgdWludCB1MCkKCjs7IEltcGxlbWVudCB0aGUgcmVnaXN0ZXItdm90ZXIgZnVuY3Rpb24KKGRlZmluZS1wdWJsaWMgKHJlZ2lzdGVyLXZvdGVyICh2b3RlciBwcmluY2lwYWwpKQogIDs7IFlvdXIgY29kZSBoZXJlCikKCjs7IEltcGxlbWVudCB0aGUgY2FzdC12b3RlIGZ1bmN0aW9uCihkZWZpbmUtcHVibGljIChjYXN0LXZvdGUgKHZvdGVyIHByaW5jaXBhbCkgKGNhbmRpZGF0ZSBwcmluY2lwYWwpKQogIDs7IFlvdXIgY29kZSBoZXJlCikKCjs7IEltcGxlbWVudCB0aGUgZ2V0LXZvdGUtY291bnQgZnVuY3Rpb24KKGRlZmluZS1yZWFkLW9ubHkgKGdldC12b3RlLWNvdW50IChjYW5kaWRhdGUgcHJpbmNpcGFsKSkKICA7OyBZb3VyIGNvZGUgaGVyZQopCgo7OyBUZXN0IGNhc2VzCihyZWdpc3Rlci12b3RlciAnU1QxUFFIUUtWMFJKWFpGWTFER1g4TU5TTllWRTNWR1pKU1JUUEdaR00pIDs7IFNob3VsZCByZXR1cm4gKG9rIHRydWUpCihjYXN0LXZvdGUgdHgtc2VuZGVyICdTVDJDWTVWMzlOSERQV1NYTVc5UURUM0hDM0dENlE2WFg0Q0ZSSzlBRykgOzsgU2hvdWxkIHJldHVybiAob2sgdHJ1ZSkKKGNhc3Qtdm90ZSB0eC1zZW5kZXIgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNKSA7OyBTaG91bGQgZmFpbCAoZXJyIHUyKSBhbHJlYWR5IHZvdGVkCihnZXQtdm90ZS1jb3VudCAnU1QyQ1k1VjM5TkhEUFdTWE1XOVFEVDNIQzNHRDZRNlhYNENGUks5QUcpIDs7IFNob3VsZCByZXR1cm4gKHUxKQ)

[Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1tYXAgVm90ZXJzIHByaW5jaXBhbCBib29sKQooZGVmaW5lLW1hcCBWb3RlQ291bnRzIHByaW5jaXBhbCB1aW50KQooZGVmaW5lLWRhdGEtdmFyIHRvdGFsVm90ZXMgdWludCB1MCkKCihkZWZpbmUtcHVibGljIChyZWdpc3Rlci12b3RlciAodm90ZXIgcHJpbmNpcGFsKSkKICAoaWYgKGRlZmF1bHQtdG8gZmFsc2UgKG1hcC1nZXQ_IFZvdGVycyB2b3RlcikpCiAgICAoZXJyIHUxKSA7OyBWb3RlciBhbHJlYWR5IHJlZ2lzdGVyZWQKICAgIChvayAobWFwLXNldCBWb3RlcnMgdm90ZXIgdHJ1ZSkpCiAgKQopCgooZGVmaW5lLXB1YmxpYyAoY2FzdC12b3RlICh2b3RlciBwcmluY2lwYWwpIChjYW5kaWRhdGUgcHJpbmNpcGFsKSkKICAobGV0CiAgICAoCiAgICAgIChpc1JlZ2lzdGVyZWQgKGRlZmF1bHQtdG8gZmFsc2UgKG1hcC1nZXQ_IFZvdGVycyB2b3RlcikpKQogICAgKQogICAgKGlmIChhbmQgaXNSZWdpc3RlcmVkIChpcy1lcSAoZ2V0LXZvdGUtY291bnQgdm90ZXIpIHUwKSkKICAgICAgKGJlZ2luCiAgICAgICAgKG1hcC1zZXQgVm90ZUNvdW50cyBjYW5kaWRhdGUgKCsgKGRlZmF1bHQtdG8gdTAgKG1hcC1nZXQ_IFZvdGVDb3VudHMgY2FuZGlkYXRlKSkgdTEpKQogICAgICAgICh2YXItc2V0IHRvdGFsVm90ZXMgKCsgKHZhci1nZXQgdG90YWxWb3RlcykgdTEpKQogICAgICAgIChvayB0cnVlKQogICAgICApCiAgICAgIChlcnIgdTIpIDs7IE5vdCByZWdpc3RlcmVkIG9yIGFscmVhZHkgdm90ZWQKICAgICkKICApCikKCihkZWZpbmUtcmVhZC1vbmx5IChnZXQtdm90ZS1jb3VudCAoY2FuZGlkYXRlIHByaW5jaXBhbCkpCiAgKGRlZmF1bHQtdG8gdTAgKG1hcC1nZXQ_IFZvdGVDb3VudHMgY2FuZGlkYXRlKSkKKQoKOzsgVGVzdCBjYXNlcwoocmVnaXN0ZXItdm90ZXIgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNKSA7OyBTaG91bGQgcmV0dXJuIChvayB0cnVlKQooY2FzdC12b3RlIHR4LXNlbmRlciAnU1QyQ1k1VjM5TkhEUFdTWE1XOVFEVDNIQzNHRDZRNlhYNENGUks5QUcpIDs7IFNob3VsZCByZXR1cm4gKG9rIHRydWUpCihjYXN0LXZvdGUgdHgtc2VuZGVyICdTVDFQUUhRS1YwUkpYWkZZMURHWDhNTlNOWVZFM1ZHWkpTUlRQR1pHTSkgOzsgU2hvdWxkIGZhaWwgKGVyciB1MikgYWxyZWFkeSB2b3RlZAooZ2V0LXZvdGUtY291bnQgJ1NUMkNZNVYzOU5IRFBXU1hNVzlRRFQzSEMzR0Q2UTZYWDRDRlJLOUFHKSA7OyBTaG91bGQgcmV0dXJuICh1MSk)
