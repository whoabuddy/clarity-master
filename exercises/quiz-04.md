# Quiz 4: Tuples and Lists

1. Which of the following correctly defines a tuple in Clarity?

- a) (tuple (name "Alice") (age 30))
- b) {name: "Alice", age: 30}
- c) (define-tuple user (name "Alice") (age 30))
- d) Both a and b

2. True or False: In Clarity, a tuple can have another tuple as a value.

3. How do you access an element in a Clarity list?

- a) (list-get my-list 0)
- b) (get my-list 0)
- c) (element-at? my-list u0)
- d) (index-of? my-list element)

4. Which function is used to add an item to the end of a list in Clarity?

- a) push
- b) append
- c) add
- d) concat

5. You encounter the following error in your Clarity contract. What is the most likely cause of this error?
   `Contract deployment runtime error: ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.contract-1 -> expecting expression of type 'uint', found '(tuple (active bool) (amount uint))'`

- a) The contract is trying to access or set a tuple field that doesn't exist
- b) The contract is expecting an `uint` type where an `int` is required
- c) The contract is trying to store a data structure that is too complex
- d) The contract is attempting to perform an operation on a non-existent map

6. Consider the following Clarity code snippet:

```clojure
(define-data-var userName (string-ascii 50) "")
(define-data-var userAge uint u0)
(define-data-var userBalance uint u0)
(define-data-var userActive bool false)
```

If I wanted a way to retrieve a specific user, what would be the most efficient way to improve this code structure?

- a) Use a `list` to store all user information
- b) Create separate maps for each user using a unique identifier as the key
- c) Use a single `map` with a tuple to store all user information
- d) Keep the current structure as it's already optimal

7. True or False: In Clarity, can a `list` contain elements of different types.

8. What is the result of `(len (list 1 2 3 4 5))` in Clarity?

- a) 5
- b) u5
- c) (ok 5)
- d) (some 5)

**Bonus Coding Challenges**

9. Create a function that takes a tuple representing a person (with name and age fields) and returns a list containing the name and age as separate elements.

```clojure
;; Implement the person-tuple-to-list function here
(define-public (person-tuple-to-list (person (tuple (name (string-ascii 50)) (age uint))))
  ;; Your code here
)

;; Test cases
(person-tuple-to-list (tuple (name "Bob") (age u25))) ;; Should return (ok (list "Bob" u25))
(person-tuple-to-list (tuple (name "Alice") (age u30))) ;; Should return (ok (list "Alice" u30))
```

**Hint:**

- Remember, `list` can only contain elements of the _same data type_, so `string-ascii` and `uint` will need to be of the same type. One of them will need to be converted to match the other…

10. Implement a function called `add-todo` that adds a new todo item to a list of recent todos. The function should maintain a maximum of 5 todos in the list, and returns an error when trying to add an item above the limit.

```clojure
(define-data-var recentTodos (list 5 (string-ascii 50)) (list))

(define-public (add-todo (todo (string-ascii 50)))
  ;; Your code here
)

;; Test cases
(add-todo "Buy groceries")
(add-todo "Call mom")
(add-todo "Finish report")
(add-todo "Go to gym")
(add-todo "Read book")
(add-todo "Learn Clarity") ;; This should return an error
(var-get recentTodos) ;; Should return (list "Read book" "Go to gym" "Finish report" "Call mom")
```
