#|

 Linear Algebra in Common Lisp Unit Tests

 Copyright (c) 2011-2012, Odonata Research LLC
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

(in-package :linear-algebra-test)

(define-test sumsq-array
  (multiple-value-bind (scale sumsq)
      (linear-algebra:sumsq
       #2A((1.1 1.2 1.3 1.4 1.5)
           (2.1 2.2 2.3 2.4 2.5)
           (3.1 3.2 3.3 3.4 3.5)
           (4.1 4.2 4.3 4.4 4.5)))
    (assert-float-equal 4.5 scale)
    (assert-float-equal 8.997532 sumsq)))

(define-test sump-array
  (multiple-value-bind (scale sump)
      (linear-algebra:sump
       #2A((1.1 1.2 1.3 1.4 1.5)
           (2.1 2.2 2.3 2.4 2.5)
           (3.1 3.2 3.3 3.4 3.5)
           (4.1 4.2 4.3 4.4 4.5))
       3.5)
    (assert-float-equal 4.5 scale)
    (assert-float-equal 6.540154 sump)))

(define-test norm-1-array
  (let ((array
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-float-equal 17.0 (linear-algebra::%norm array 1))
    (assert-float-equal 17.0 (linear-algebra:norm array))))

(define-test norm-max-array
  (let ((array
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-float-equal 5.4 (linear-algebra::%norm array :max))
    (assert-float-equal 5.4 (linear-algebra:norm array :measure :max))))

(define-test norm-frobenius-array
  (let ((array
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-float-equal
     15.858751 (linear-algebra::%norm array :frobenius))
    (assert-float-equal
     15.858751 (linear-algebra:norm array :measure :frobenius))))

(define-test norm-infinity-array
  (let ((array
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-float-equal
     21.0 (linear-algebra::%norm array :infinity))
    (assert-float-equal
     21.0 (linear-algebra:norm array :measure :infinity))))

(define-test transpose-array
  (assert-float-equal
   #2A((1.1 2.1 3.1 4.1 5.1)
       (1.2 2.2 3.2 4.2 5.2)
       (1.3 2.3 3.3 4.3 5.3)
       (1.4 2.4 3.4 4.4 5.4))
   (linear-algebra:transpose
    #2A((1.1 1.2 1.3 1.4)
        (2.1 2.2 2.3 2.4)
        (3.1 3.2 3.3 3.4)
        (4.1 4.2 4.3 4.4)
        (5.1 5.2 5.3 5.4))))
  (assert-float-equal
   #2A((#C(1.1 1.2) #C(2.1 2.2) #C(3.1 3.2) #C(4.1 4.2) #C(5.1 5.2))
       (#C(1.3 1.4) #C(2.3 2.4) #C(3.3 3.4) #C(4.3 4.4) #C(5.3 5.4)))
   (linear-algebra:transpose
    #2A((#C(1.1 1.2) #C(1.3 1.4))
        (#C(2.1 2.2) #C(2.3 2.4))
        (#C(3.1 3.2) #C(3.3 3.4))
        (#C(4.1 4.2) #C(4.3 4.4))
        (#C(5.1 5.2) #C(5.3 5.4)))))
  (assert-float-equal
   #2A((#C(1.1 -1.2) #C(2.1 -2.2) #C(3.1 -3.2)
        #C(4.1 -4.2) #C(5.1 -5.2))
       (#C(1.3 -1.4) #C(2.3 -2.4) #C(3.3 -3.4)
        #C(4.3 -4.4) #C(5.3 -5.4)))
   (linear-algebra:transpose
    #2A((#C(1.1 1.2) #C(1.3 1.4))
        (#C(2.1 2.2) #C(2.3 2.4))
        (#C(3.1 3.2) #C(3.3 3.4))
        (#C(4.1 4.2) #C(4.3 4.4))
        (#C(5.1 5.2) #C(5.3 5.4)))
    :conjugate t)))

(define-test ntranspose-array
  (let ((original
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)))
        (transpose
         #2A((1.1 2.1 3.1 4.1)
             (1.2 2.2 3.2 4.2)
             (1.3 2.3 3.3 4.3)
             (1.4 2.4 3.4 4.4))))
    (assert-eq original (linear-algebra:ntranspose original))
    (assert-float-equal transpose original))
  (let ((original
         #2A((#C(1.1 1.2) #C(1.3 1.4))
             (#C(2.1 2.2) #C(2.3 2.4))))
        (transpose
         #2A((#C(1.1 1.2) #C(2.1 2.2))
             (#C(1.3 1.4) #C(2.3 2.4)))))
    (assert-eq original (linear-algebra:ntranspose original))
    (assert-float-equal transpose original))
  (let ((original
         #2A((#C(1.1 1.2) #C(1.3 1.4))
             (#C(2.1 2.2) #C(2.3 2.4))))
        (transpose
         #2A((#C(1.1 -1.2) #C(2.1 -2.2))
             (#C(1.3 -1.4) #C(2.3 -2.4)))))
    (assert-eq
     original (linear-algebra:ntranspose original :conjugate t))
    (assert-float-equal transpose original)))

(define-test scale-array
  (assert-float-equal
   #2A(( 3.3  3.6  3.9  4.2)
       ( 6.3  6.6  6.9  7.2)
       ( 9.3  9.6  9.9 10.2)
       (12.3 12.6 12.9 13.2)
       (15.3 15.6 15.9 16.2))
   (linear-algebra:scale
    3.0
    #2A((1.1 1.2 1.3 1.4)
        (2.1 2.2 2.3 2.4)
        (3.1 3.2 3.3 3.4)
        (4.1 4.2 4.3 4.4)
        (5.1 5.2 5.3 5.4)))))

(define-test nscale-array
  (let ((array
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-eq array (linear-algebra:nscale 3.0 array))
    (assert-float-equal
     #2A(( 3.3  3.6  3.9  4.2)
         ( 6.3  6.6  6.9  7.2)
         ( 9.3  9.6  9.9 10.2)
         (12.3 12.6 12.9 13.2)
         (15.3 15.6 15.9 16.2))
     array)))

(define-test add-array
  (let ((array
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    ;; No scalar
    (assert-float-equal
     #2A(( 2.2  2.4  2.6  2.8)
         ( 4.2  4.4  4.6  4.8)
         ( 6.2  6.4  6.6  6.8)
         ( 8.2  8.4  8.6  8.8)
         (10.2 10.4 10.6 10.8))
     (linear-algebra:add array array))
    ;; Scalar1
    (assert-float-equal
     #2A(( 3.3  3.6  3.9  4.2)
         ( 6.3  6.6  6.9  7.2)
         ( 9.3  9.6  9.9 10.2)
         (12.3 12.6 12.9 13.2)
         (15.3 15.6 15.9 16.2))
     (linear-algebra:add array array :scalar1 2.0))
    ;; Scalar2
    (assert-float-equal
     #2A(( 3.3  3.6  3.9  4.2)
         ( 6.3  6.6  6.9  7.2)
         ( 9.3  9.6  9.9 10.2)
         (12.3 12.6 12.9 13.2)
         (15.3 15.6 15.9 16.2))
     (linear-algebra:add array array :scalar2 2.0))
    ;; Scalar1 & Scalar2
    (assert-float-equal
     #2A(( 5.5  6.0  6.5  7.0)
         (10.5 11.0 11.5 12.0)
         (15.5 16.0 16.5 17.0)
         (20.5 21.0 21.5 22.0)
         (25.5 26.0 26.5 27.0))
     (linear-algebra:add array array :scalar1 2.0 :scalar2 3.0))))

(define-test nadd-array
  ;; No scalar
  (let ((array1
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4)))
        (array2
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-eq array1 (linear-algebra:nadd array1 array2))
    (assert-float-equal
     #2A(( 2.2  2.4  2.6  2.8)
         ( 4.2  4.4  4.6  4.8)
         ( 6.2  6.4  6.6  6.8)
         ( 8.2  8.4  8.6  8.8)
         (10.2 10.4 10.6 10.8))
     array1))
  ;; Scalar1
  (let ((array1
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4)))
        (array2
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-eq
     array1 (linear-algebra:nadd array1 array2 :scalar1 2.0))
    (assert-float-equal
     #2A(( 3.3  3.6  3.9  4.2)
         ( 6.3  6.6  6.9  7.2)
         ( 9.3  9.6  9.9 10.2)
         (12.3 12.6 12.9 13.2)
         (15.3 15.6 15.9 16.2))
     array1))
  ;; Scalar2
  (let ((array1
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4)))
        (array2
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-eq
     array1 (linear-algebra:nadd array1 array2 :scalar2 2.0))
    (assert-float-equal
     #2A(( 3.3  3.6  3.9  4.2)
         ( 6.3  6.6  6.9  7.2)
         ( 9.3  9.6  9.9 10.2)
         (12.3 12.6 12.9 13.2)
         (15.3 15.6 15.9 16.2))
     array1))
  ;; Scalar1 & Scalar2
  (let ((array1
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4)))
        (array2
         #2A((1.1 1.2 1.3 1.4)
             (2.1 2.2 2.3 2.4)
             (3.1 3.2 3.3 3.4)
             (4.1 4.2 4.3 4.4)
             (5.1 5.2 5.3 5.4))))
    (assert-eq
     array1 (linear-algebra:nadd
             array1 array2 :scalar1 2.0 :scalar2 3.0))
    (assert-float-equal
     #2A(( 5.5  6.0  6.5  7.0)
         (10.5 11.0 11.5 12.0)
         (15.5 16.0 16.5 17.0)
         (20.5 21.0 21.5 22.0)
         (25.5 26.0 26.5 27.0))
     array1)))
