(define (make-key-table)
  (let ((x (setup-terminal)))
    (map (lambda (name+key-seq)
           (cons (cdr name+key-seq)
                 (make-key (cdr name+key-seq)
                           '()
                           (car name+key-seq))))
         `((up    . ,(key-up    x))
           (down  . ,(key-down  x))
           (left  . ,(key-left  x))
           (right . ,(key-right x))
           (f1    . ,(key-f1    x))
           (f2    . ,(key-f2    x))
           (f3    . ,(key-f3    x))
           (f4    . ,(key-f4    x))
           (f5    . ,(key-f5    x))
           (f6    . ,(key-f6    x))
           (f7    . ,(key-f7    x))
           (f8    . ,(key-f8    x))
           (f9    . ,(key-f9    x))
           (f10   . ,(key-f10   x))
           (f11   . ,(key-f11   x))
           (f12   . ,(key-f12   x))))))

(define (grab-key)
  (let find ((key-pairs (make-key-table))
             (str       (string (read-char console-input-port)))
             (n-chars   0))
    (if (null? key-pairs)
        (let ((code (vector-8b-ref str n-chars)))
          (make-key code))
        (let* ((key-seq (caar key-pairs))
               (n-seq   (string-length key-seq)))
          (cond ((and (fix:<= n-seq n-chars)
                      (string= str key-seq
                               0 n-chars
                               0 n-seq))
                 (cdar key-pairs))
                ((and (fix:> n-seq n-chars)
                      (string= str key-seq
                               0 n-chars
                               0 n-seq))
                 (find (cdr key-pairs)
                       (string-append str (read-char console-input-port))
                       (+ 1 n-seq)))
                (else (find '()
                            str
                            n-chars)))))))


(define (start-printer)
  (with-current-input-terminal-mode 'raw
    (let loop ((key (grab-key)))
      (if (key=? key (kbd #\q))
          (display "bye")
          (begin (display (key->name key))
                 (newline)
                 (loop (grab-key)))))))
