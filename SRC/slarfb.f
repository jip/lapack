*> \brief \b SLARFB applies a block reflector or its transpose to a general rectangular matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> Download SLARFB + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slarfb.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slarfb.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slarfb.f">
*> [TXT]</a>
*
*  Definition:
*  ===========
*
*       SUBROUTINE SLARFB( SIDE, TRANS, DIRECT, STOREV, M, N, K, V, LDV,
*                          T, LDT, C, LDC, WORK, LDWORK )
*
*       .. Scalar Arguments ..
*       CHARACTER          DIRECT, SIDE, STOREV, TRANS
*       INTEGER            K, LDC, LDT, LDV, LDWORK, M, N
*       ..
*       .. Array Arguments ..
*       REAL               C( LDC, * ), T( LDT, * ), V( LDV, * ),
*      $                   WORK( LDWORK, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLARFB applies a real block reflector H or its transpose H**T to a
*> real m by n matrix C, from either the left or the right.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SIDE
*> \verbatim
*>          SIDE is CHARACTER*1
*>          = 'L': apply H or H**T from the Left
*>          = 'R': apply H or H**T from the Right
*> \endverbatim
*>
*> \param[in] TRANS
*> \verbatim
*>          TRANS is CHARACTER*1
*>          = 'N': apply H (No transpose)
*>          = 'T': apply H**T (Transpose)
*> \endverbatim
*>
*> \param[in] DIRECT
*> \verbatim
*>          DIRECT is CHARACTER*1
*>          Indicates how H is formed from a product of elementary
*>          reflectors
*>          = 'F': H = H(1) H(2) . . . H(k) (Forward)
*>          = 'B': H = H(k) . . . H(2) H(1) (Backward)
*> \endverbatim
*>
*> \param[in] STOREV
*> \verbatim
*>          STOREV is CHARACTER*1
*>          Indicates how the vectors which define the elementary
*>          reflectors are stored:
*>          = 'C': Columnwise
*>          = 'R': Rowwise
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix C.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix C.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The order of the matrix T (= the number of elementary
*>          reflectors whose product defines the block reflector).
*>          If SIDE = 'L', M >= K >= 0;
*>          if SIDE = 'R', N >= K >= 0.
*> \endverbatim
*>
*> \param[in] V
*> \verbatim
*>          V is REAL array, dimension
*>                                (LDV,K) if STOREV = 'C'
*>                                (LDV,M) if STOREV = 'R' and SIDE = 'L'
*>                                (LDV,N) if STOREV = 'R' and SIDE = 'R'
*>          The matrix V. See Further Details.
*> \endverbatim
*>
*> \param[in] LDV
*> \verbatim
*>          LDV is INTEGER
*>          The leading dimension of the array V.
*>          If STOREV = 'C' and SIDE = 'L', LDV >= max(1,M);
*>          if STOREV = 'C' and SIDE = 'R', LDV >= max(1,N);
*>          if STOREV = 'R', LDV >= K.
*> \endverbatim
*>
*> \param[in] T
*> \verbatim
*>          T is REAL array, dimension (LDT,K)
*>          The triangular k by k matrix T in the representation of the
*>          block reflector.
*> \endverbatim
*>
*> \param[in] LDT
*> \verbatim
*>          LDT is INTEGER
*>          The leading dimension of the array T. LDT >= K.
*> \endverbatim
*>
*> \param[in,out] C
*> \verbatim
*>          C is REAL array, dimension (LDC,N)
*>          On entry, the m by n matrix C.
*>          On exit, C is overwritten by H*C or H**T*C or C*H or C*H**T.
*> \endverbatim
*>
*> \param[in] LDC
*> \verbatim
*>          LDC is INTEGER
*>          The leading dimension of the array C. LDC >= max(1,M).
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is REAL array, dimension (LDWORK,K)
*> \endverbatim
*>
*> \param[in] LDWORK
*> \verbatim
*>          LDWORK is INTEGER
*>          The leading dimension of the array WORK.
*>          If SIDE = 'L', LDWORK >= max(1,N);
*>          if SIDE = 'R', LDWORK >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \ingroup larfb
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  The shape of the matrix V and the storage of the vectors which define
*>  the H(i) is best illustrated by the following example with n = 5 and
*>  k = 3. The triangular part of V (including its diagonal) is not
*>  referenced.
*>
*>  DIRECT = 'F' and STOREV = 'C':         DIRECT = 'F' and STOREV = 'R':
*>
*>               V = (  1       )                 V = (  1 v1 v1 v1 v1 )
*>                   ( v1  1    )                     (     1 v2 v2 v2 )
*>                   ( v1 v2  1 )                     (        1 v3 v3 )
*>                   ( v1 v2 v3 )
*>                   ( v1 v2 v3 )
*>
*>  DIRECT = 'B' and STOREV = 'C':         DIRECT = 'B' and STOREV = 'R':
*>
*>               V = ( v1 v2 v3 )                 V = ( v1 v1  1       )
*>                   ( v1 v2 v3 )                     ( v2 v2 v2  1    )
*>                   (  1 v2 v3 )                     ( v3 v3 v3 v3  1 )
*>                   (     1 v3 )
*>                   (        1 )
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE SLARFB( SIDE, TRANS, DIRECT, STOREV, M, N, K, V,
     $                   LDV,
     $                   T, LDT, C, LDC, WORK, LDWORK )
*
*  -- LAPACK auxiliary routine --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*
*     .. Scalar Arguments ..
      CHARACTER          DIRECT, SIDE, STOREV, TRANS
      INTEGER            K, LDC, LDT, LDV, LDWORK, M, N
*     ..
*     .. Array Arguments ..
      REAL               C( LDC, * ), T( LDT, * ), V( LDV, * ),
     $                   WORK( LDWORK, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE
      PARAMETER          ( ONE = 1.0E+0 )
*     ..
*     .. Local Scalars ..
      CHARACTER          TRANST
      INTEGER            I, J
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. External Subroutines ..
      EXTERNAL           SCOPY, SGEMM, STRMM
*     ..
*     .. Executable Statements ..
*
*     Quick return if possible
*
      IF( M.LE.0 .OR. N.LE.0 )
     $   RETURN
*
      IF( LSAME( TRANS, 'N' ) ) THEN
         TRANST = 'T'
      ELSE
         TRANST = 'N'
      END IF
*
      IF( LSAME( STOREV, 'C' ) ) THEN
*
         IF( LSAME( DIRECT, 'F' ) ) THEN
*
*           Let  V =  ( V1 )    (first K rows)
*                     ( V2 )
*           where  V1  is unit lower triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**T * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**T * V  =  (C1**T * V1 + C2**T * V2)  (stored in WORK)
*
*              W := C1**T
*
               DO 10 J = 1, K
                  CALL SCOPY( N, C( J, 1 ), LDC, WORK( 1, J ), 1 )
   10          CONTINUE
*
*              W := W * V1
*
               CALL STRMM( 'Right', 'Lower', 'No transpose', 'Unit',
     $                     N,
     $                     K, ONE, V, LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C2**T * V2
*
                  CALL SGEMM( 'Transpose', 'No transpose', N, K, M-K,
     $                        ONE, C( K+1, 1 ), LDC, V( K+1, 1 ), LDV,
     $                        ONE, WORK, LDWORK )
               END IF
*
*              W := W * T**T  or  W * T
*
               CALL STRMM( 'Right', 'Upper', TRANST, 'Non-unit', N,
     $                     K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V * W**T
*
               IF( M.GT.K ) THEN
*
*                 C2 := C2 - V2 * W**T
*
                  CALL SGEMM( 'No transpose', 'Transpose', M-K, N, K,
     $                        -ONE, V( K+1, 1 ), LDV, WORK, LDWORK, ONE,
     $                        C( K+1, 1 ), LDC )
               END IF
*
*              W := W * V1**T
*
               CALL STRMM( 'Right', 'Lower', 'Transpose', 'Unit', N,
     $                     K,
     $                     ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W**T
*
               DO 30 J = 1, K
                  DO 20 I = 1, N
                     C( J, I ) = C( J, I ) - WORK( I, J )
   20             CONTINUE
   30          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**T  where  C = ( C1  C2 )
*
*              W := C * V  =  (C1*V1 + C2*V2)  (stored in WORK)
*
*              W := C1
*
               DO 40 J = 1, K
                  CALL SCOPY( M, C( 1, J ), 1, WORK( 1, J ), 1 )
   40          CONTINUE
*
*              W := W * V1
*
               CALL STRMM( 'Right', 'Lower', 'No transpose', 'Unit',
     $                     M,
     $                     K, ONE, V, LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C2 * V2
*
                  CALL SGEMM( 'No transpose', 'No transpose', M, K,
     $                        N-K,
     $                        ONE, C( 1, K+1 ), LDC, V( K+1, 1 ), LDV,
     $                        ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**T
*
               CALL STRMM( 'Right', 'Upper', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V**T
*
               IF( N.GT.K ) THEN
*
*                 C2 := C2 - W * V2**T
*
                  CALL SGEMM( 'No transpose', 'Transpose', M, N-K, K,
     $                        -ONE, WORK, LDWORK, V( K+1, 1 ), LDV, ONE,
     $                        C( 1, K+1 ), LDC )
               END IF
*
*              W := W * V1**T
*
               CALL STRMM( 'Right', 'Lower', 'Transpose', 'Unit', M,
     $                     K,
     $                     ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W
*
               DO 60 J = 1, K
                  DO 50 I = 1, M
                     C( I, J ) = C( I, J ) - WORK( I, J )
   50             CONTINUE
   60          CONTINUE
            END IF
*
         ELSE
*
*           Let  V =  ( V1 )
*                     ( V2 )    (last K rows)
*           where  V2  is unit upper triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**T * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**T * V  =  (C1**T * V1 + C2**T * V2)  (stored in WORK)
*
*              W := C2**T
*
               DO 70 J = 1, K
                  CALL SCOPY( N, C( M-K+J, 1 ), LDC, WORK( 1, J ),
     $                        1 )
   70          CONTINUE
*
*              W := W * V2
*
               CALL STRMM( 'Right', 'Upper', 'No transpose', 'Unit',
     $                     N,
     $                     K, ONE, V( M-K+1, 1 ), LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C1**T * V1
*
                  CALL SGEMM( 'Transpose', 'No transpose', N, K, M-K,
     $                        ONE, C, LDC, V, LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T**T  or  W * T
*
               CALL STRMM( 'Right', 'Lower', TRANST, 'Non-unit', N,
     $                     K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V * W**T
*
               IF( M.GT.K ) THEN
*
*                 C1 := C1 - V1 * W**T
*
                  CALL SGEMM( 'No transpose', 'Transpose', M-K, N, K,
     $                        -ONE, V, LDV, WORK, LDWORK, ONE, C, LDC )
               END IF
*
*              W := W * V2**T
*
               CALL STRMM( 'Right', 'Upper', 'Transpose', 'Unit', N,
     $                     K,
     $                     ONE, V( M-K+1, 1 ), LDV, WORK, LDWORK )
*
*              C2 := C2 - W**T
*
               DO 90 J = 1, K
                  DO 80 I = 1, N
                     C( M-K+J, I ) = C( M-K+J, I ) - WORK( I, J )
   80             CONTINUE
   90          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H'  where  C = ( C1  C2 )
*
*              W := C * V  =  (C1*V1 + C2*V2)  (stored in WORK)
*
*              W := C2
*
               DO 100 J = 1, K
                  CALL SCOPY( M, C( 1, N-K+J ), 1, WORK( 1, J ), 1 )
  100          CONTINUE
*
*              W := W * V2
*
               CALL STRMM( 'Right', 'Upper', 'No transpose', 'Unit',
     $                     M,
     $                     K, ONE, V( N-K+1, 1 ), LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C1 * V1
*
                  CALL SGEMM( 'No transpose', 'No transpose', M, K,
     $                        N-K,
     $                        ONE, C, LDC, V, LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**T
*
               CALL STRMM( 'Right', 'Lower', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V**T
*
               IF( N.GT.K ) THEN
*
*                 C1 := C1 - W * V1**T
*
                  CALL SGEMM( 'No transpose', 'Transpose', M, N-K, K,
     $                        -ONE, WORK, LDWORK, V, LDV, ONE, C, LDC )
               END IF
*
*              W := W * V2**T
*
               CALL STRMM( 'Right', 'Upper', 'Transpose', 'Unit', M,
     $                     K,
     $                     ONE, V( N-K+1, 1 ), LDV, WORK, LDWORK )
*
*              C2 := C2 - W
*
               DO 120 J = 1, K
                  DO 110 I = 1, M
                     C( I, N-K+J ) = C( I, N-K+J ) - WORK( I, J )
  110             CONTINUE
  120          CONTINUE
            END IF
         END IF
*
      ELSE IF( LSAME( STOREV, 'R' ) ) THEN
*
         IF( LSAME( DIRECT, 'F' ) ) THEN
*
*           Let  V =  ( V1  V2 )    (V1: first K columns)
*           where  V1  is unit upper triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**T * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**T * V**T  =  (C1**T * V1**T + C2**T * V2**T) (stored in WORK)
*
*              W := C1**T
*
               DO 130 J = 1, K
                  CALL SCOPY( N, C( J, 1 ), LDC, WORK( 1, J ), 1 )
  130          CONTINUE
*
*              W := W * V1**T
*
               CALL STRMM( 'Right', 'Upper', 'Transpose', 'Unit', N,
     $                     K,
     $                     ONE, V, LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C2**T * V2**T
*
                  CALL SGEMM( 'Transpose', 'Transpose', N, K, M-K,
     $                        ONE,
     $                        C( K+1, 1 ), LDC, V( 1, K+1 ), LDV, ONE,
     $                        WORK, LDWORK )
               END IF
*
*              W := W * T**T  or  W * T
*
               CALL STRMM( 'Right', 'Upper', TRANST, 'Non-unit', N,
     $                     K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V**T * W**T
*
               IF( M.GT.K ) THEN
*
*                 C2 := C2 - V2**T * W**T
*
                  CALL SGEMM( 'Transpose', 'Transpose', M-K, N, K,
     $                        -ONE,
     $                        V( 1, K+1 ), LDV, WORK, LDWORK, ONE,
     $                        C( K+1, 1 ), LDC )
               END IF
*
*              W := W * V1
*
               CALL STRMM( 'Right', 'Upper', 'No transpose', 'Unit',
     $                     N,
     $                     K, ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W**T
*
               DO 150 J = 1, K
                  DO 140 I = 1, N
                     C( J, I ) = C( J, I ) - WORK( I, J )
  140             CONTINUE
  150          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**T  where  C = ( C1  C2 )
*
*              W := C * V**T  =  (C1*V1**T + C2*V2**T)  (stored in WORK)
*
*              W := C1
*
               DO 160 J = 1, K
                  CALL SCOPY( M, C( 1, J ), 1, WORK( 1, J ), 1 )
  160          CONTINUE
*
*              W := W * V1**T
*
               CALL STRMM( 'Right', 'Upper', 'Transpose', 'Unit', M,
     $                     K,
     $                     ONE, V, LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C2 * V2**T
*
                  CALL SGEMM( 'No transpose', 'Transpose', M, K, N-K,
     $                        ONE, C( 1, K+1 ), LDC, V( 1, K+1 ), LDV,
     $                        ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**T
*
               CALL STRMM( 'Right', 'Upper', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V
*
               IF( N.GT.K ) THEN
*
*                 C2 := C2 - W * V2
*
                  CALL SGEMM( 'No transpose', 'No transpose', M, N-K,
     $                        K,
     $                        -ONE, WORK, LDWORK, V( 1, K+1 ), LDV, ONE,
     $                        C( 1, K+1 ), LDC )
               END IF
*
*              W := W * V1
*
               CALL STRMM( 'Right', 'Upper', 'No transpose', 'Unit',
     $                     M,
     $                     K, ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W
*
               DO 180 J = 1, K
                  DO 170 I = 1, M
                     C( I, J ) = C( I, J ) - WORK( I, J )
  170             CONTINUE
  180          CONTINUE
*
            END IF
*
         ELSE
*
*           Let  V =  ( V1  V2 )    (V2: last K columns)
*           where  V2  is unit lower triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**T * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**T * V**T  =  (C1**T * V1**T + C2**T * V2**T) (stored in WORK)
*
*              W := C2**T
*
               DO 190 J = 1, K
                  CALL SCOPY( N, C( M-K+J, 1 ), LDC, WORK( 1, J ),
     $                        1 )
  190          CONTINUE
*
*              W := W * V2**T
*
               CALL STRMM( 'Right', 'Lower', 'Transpose', 'Unit', N,
     $                     K,
     $                     ONE, V( 1, M-K+1 ), LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C1**T * V1**T
*
                  CALL SGEMM( 'Transpose', 'Transpose', N, K, M-K,
     $                        ONE,
     $                        C, LDC, V, LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T**T  or  W * T
*
               CALL STRMM( 'Right', 'Lower', TRANST, 'Non-unit', N,
     $                     K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V**T * W**T
*
               IF( M.GT.K ) THEN
*
*                 C1 := C1 - V1**T * W**T
*
                  CALL SGEMM( 'Transpose', 'Transpose', M-K, N, K,
     $                        -ONE,
     $                        V, LDV, WORK, LDWORK, ONE, C, LDC )
               END IF
*
*              W := W * V2
*
               CALL STRMM( 'Right', 'Lower', 'No transpose', 'Unit',
     $                     N,
     $                     K, ONE, V( 1, M-K+1 ), LDV, WORK, LDWORK )
*
*              C2 := C2 - W**T
*
               DO 210 J = 1, K
                  DO 200 I = 1, N
                     C( M-K+J, I ) = C( M-K+J, I ) - WORK( I, J )
  200             CONTINUE
  210          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**T  where  C = ( C1  C2 )
*
*              W := C * V**T  =  (C1*V1**T + C2*V2**T)  (stored in WORK)
*
*              W := C2
*
               DO 220 J = 1, K
                  CALL SCOPY( M, C( 1, N-K+J ), 1, WORK( 1, J ), 1 )
  220          CONTINUE
*
*              W := W * V2**T
*
               CALL STRMM( 'Right', 'Lower', 'Transpose', 'Unit', M,
     $                     K,
     $                     ONE, V( 1, N-K+1 ), LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C1 * V1**T
*
                  CALL SGEMM( 'No transpose', 'Transpose', M, K, N-K,
     $                        ONE, C, LDC, V, LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**T
*
               CALL STRMM( 'Right', 'Lower', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V
*
               IF( N.GT.K ) THEN
*
*                 C1 := C1 - W * V1
*
                  CALL SGEMM( 'No transpose', 'No transpose', M, N-K,
     $                        K,
     $                        -ONE, WORK, LDWORK, V, LDV, ONE, C, LDC )
               END IF
*
*              W := W * V2
*
               CALL STRMM( 'Right', 'Lower', 'No transpose', 'Unit',
     $                     M,
     $                     K, ONE, V( 1, N-K+1 ), LDV, WORK, LDWORK )
*
*              C1 := C1 - W
*
               DO 240 J = 1, K
                  DO 230 I = 1, M
                     C( I, N-K+J ) = C( I, N-K+J ) - WORK( I, J )
  230             CONTINUE
  240          CONTINUE
*
            END IF
*
         END IF
      END IF
*
      RETURN
*
*     End of SLARFB
*
      END
