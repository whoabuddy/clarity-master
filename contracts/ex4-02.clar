;; 10. In this code snippet, implement a function called `add-todo` that adds a new todo item
;; to a list of recent todos. The function should maintain a maximum of 5 todos in the list,
;; and returns an error when trying to add an item above the limit.

;; title: ex4-02
;; version:
;; summary:
;; description:

;; constants
;;

;; data vars
;;
(define-data-var recentTodos (list 5 (string-ascii 50)) (list))

;; data maps
;;

;; public functions
;;
(define-public (add-todo (todo (string-ascii 50)))
  ;; Your code here
)

;; read only functions
;;

;; private functions
;;





;; Test cases
(add-todo "Buy groceries")
(add-todo "Call mom")
(add-todo "Finish report")
(add-todo "Go to gym")
(add-todo "Read book")
(add-todo "Learn Clarity") ;; This should return an error

;; add above to list
;; fold list over print function
;; see what happens!