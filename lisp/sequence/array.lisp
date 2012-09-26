#|

 Fundamental Array Operations

 Copyright (c) 2009-2012, Odonata Research LLC
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

(defmethod sumsq ((data array) &key (scale 0) (sumsq 1))
  "Return the scaling parameter and the sum of the squares of the
array."
  (sumsq-array data scale sumsq))

(defmethod sump ((data array) (p number) &key (scale 0) (sump 1))
  "Return the scaling parameter and the sum of the P powers of the
matrix."
  (sump-array data p scale sump))

(defmethod norm ((data array) &key (measure 1))
  "Return the norm of the array."
  (if (= 2 (array-rank data))
      (norm-array data measure)
      (error "Array rank(~D) must be 2."
             (array-rank data))))

(defmethod transpose ((data array) &key conjugate)
  "Return the transpose of the array."
  (let* ((op (if conjugate #'conjugate #'identity))
         (m-rows (array-dimension data 0))
         (n-columns (array-dimension data 1))
         (result
          (make-array
           (list n-columns m-rows)
           :element-type (array-element-type data))))
    (dotimes (row m-rows result)
      (dotimes (column n-columns)
        (setf
         (aref result column row)
         (funcall op (aref data row column)))))))

(defmethod ntranspose ((data array) &key conjugate)
  "Replace the contents of the array with the transpose."
  (let ((m-rows (array-dimension data 0))
        (n-columns (array-dimension data 1))
        (op (if conjugate #'conjugate #'identity)))
    (if (= m-rows n-columns)
        (dotimes (row m-rows data)
          ;; FIXME : Conjugate on the diagonal may not be correct.
          (setf (aref data row row)
                (funcall op (aref data row row)))
          (do ((column (1+ row) (1+ column)))
              ((>= column n-columns))
            (psetf
             (aref data row column)
             (funcall op (aref data column row))
             (aref data column row)
             (funcall op (aref data row column)))))
        (error "Rows(~D) and columns(~D) unequal."
               m-rows n-columns))))

(defmethod permute ((data array) (matrix permutation-matrix))
  (if (every #'= (array-dimensions data) (matrix-dimensions matrix))
      (right-permute-array data (contents matrix))
      (error "Array~A and permutation matrix~A sizes incompatible."
             (array-dimensions data) (matrix-dimensions matrix))))

(defmethod permute ((matrix permutation-matrix) (data array))
  (if (every #'= (array-dimensions data) (matrix-dimensions matrix))
      (left-permute-array (contents matrix) data)
      (error "Permutation matrix~A and array~A sizes incompatible."
             (matrix-dimensions matrix) (array-dimensions data))))

(defmethod npermute ((data array) (matrix permutation-matrix))
  "Destructively permute the array."
  (if (every #'= (array-dimensions data) (matrix-dimensions matrix))
      (right-npermute-array data (contents matrix))
      (error "Array~A and permutation matrix~A sizes incompatible."
             (array-dimensions data) (matrix-dimensions matrix))))

(defmethod npermute ((matrix permutation-matrix) (data array))
  "Destructively permute the array."
  (if (every #'= (array-dimensions data) (matrix-dimensions matrix))
      (left-npermute-array (contents (ntranspose matrix)) data)
      (error "Permutation matrix~A and array~A sizes incompatible."
             (matrix-dimensions matrix) (array-dimensions data))))

(defmethod scale ((scalar number) (data array))
  "Scale each element of the array."
  (let* ((m-rows (array-dimension data 0))
         (n-columns (array-dimension data 1))
         (result
          (make-array
           (list m-rows n-columns)
           :element-type (array-element-type data))))
    (dotimes (row m-rows result)
      (dotimes (column n-columns)
        (setf
         (aref result row column)
         (* scalar (aref data row column)))))))

(defmethod nscale ((scalar number) (data array))
  "Scale each element of the array."
  (let ((m-rows (array-dimension data 0))
        (n-columns (array-dimension data 1)))
    (dotimes (row m-rows data)
      (dotimes (column n-columns)
        (setf
         (aref data row column)
         (* scalar (aref data row column)))))))

(defmethod add ((array1 array) (array2 array) &key scalar1 scalar2)
  "Return the addition of the 2 arrays."
  (if (compatible-dimensions-p :add array1 array2)
      (add-array array1 array2 scalar1 scalar2)
      (error "The array dimensions, ~A,~A, are not compatible."
             (array-dimensions array1) (array-dimensions array2))))

(defmethod nadd ((array1 array) (array2 array) &key scalar1 scalar2)
  "Destructively add array2 to array1."
  (if (compatible-dimensions-p :add array1 array2)
      (nadd-array array1 array2 scalar1 scalar2)
      (error "The array dimensions, ~A,~A, are not compatible."
             (array-dimensions array1) (array-dimensions array2))))

(defmethod subtract ((array1 array) (array2 array) &key scalar1 scalar2)
  "Return the subtraction of the 2 arrays."
  (if (compatible-dimensions-p :add array1 array2)
      (subtract-array array1 array2 scalar1 scalar2)
      (error "The array dimensions, ~A,~A, are not compatible."
             (array-dimensions array1) (array-dimensions array2))))

(defmethod nsubtract ((array1 array) (array2 array) &key scalar1 scalar2)
  "Destructively subtract array2 from array1."
  (if (compatible-dimensions-p :add array1 array2)
      (nsubtract-array array1 array2 scalar1 scalar2)
      (error "The array dimensions, ~A and ~A, are not compatible."
             (array-dimensions array1) (array-dimensions array2))))

(defmethod product ((vector vector) (array array) &key scalar)
  "Return a vector generated by the pre-multiplication of a array by a
vector."
  (if (compatible-dimensions-p :product vector array)
      (product-vector-array vector array scalar)
      (error "Vector(~D) is incompatible with array~A."
             (length vector) (array-dimensions array))))

(defmethod product ((array array) (vector vector) &key scalar)
  "Return a vector generated by the multiplication of the array with a
vector."
  (if (compatible-dimensions-p :product array vector)
      (product-array-vector array vector scalar)
      (error "Array~A is incompatible with vector(~D)."
             (array-dimensions array) (length vector))))

(defmethod product ((array1 array) (array2 array) &key scalar)
  "Return the product of the arrays."
  (if (compatible-dimensions-p :product array1 array2)
      (product-array-array array1 array2 scalar)
      (error "The array dimensions, ~A and ~A, are not compatible."
             (array-dimensions array1) (array-dimensions array2))))
