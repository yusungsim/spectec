;; Test comment syntax

;;comment

;;;;;;;;;;;

    ;;comment

( ;;comment
module;;comment
);;comment

;;)
;;;)
;; ;)
;; (;

(;;)

(;comment;)

(;;comment;)

(;;;comment;)

(;;;;;;;;;;;;;;)

(;(((((((((( ;)

(;)))))))))));)

(;comment";)

(;comment"";)

(;comment""";)

;; ASCII 00-1F, 7F
(; 	
;)

;; null-byte followed immediately by end-of-comment delimiter
(; ;)


(;Heiße Würstchen;)

(;;)

(;comment
comment;)

         	(;comment;)

(;comment;)((;comment;)
(;comment;)module(;comment;)
(;comment;))(;comment;)

(;comment(;nested;)comment;)

(;comment
(;nested
;)comment
;)

(module
  (;comment(;nested(;further;)nested;)comment;)
)

(;comment;;comment;)

(;comment;;comment
;)

(module
  (;comment;;comment(;nested;)comment;)
)
