;; 10. In this code snippet, implement a function called `add-todo` that adds a new todo item
;; to a list of recent todos. The function should maintain a maximum of 5 todos in the list,
;; and returns an error when trying to add an item above the limit.

;; title: ex4-02
;; version: 1.0.0
;; summary: Todo list for the overworked

;; constants
;;
(define-constant ERR_LIST_FULL (err u401))

;; data vars
;;
(define-data-var recentTodos (list 5 (string-ascii 50)) (list))

;; public functions
;;

;; fails if the list gets too long
(define-public (add-todo (todo (string-ascii 50)))
  (let
    (
      (currentList (var-get recentTodos))
      (newList (append currentList todo))
      (updatedList (unwrap! (as-max-len? newList u5) ERR_LIST_FULL))
    )
    (var-set recentTodos updatedList)
    (ok true)
  )
)

;; read only functions
;;
(define-read-only (get-todo-list)
  (var-get recentTodos)
)

;; test cases
(add-todo "Buy groceries")
(add-todo "Call mom")
(add-todo "Finish report")
(add-todo "Go to gym")
(add-todo "Read book")
(add-todo "Learn Clarity") ;; This should return an error