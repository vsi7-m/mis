#lang r7rs
(import (scheme base)
        (scheme file)
        (scheme read)
        (scheme write)
        ;(scheme cxr)
        
        (only (racket file) find-files)
        (only (racket path) path-has-extension?)
        (only (racket mpair) list->mlist)
        
        (a-d sorting internal comparative quicksort) ; only used to sort our examples
        (prefix (a-d graph unweighted config) g:)
        (only (a-d graph examples undirected-unweighted) cyc-no)
        
        ; Add any necessary library to implement your assignment here.
        ; Only R7RS-libraries, sublibraries from the course (a-d) and WPO solutions are allowed! 

        )

; mis
; ( unweighted-graph → number )
; Procedure to calculate the size of a maximum independent set of a given unweigthed, undirected graph.

(define (descendants g node parent)
  (let ((children '()))
    (g:for-each-edge g node
                     (lambda (child)
                       (when (not (equal? child parent)) 
                         (let ((grandchildren '())) 
                           (g:for-each-edge g child
                                            (lambda (grandchild)
                                              (when (not (equal? grandchild node))
                                                (set! grandchildren (cons grandchild grandchildren)))))
                           (set! children (cons (cons child grandchildren)
                                                children))))))
    children))

;(display (descendants cyc-no 1 '())) (newline)
;(display (descendants cyc-no 3 1)) (newline)

(define (mis g)
  (let* ((n (g:order g))
         (memo (make-vector n #f)))
    (define (mist node parent)
      (or (vector-ref memo node)     ; JAAA
          (let ((skip 0)
                (keep 1)) 
            (g:for-each-edge g node
                             (lambda (child)
                               (when (not (equal? child parent))
                                 (set! skip (+ skip (mist child node))))))
            (g:for-each-edge g node
                             (lambda (child)
                               (when (not (equal? child parent))
                                 (g:for-each-edge g child
                                                  (lambda (grandchild)
                                                    (when (not (equal? grandchild node))
                                                      (set! keep (+ keep (mist grandchild child)))))))))
            (let ((result (max skip keep)))
              (vector-set! memo node result)
              result))))
    (mist 0 '())))


; Procedure to read a graph from file
(define (read-graph-from-file file)
  (with-input-from-file file
    (lambda ()
      (let ((graph (g:new #f (read (current-input-port)))))
        (do ((entry (read (current-input-port)) (read (current-input-port))))
          ((eof-object? entry) graph)
          (g:add-edge! graph (car entry) (cadr entry)))))))

; Some example graphs
; These have have been sorted in terms of the order of the graph.
(define examples (list->vector (cons cyc-no
                                     (map read-graph-from-file
                                          (list->mlist (find-files (lambda (p)
                                                                     (path-has-extension? p #".txt"))
                                                                   "examples/"))))))
(sort examples (lambda (x y)
                 (< (g:order x)
                    (g:order y))))

(set! examples (vector->list examples))

; Demonstrate your algorithm on ALL the example graphs
(display (map mis examples))