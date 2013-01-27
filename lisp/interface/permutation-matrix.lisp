#|

 Linear Algebra in Common Lisp

 Copyright (c) 2011-2012, Thomas M. Hermann
 All rights reserved.

 Redistribution and  use  in  source  and  binary  forms, with or without
 modification, are permitted  provided  that the following conditions are
 met:

   o  Redistributions of  source  code  must  retain  the above copyright
      notice, this list of conditions and the following disclaimer.
   o  Redistributions in binary  form  must reproduce the above copyright
      notice, this list of  conditions  and  the  following disclaimer in
      the  documentation  and/or   other   materials  provided  with  the
      distribution.
   o  The names of the contributors may not be used to endorse or promote
      products derived from this software without  specific prior written
      permission.

 THIS SOFTWARE IS  PROVIDED  BY  THE  COPYRIGHT  HOLDERS AND CONTRIBUTORS
 "AS IS"  AND  ANY  EXPRESS  OR  IMPLIED  WARRANTIES, INCLUDING,  BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES  OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR  CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED TO,
 PROCUREMENT OF  SUBSTITUTE  GOODS  OR  SERVICES;  LOSS  OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER  IN  CONTRACT,  STRICT  LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR  OTHERWISE)  ARISING  IN  ANY  WAY  OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

|#

(in-package :linear-algebra)

(defclass permutation-matrix (matrix-object)
  ((contents
    :type     (array fixnum (*))
    :initarg  :contents
    :accessor contents))
  (:documentation
   "Permutation matrix object."))

