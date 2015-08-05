; random writing
; 6/9/2014
; takes in a text file and a positive integer k
; writes out a random sequence of words in the flavor of
; the input text. This flavor is obtained by associating
; each k-length prefix in the text with the probability
; that it is followed by a certain character. Then, starting
; from a randomly selected prefix from the text, the prefix
; is printed followed by the character chosen randomly with
; the probabilities with which the characters actually do
; follow the prefix in the input text. The prefix is then updated
; by shifting the prefix one to the left and appending the chosen 
; character, and repeat. Stops when (text character length / 5)
; characters have been printed.
;
; larger k => output more similar to text, large enough k
; produces the exact text.

#lang racket

; fills prefix-map with prefixes as keys and character lists
; as values. example: the text "aaabc", k=2, would make it so that
; the map held aa -> (a, b), ab -> (c). duplicates are allowed in
; the value lists.
; k is the length of the prefixes
; text is a string of the entire text
(define (map-prefixes k loc text prefix-map)
  (unless (>= (+ loc k) (string-length text))
    (add-in-char prefix-map
                  (substring text loc (+ loc k))
                  (string-ref text (+ loc k)))
    (map-prefixes k (+ loc 1) text prefix-map)))

; adds char to the list in prefix-map corresponding to the
; key prefix, or makes a list and adds the char if no list 
; yet for given prefix.
(define (add-in-char prefix-map prefix char)
  (unless (hash-has-key? prefix-map prefix)
    (hash-set! prefix-map prefix (list)))
  (hash-set! prefix-map
             prefix
             (append (list char) (hash-ref prefix-map prefix))))

; returns a random prefix from prefix-map
(define (choose-random-prefix prefix-map)
  (define prefixes (hash-keys prefix-map))
  (list-ref prefixes (random (length prefixes))))

;(define (print-transition-chain prefix-map)  
;  (define suffixes (list->set 
  

; starting from prefix, the prefix
; is printed followed by the character chosen randomly from
; the corresponding value list of prefix in prefix-map. 
; The prefix is then updated by shifting the prefix one to the left
; and appending the chosen character, and repeat.
; Prints limit characters.
(define (write-text prefix-map prefix limit)
  (cond [(not (hash-has-key? prefix-map prefix))
         (write-text prefix-map (choose-random-prefix prefix-map) limit)]
        [#t (define choices (hash-ref prefix-map prefix))
            (define choice (string (list-ref choices (random (length choices)))))
            (define pre (substring prefix 1))
            (define next-prefix (string-append pre choice))
            (display choice)
            (unless (< limit 0)
              (write-text prefix-map next-prefix (- limit 1)))]))


(define args (command-line #:args (filename k) (list filename k)))
(define text (file->string (car args)))
(define k (string->number (cadr args)))
(define prefix-map (make-hash))
(map-prefixes k 0 text prefix-map)
(write-text prefix-map
            (choose-random-prefix prefix-map)
            (- (string-length text) 2))