(defun permutation-matrix-p (object)
  "Return true if object is a permutation-matrix."
  (typep object 'permutation-matrix))

(defmethod initialize-matrix :before ((matrix permutation-matrix)
                                      data
                                      (rows integer)
                                      (columns integer)
                                      element-type)
  "Verify that the element-type was not set and that rows equals
columns."
  (declare (ignore matrix data))
  (unless (eq 'number element-type)
    (error
     "Cannot specify the element type of a permutation matrix."))
  (unless (= rows columns)
    (error "Number of rows must equal the number of columns.")))

(defmethod initialize-matrix ((matrix permutation-matrix)
                              (data (eql 0))
                              (rows integer)
                              (columns integer)
                              element-type)
  (declare (ignore element-type))
  (loop with contents =
        (setf (contents matrix)
              (make-array rows :element-type 'fixnum))
        for index below rows do
        (setf (aref contents index) index)
        finally (return matrix)))

;;; FIXME : Use the LOOP.
(defun %initialize-permutation-matrix-with-seq (matrix data size)
  (if (= size (length data))
      (let ((contents
             (setf
              (contents matrix)
              (make-array size :element-type 'fixnum))))
        ;; Fill contents, there should be no duplicates.
        (dotimes (row size)
          (let ((data-row (elt data row)))
            (if (= size (length data-row))
                (let ((column (position 1 data-row :test #'=)))
                  (if column
                      (setf (aref contents row) column)
                      (error "Invalid permutation data.")))
                (error "Rows unequal in length."))))
        ;; FIXME : Find a better way to identify duplicates.
        ;; If duplicates, not a permutation matrix.
        (unless (= size (length
                         (remove-duplicates contents :test #'=)))
          (error "Invalid permutation in data."))
        ;; Return the matrix
        matrix)
      (error "Invalid number of rows of data.")))

(defmethod initialize-matrix ((matrix permutation-matrix)
                              (data list)
                              (rows integer)
                              (columns integer)
                              element-type)
  "Initialize the permutation matrix with a list."
  (declare (ignore columns element-type))
  (%initialize-permutation-matrix-with-seq matrix data rows))

(defmethod initialize-matrix ((matrix permutation-matrix)
                              (data vector)
                              (rows integer)
                              (columns integer)
                              element-type)
  "Initialize the permutation matrix with a list."
  (declare (ignore columns element-type))
  (%initialize-permutation-matrix-with-seq matrix data rows))

(defmethod initialize-matrix ((matrix permutation-matrix)
                              (data array)
                              (rows fixnum)
                              (columns fixnum)
                              element-type)
  "Initialize the permutation matrix with a 2D array."
  (declare (ignore element-type))
  (cond
    ((not (= rows (array-dimension data 0)))
     (error "Invalid number of rows of data."))
    ((not (= columns (array-dimension data 1)))
     (error "Invalid number of columns of data."))
    (t
     (let ((row -1))
       (map-into
        (setf (contents matrix) (make-array rows))
        (lambda ()
          (incf row)
          (do ((column 0 (1+ column)))
              ((cond
                 ((>= column columns)
                  (error "Invalid permutation data."))
                 ((= 1 (aref data row column))))
               column))))
       ;; FIXME : Find a better way to identify duplicates.
       (unless (= rows (length (remove-duplicates
                                (contents matrix) :test #'=)))
         (error "Invalid permutation in data."))
       ;; Return the permutation matrix
       matrix))))

(defmethod matrix-in-bounds-p ((matrix permutation-matrix)
                               (row integer) (column integer))
  "Return true if row and column do not exceed the dimensions of matrix."
  (let ((size (length (contents matrix))))
    (and (<= 0 row)    (< row    size)
         (<= 0 column) (< column size))))

(defmethod matrix-element-type ((matrix permutation-matrix))
  "Element type of the permutation matrix."
  'fixnum)

(defmethod matrix-dimensions ((matrix permutation-matrix))
  "Return the number of rows and columns in matrix."
  (let ((size (length (contents matrix))))
    (list size size)))

(defmethod matrix-row-dimension ((matrix permutation-matrix))
  "Return the number of rows in matrix."
  (length (contents matrix)))

(defmethod matrix-column-dimension ((matrix permutation-matrix))
  "Return the number of columns in matrix."
  (length (contents matrix)))

(defmethod mref ((matrix permutation-matrix)
                 (row integer) (column integer))
  "Return 1 if a permutation and 0 otherwise."
  (if (= column (aref (contents matrix) row)) 1 0))

(defmethod (setf mref) ((data (eql 1)) (matrix permutation-matrix)
                        (row integer) (column integer))
  "Swap rows of the permutation matrix."
  (let ((contents (contents matrix)))
    (rotatef (aref contents row) (aref contents column))))

(defmethod copy-matrix ((matrix permutation-matrix))
  "Return a copy of the permutation matrix."
  (make-instance
   'permutation-matrix
   :contents (copy-seq (contents matrix))))

(defmethod submatrix ((matrix permutation-matrix)
                      (start-row integer)
                      (start-column integer)
                      &key end-row end-column)
  (multiple-value-bind (start-row start-column end-row end-column)
      (matrix-validated-range
       matrix start-row start-column end-row end-column)
    (let* ((m-rows (- end-row start-row))
           (n-columns (- end-column start-column))
           (permute  (contents matrix))
           (contents
            (make-array
             (list m-rows n-columns)
             :element-type 'fixnum
             :initial-element 0)))
      (make-instance
       (if (= m-rows n-columns) 'square-matrix 'dense-matrix)
       :contents
       (do ((i0 0 (1+ i0))
            (i1 start-row (1+ i1)))
           ((>= i0 m-rows) contents)
         (when (< (1- start-column) (aref permute i1) end-column)
           (setf
            (aref contents i0 (- (aref permute i1) start-column))
            1)))))))

(defmethod transpose ((matrix permutation-matrix) &key conjugate)
  "Transpose the permutation matrix."
  (declare (ignore conjugate))
  (let ((contents (contents matrix)))
    (make-instance
     'permutation-matrix
     :contents
     (loop with permuted =
           (make-array (length contents) :element-type 'fixnum)
           for column across contents
           as  row = 0 then (1+ row)
           do (setf (aref permuted column) row)
           finally (return permuted)))))

(defun %init-ntranspose (contents)
  "Count the number of rows to skip and the first row."
  (loop with row0 = nil
        for row below (length contents)
        as column = (aref contents row)
        if (= row column) count row into skip
        else do (unless row0 (setf row0 row))
        finally (return (values row0 skip))))

(defmethod ntranspose ((matrix permutation-matrix) &key conjugate)
  "Destructively transpose the permutation matrix."
  (declare (ignore conjugate))
  (loop with mat = (contents matrix)
        with update-datum-p
        with datum = 0
        with row = 0
        with column = (aref mat 0)
        with cache = (aref mat column)
        repeat (length mat)
        ;; Finish shift loop
        if update-datum-p do
        (setf
         update-datum-p nil
         row (1+ (min row column))
         datum row
         column (aref mat row)
         cache (aref mat column))
        ;; On diagonal
        else if (= row column) do
        (setf datum (incf row))
        (when (array-in-bounds-p mat row)
          (setf
           column (aref mat row)
           cache (aref mat column)))
        ;; Found end of shift loop
        else if (= datum cache) do
        (setf
         update-datum-p t
         (aref mat column) row
         (aref mat cache) column)
        ;; Shift the elements
        else do
        (shiftf (aref mat column) row column cache (aref mat cache))
        finally (return matrix)))
