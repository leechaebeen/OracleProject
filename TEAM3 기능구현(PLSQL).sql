SELECT USER
FROM DUAL;
--==>> TEAM3

/*
            ����

[ �⺻���̺� �Է�/����/���� ] 

- ���� ���� �Է�/���� ��� 
- �ߵ�Ż���� �Է�/ ���� ��� 
- ���� ���̺�(books) �Է�/���� ��� 
- ���� ���̺�(courses) �Է�/���� ��� 
- ���ǽ� ���̺�(classrooms) �Է�/���� ��� 

[ �������� �䱸�м� ]

��. ������ ���� ���� ��� ����
    1. ������ �α���

��. ������ ���� ���� ��� ����
    2. ������ ��� ���
    3. ��� �������� ���� ���
    4. �Էµ� ������ ���� ����, ����

��. ���� ���� ��� ����
    5. �������� ���
    6. ��ϵ� ��� ���� ���� ��� 
    7. �Էµ� ��������(OP_COURSES) ����, ����

��. ���� ���� ��� ����

    8. ���� �� ���� ���� ��� (���񰳼�) 
    9. ���� ������ �̸� ���� 
    10.���� ��� ������ ���� 
    11.��� ��ϵ� ������ ���� ���
    12.�������� ���� ����, ���� 

��. �л� ���� ��� ����
    13. ���� �� �������� �л� ���
    14.������ �����ϴ� �л��� ��� ��� ���
    15. ��� �л��� ���� ���
    16. �Էµ� �л� ���� ����, ���� 
    17. ������ �л� ��� ��� 

��. ���� ���� ��� ����
    �л� �� �䱸�м�, �������� �䱸�м��� �ߺ���

[ ������� �䱸�м�(������) ]

��.�α��� ��� ����
    18. ������ �α���

��. ���� �Է� ��� ���� 
    19. �� ���� ���� ���� 
    20. �ڽ��� ������ ���� ���� ó��(�Է�/����/����)

�� ���� ��� ��� ����
    21. �ڽ��� ������ ������ ���� ���


[ ������� �䱸�м�(�л�) ]

��. �α��� ��� ����
    22. �л� �α���

��. ���� ��� ��� ����
    23. ���� ���� ���� ��� ��� 
    24. ���� ���� �� ���� ���� �� ����Ȯ��
    25. ��� ������ �� ���������� ���(�Ű����� :�й�)
    
*/


--[ �⺻���̺� �Է�/����/���� ���]---------------------------------------------------------------------------------------------

-- ��  ����(SUBJECTS) ���� �Է� 
CREATE OR REPLACE PROCEDURE PRC_SUBJECTS_INSERT
(V_NAME SUBJECTS.NAME%TYPE
)
IS
BEGIN
    INSERT INTO SUBJECTS(CODE,NAME)    
    VALUES(SEQ_SUBJECTS.NEXTVAL,V_NAME);
    
     COMMIT;
END;

-- �� ����(SUBJECTS) ���� ����
CREATE OR REPLACE PROCEDURE SUBJECTS_DEL
(V_CODE IN  SUBJECTS.CODE%TYPE) 
IS
BEGIN

    DELETE
    FROM SUBJECTS
    WHERE CODE = V_CODE;
    
    COMMIT;
END;

--�� �ߵ�Ż����(NON_PASS) �Է� ���
CREATE OR REPLACE PROCEDURE PRC_NON_PASS_INSERT
( V_SCL_NUM NON_PASS.SCL_NUM%TYPE)
IS

    V_START_DATE OP_COURSES.START_DATE%TYPE;
    V_END_DATE OP_COURSES.END_DATE%TYPE;
    V_OP_COURSE_CODE STUDENT_COURSES_LISTS.OP_COURSE_CODE%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;

BEGIN
        SELECT OP_COURSE_CODE INTO V_OP_COURSE_CODE
        FROM STUDENT_COURSES_LISTS
        WHERE NUM = V_SCL_NUM;
        
        SELECT START_DATE , END_DATE INTO V_START_DATE , V_END_DATE
        FROM OP_COURSES
        WHERE CODE = V_OP_COURSE_CODE;


        IF(SYSDATE < V_START_DATE OR SYSDATE > V_END_DATE) 
        THEN RAISE USER_DEFINE_ERROR;
        END IF;
       
        INSERT INTO NON_PASS(NUM,SCL_NUM,NP_DATE)    
        VALUES(SEQ_NON_PASS.NEXTVAL,V_SCL_NUM,SYSDATE);
        
        COMMIT;
        
        EXCEPTION
            WHEN USER_DEFINE_ERROR
                THEN RAISE_APPLICATION_ERROR(-20001, '�ߵ�Ż�� ���� ����');
                ROLLBACK;
END;


--�� �ߵ�Ż���� ���� ��� 
CREATE OR REPLACE PROCEDURE NP_STUDENTS_DELETE
( V_NP_NUM     IN NON_PASS.NUM%TYPE)
IS
    V_COUNT     NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT
    FROM NON_PASS
    WHERE NUM = V_NP_NUM;
    
    IF (V_COUNT = 0) 
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

        
    DELETE
    FROM NON_PASS
    WHERE NUM = V_NP_NUM;
    
     COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '�ش� ��ȣ�� �������� �ʽ��ϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK; 
END;

--�� ����(BOOKS) �Է� ���
CREATE OR REPLACE PROCEDURE PRC_BOOKS_INSERT
( V_NAME    BOOKS.NAME%TYPE)
IS
BEGIN

    INSERT INTO BOOKS(NUM,NAME)    
    VALUES(SEQ_BOOKS.NEXTVAL,V_NAME);
    
    COMMIT;

END;

--�� ����(BOOKS) ���� ���
CREATE OR REPLACE PROCEDURE PRC_BOOKS_DELETE
( V_NUM    BOOKS.NUM%TYPE)
IS
    
    V_COUNT     NUMBER;
    NUMBERMAN   BOOKS.NUM%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    FLAG    NUMBER :=0 ;

    CURSOR CUR_BOOKS
    IS
    SELECT NUM
    FROM BOOKS;

BEGIN

    OPEN CUR_BOOKS;
    
    LOOP
    FETCH CUR_BOOKS INTO NUMBERMAN;
    
    IF(V_NUM = NUMBERMAN)
    THEN DELETE
         FROM BOOKS
         WHERE NUM = V_NUM;
         FLAG := 1;
    END IF;
    
    EXIT WHEN FLAG = 1 OR CUR_BOOKS%NOTFOUND; 
    
    END LOOP;
    
    CLOSE CUR_BOOKS;
    
    IF(FLAG=0)
    THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    COMMIT;

    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20003 ,'���� �����Դϴ�.');
         ROLLBACK;

END;

-- �� ����(COURSES) �Է� ���
CREATE OR REPLACE PROCEDURE PRC_COURSES_ADD
(V_NAME IN COURSES.NAME%TYPE)
IS
BEGIN
    INSERT INTO COURSES VALUES (SEQ_COURSES_CODE.NEXTVAL, V_NAME);
END;


--�� ����(COURSES) ���� ���
CREATE OR REPLACE PROCEDURE PRC_DEL_COURSES
( V_CODE        IN COURSES.CODE%TYPE
)
IS

    CURSOR CUR_COURSE_DATE
    IS
    SELECT START_DATE, END_DATE
    FROM OP_COURSES
    WHERE COURSE_CODE = V_CODE;
    
    C_START_DATE   OP_COURSES.START_DATE%TYPE;
    C_END_DATE     OP_COURSES.END_DATE%TYPE;
    FLAG           NUMBER :=0 ;
    USER_DEFINE_ERROR   EXCEPTION;

BEGIN

    OPEN CUR_COURSE_DATE;
    
    LOOP
        FETCH CUR_COURSE_DATE INTO C_START_DATE, C_END_DATE;
        
        IF (SYSDATE >= C_START_DATE AND SYSDATE <= C_END_DATE)
            THEN FLAG := 1;
        END IF;
    
        EXIT WHEN CUR_COURSE_DATE%NOTFOUND;
        
    END LOOP;
    
    CLOSE CUR_COURSE_DATE;
    
    IF (FLAG = 1)
        THEN RAISE USER_DEFINE_ERROR;
    ELSE
        DELETE FROM COURSES
        WHERE CODE = V_CODE;
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '�������� ������ ������ �� �����ϴ�.');
            ROLLBACK;
END;

--�� ���ǽ�(CLASSROOMS) �Է� ��� 
CREATE OR REPLACE PROCEDURE PRC_CLASSROOMS_ADD 
( V_INFO   IN  CLASSROOMS.INFO%TYPE)
IS
BEGIN
        INSERT INTO CLASSROOMS(CODE, INFO) VALUES (SEQ_CLASSROOMS.NEXTVAL, V_INFO);
END;

--�� ���ǽ�(CLASSROOMS) ���� ��� 
CREATE OR REPLACE PROCEDURE PRC_CLASSROOMS_DEL 
( V_CODE    IN  CLASSROOMS.CODE%TYPE
)
IS
    V_COUNT             NUMBER;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
        SELECT COUNT(*) INTO V_COUNT
        FROM CLASSROOMS
        WHERE CODE = V_CODE;
        
        IF(V_COUNT = 0)
            THEN RAISE USER_DEFINE_ERROR;
        END IF;
        
        DELETE
        FROM CLASSROOMS 
        WHERE CODE = V_CODE;
        
        COMMIT;
        
        EXCEPTION 
            WHEN USER_DEFINE_ERROR
            THEN  RAISE_APPLICATION_ERROR(-20005, '�ش� ���ǽ��� �������� �ʽ��ϴ�.');
                  ROLLBACK;
END;



--[ �������� �䱸�м� ]---------------------------------------------------------------------------------------------------------

--��. ������ ���� ���� ��� ����

--��  ������ �α���
CREATE OR REPLACE FUNCTION FN_ADMIN_LOGIN
(V_ID IN ADMIN.ID%TYPE 
,V_PW IN ADMIN.PW%TYPE
)
RETURN NUMBER
IS
-- ���� ����
V_PW2    ADMIN.PW%TYPE;
V_FLAG   NUMBER := 0;
-- ���� ���� ����
USER_LOGIN_ERROR    EXCEPTION;
BEGIN
-- ������ ������ �� ����     
    BEGIN
        SELECT PW INTO V_PW2
        FROM ADMIN
        WHERE ID = V_ID;
    EXCEPTION
        WHEN OTHERS THEN RAISE USER_LOGIN_ERROR;  
    END;
    
    -- �Է��� �н����尡 �������� �н����尡 ������ 1 ��ȯ
    IF(V_PW = V_PW2)
        THEN V_FLAG := 1;
        ELSE V_FLAG := 2;
    END IF;
    
    RETURN V_FLAG;
    
    EXCEPTION 
       WHEN USER_LOGIN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006, '�ش� ���̵� �������� �ʽ��ϴ�.');
                 ROLLBACK;
    
END;

--��. ������ ���� ���� ��� ����

--�� ������ ��� ���(�̸�, �ֹι�ȣ ���ڸ�) 
CREATE OR REPLACE PROCEDURE PRC_PROFESSORS_INSERT
( V_PR_NAME    IN PROFESSORS.NAME%TYPE
, V_PR_SSN     IN PROFESSORS.SSN%TYPE
)
IS
    V_PR_ID        PROFESSORS.ID%TYPE;
    V_PR_PW        PROFESSORS.PW%TYPE;
    
    SSN_LEGNTH_ERROR EXCEPTION;
BEGIN
    V_PR_PW := V_PR_SSN;
     
    BEGIN
        IF(LENGTH(V_PR_SSN) <= 6 OR LENGTH(V_PR_SSN) >=8)
            THEN RAISE SSN_LEGNTH_ERROR;
        END IF;
        
        SELECT ID INTO V_PR_ID  
        FROM PROFESSORS
        WHERE NAME = V_PR_NAME
          AND SSN = V_PR_SSN;
    EXCEPTION
        WHEN SSN_LEGNTH_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007, '�ֹι�ȣ ���̰� ���� �ʽ��ϴ�.');
        WHEN OTHERS THEN V_PR_ID := LPAD(SEQ_PROFESSORS_ID.NEXTVAL, 6, '0');
             INSERT INTO PROFESSORS(ID, PW, SSN, NAME)
             VALUES(V_PR_ID, V_PR_PW, V_PR_SSN, V_PR_NAME);    
    END;
    
    COMMIT;

END;

--�� ��� �������� ���� ��� ��(�����ڸ�, ������ �����, ����Ⱓ, �����, ���ǽ�, �������࿩��) 
CREATE OR REPLACE VIEW VIEW_PROFESSOR_INFO
AS
SELECT P1.NAME "�����ڸ�"
     , P3.NAME "�����Ȱ����"
     , P4.START_DATE "�������"
     , P4.END_DATE "��������"
     , P5.NAME "�����"
     , P7.INFO "���ǽ�"
     , (CASE WHEN P4.END_DATE < SYSDATE  THEN '���� ����' 
             WHEN SYSDATE < P4.START_DATE THEN '���� ����'
             WHEN (P4.START_DATE < SYSDATE) AND (SYSDATE < P4.END_DATE) THEN '���� ��' 
                 ELSE '������'       
            END) "�������࿩��"
FROM PROFESSORS P1
   , PROFESSOR_TEACHABLE_SUBJECTS P2
   , SUBJECTS P3
   , OP_SUBJECTS P4
   , BOOKS P5
   , OP_COURSES P6
   , CLASSROOMS P7
WHERE P1.ID = P2.PRO_ID(+)
  AND P2.SUB_CODE = P3.CODE(+)
  AND P2.CODE = P4.PTS_CODE(+)
  AND P4.BOOK_NUM = P5.NUM(+)
  AND P4.OP_COURSE_CODE = P6.CODE(+)
  AND P6.ROOM_CODE = P7.CODE(+)
  AND P1.ID = P6.PRO_ID;
  
--�� �Էµ� �����ڸ� ���� 
CREATE OR REPLACE PROCEDURE PRC_PRO_NAME_CHANGE
( V_ID       IN PROFESSORS.ID%TYPE
, V_NAME    IN PROFESSORS.NAME%TYPE
)   
IS
BEGIN

    UPDATE PROFESSORS
    SET NAME = V_NAME
    WHERE ID = V_ID; 
    
     COMMIT;
    
END;

--�� �Էµ� ������ �н����� ����
CREATE OR REPLACE PROCEDURE PRC_PRO_PW_CHANGE
( V_ID       IN PROFESSORS.ID%TYPE
, V_PW   IN PROFESSORS.PW%TYPE
)   
IS
BEGIN

    UPDATE PROFESSORS
    SET PW = V_PW
    WHERE ID = V_ID; 
    
     COMMIT;
    
END;

--�� �Էµ� ������ ���� ����
CREATE OR REPLACE PROCEDURE PRC_PRO_DEL
( V_ID  IN  PROFESSORS.ID%TYPE)
IS
BEGIN
        DELETE
        FROM PROFESSORS
        WHERE ID = V_ID;
        
        COMMIT;
END;


--��. ���� ���� ��� ����

--�� �������� ��� ��� (������, �����Ⱓ, ���ǽ� ����, �����ڸ�)
CREATE OR REPLACE PROCEDURE PRC_OP_COURSES_INSERT
( V_NAME        IN  COURSES.NAME%TYPE
, V_ROOM_CODE   IN  OP_COURSES.ROOM_CODE%TYPE
, V_START_DATE  IN  OP_COURSES.START_DATE%TYPE  
, V_END_DATE    IN  OP_COURSES.END_DATE%TYPE  
, V_PRO_ID      IN  PROFESSORS.ID%TYPE
)
IS
-- ���� ���� 
C_CODE  COURSES.CODE%TYPE;

BEGIN
      
    -- ������ ������ �� ���� 
    BEGIN
        SELECT CODE INTO C_CODE
        FROM COURSES
        WHERE NAME = V_NAME;    
    EXCEPTION
        WHEN OTHERS THEN C_CODE := SEQ_COURSES_CODE.NEXTVAL;
                         INSERT INTO COURSES(CODE,NAME) VALUES(C_CODE,V_NAME);  
    END;
    
    
    -- ���������� ������ �Է�  
    INSERT INTO OP_COURSES(CODE, ROOM_CODE, COURSE_CODE, PRO_ID, START_DATE, END_DATE) 
    VALUES(SEQ_OP_COURSES_CODE.NEXTVAL, V_ROOM_CODE, C_CODE, V_PRO_ID, V_START_DATE, V_END_DATE); 
    
    COMMIT;
    
END;

--�� ��ϵ� ��� ���� ���� ��� (������, ���ǽ�, �����, ������ۿ�����, ��������, �����, �����ڸ�) 
CREATE OR REPLACE VIEW VIEW_COURSE_INFO 
AS
SELECT C1.NAME "������"
     , C3.INFO "���ǽ�"
     , C8.NAME "�����"
     , C4.START_DATE "�������"
     , C4.END_DATE "��������"
     , C5.NAME "�����"
     , C6.NAME "�����ڸ�"
FROM COURSES C1, OP_COURSES C2, CLASSROOMS C3, OP_SUBJECTS C4, BOOKS C5, PROFESSORS C6, PROFESSOR_TEACHABLE_SUBJECTS C7, SUBJECTS C8
WHERE C1.CODE = C2.COURSE_CODE(+)
  AND C2.ROOM_CODE = C3.CODE(+)
  AND C2.CODE = C4.OP_COURSE_CODE(+)
  AND C4.BOOK_NUM = C5.NUM(+)
  AND C2.PRO_ID = C6.ID(+)
  AND C4.PTS_CODE = C7.CODE(+)
  AND C7.SUB_CODE = C8.CODE(+);


--�� �Էµ� ���� ����(������, ���ǽ�, ������, �����Ⱓ) ���   
-- 1. ������ ���� 
CREATE OR REPLACE PROCEDURE PRC_CHANGE_COURSE_NAME
( V_CODE        IN OP_COURSES.CODE%TYPE -- �����Ϸ��� ���� ����
, V_NAME        IN COURSES.NAME%TYPE   -- ������ ������
)
IS
    CURSOR CUR_COMPARE
    IS
    SELECT NAME
    FROM COURSES;
    
    COURSES_NAME         COURSES.NAME%TYPE;
    FLAG                 NUMBER  := 0;
    C_COURSES_CODE         COURSES.CODE%TYPE;
    
BEGIN

    SELECT COURSE_CODE INTO C_COURSES_CODE
    FROM OP_COURSES
    WHERE CODE = V_CODE;

    OPEN CUR_COMPARE;
    
    LOOP
    
        FETCH CUR_COMPARE INTO COURSES_NAME; -- COURSES ���̺� �ִ� NAME
        
        IF (V_NAME = COURSES_NAME) -- �Է��� ������� ������ �̸��� �������� �����Ѵٸ�...
            THEN FLAG := 1;
        END IF;
        EXIT WHEN CUR_COMPARE%NOTFOUND;
    
    END LOOP;
    
    CLOSE CUR_COMPARE;
    
    IF (FLAG = 0) -- FLAG �� 0 �϶�, �� �Է��� ������� ������ �̸��� �������� �������� �ʴ´ٸ�...
        THEN INSERT INTO COURSES(CODE, NAME) VALUES (SEQ_COURSES_CODE.NEXTVAL, V_NAME);
             
             SELECT CODE INTO C_COURSES_CODE
             FROM COURSES
             WHERE NAME = V_NAME;
        
             UPDATE OP_COURSES
             SET COURSE_CODE = C_COURSES_CODE
             WHERE CODE = V_CODE;
    ELSIF (FLAG = 1)
        THEN
            SELECT CODE INTO C_COURSES_CODE
            FROM COURSES
            WHERE NAME = V_NAME;
        
            UPDATE OP_COURSES
            SET COURSE_CODE = C_COURSES_CODE
            WHERE CODE = V_CODE;
    END IF;
    
     COMMIT;
    
END;


-- 2. ���ǽ� ���� 
CREATE OR REPLACE PROCEDURE PRC_OP_COURSES_UPDATE_ROOM
( V_OPC_CODE    IN OP_COURSES.CODE%TYPE
, V_ROOM_CODE   IN CLASSROOMS.CODE%TYPE
)
IS
    V_START_DATE    OP_COURSES.START_DATE%TYPE;
    V_END_DATE      OP_COURSES.END_DATE%TYPE;
    V_COUNT         NUMBER;
    RESERVED_ROOM_ERROR EXCEPTION;
    NOEXIST_ROOM_ERROR EXCEPTION;
    
    C_ROOMCODE  CLASSROOMS.CODE%TYPE;
    FLAG    NUMBER :=0;
    USER_DEFINE_ERROR       EXCEPTION;
    
    CURSOR CUR_ROOMCODE
    IS
    SELECT CODE
    FROM CLASSROOMS;
    
BEGIN
    
    -- ���� ��ȣ�� ���� ��

    OPEN CUR_ROOMCODE;
    
    LOOP
        FETCH CUR_ROOMCODE INTO C_ROOMCODE;
        
        IF (V_ROOM_CODE = C_ROOMCODE)
            THEN FLAG :=1;
        END IF;
        
        EXIT WHEN CUR_ROOMCODE%NOTFOUND;
        
    END LOOP;
    
    CLOSE CUR_ROOMCODE;
    
    IF (FLAG = 0)
        THEN RAISE NOEXIST_ROOM_ERROR;
    END IF;
    
            
    -- ���ǱⰣ�� ��ĥ���

    SELECT START_DATE, END_DATE INTO V_START_DATE, V_END_DATE
    FROM OP_COURSES
    WHERE CODE = V_OPC_CODE;
    
    SELECT COUNT(*) INTO V_COUNT
    FROM OP_COURSES
    WHERE ROOM_CODE = V_ROOM_CODE 
      AND ( START_DATE <= V_END_DATE OR END_DATE >= V_START_DATE );

    IF (V_COUNT > 0)
        THEN RAISE RESERVED_ROOM_ERROR;
    END IF;
    
    UPDATE OP_COURSES
    SET ROOM_CODE = V_ROOM_CODE
    WHERE CODE = V_OPC_CODE;
    
    COMMIT;
    
EXCEPTION
    WHEN RESERVED_ROOM_ERROR THEN RAISE_APPLICATION_ERROR(-20008, '�����Ⱓ �� ������ �̹� ����� �����Դϴ�.'); ROLLBACK;
    WHEN NOEXIST_ROOM_ERROR THEN RAISE_APPLICATION_ERROR(-20009, '�ش� ���ǽ� ��ȣ�� �������� �ʽ��ϴ�.'); ROLLBACK;
    --WHEN OTHERS THEN ROLLBACK;
END;


-- 3. ���� ��� ������ ����  - �� ������ �����ϴ� ���������� �ִٸ� �� ������� ����ĥ �� �ִ� �����ڷθ� ��������
CREATE OR REPLACE PROCEDURE CHANGE_PRO
( V_CODE       IN OP_COURSES.CODE%TYPE
, V_PRO_ID     IN OP_COURSES.PRO_ID%TYPE
)
IS 
    V_CODE_SU        NUMBER;
    P_CODE_SU        NUMBER;
    C_PTS_CODE       PROFESSOR_TEACHABLE_SUBJECTS.CODE%TYPE;
    C2_PTS_CODE      PROFESSOR_TEACHABLE_SUBJECTS.CODE%TYPE;
    C_SUB_CODE       PROFESSOR_TEACHABLE_SUBJECTS.SUB_CODE%TYPE;
    C2_SUB_CODE      PROFESSOR_TEACHABLE_SUBJECTS.SUB_CODE%TYPE;
    FLAG             NUMBER     := 0;            
    
    CURSOR CUR_COMPARE(A_CODE OP_SUBJECTS.OP_COURSE_CODE%TYPE)
    IS
    SELECT PTS_CODE
    FROM OP_SUBJECTS OS
    WHERE OS.OP_COURSE_CODE= A_CODE;
    
    CURSOR CUR_COMPARE2(A_PRO_ID PROFESSOR_TEACHABLE_SUBJECTS.PRO_ID%TYPE)
    IS
    SELECT CODE
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE PRO_ID= A_PRO_ID;--A_CODE;
    
    USER_DEFINE_ERROR    EXCEPTION;
BEGIN
    
    SELECT COUNT(*) INTO V_CODE_SU
    FROM OP_SUBJECTS
    WHERE OP_COURSE_CODE = V_CODE; -- ���� �Է��� �ڽ��� ������ �ִ� ���� ��
   
    IF (V_CODE_SU > P_CODE_SU)
        THEN RAISE USER_DEFINE_ERROR;
    
    ELSE -- V_CODE_SU == P_CODE_SU �̰ų� V_CODE_SU < P_CODE_SU �� ��
    
        OPEN CUR_COMPARE(V_CODE);
        LOOP
            
            FETCH CUR_COMPARE INTO C_PTS_CODE;
            
            SELECT SUB_CODE INTO C_SUB_CODE
            FROM PROFESSOR_TEACHABLE_SUBJECTS
            WHERE CODE = C_PTS_CODE;
                        
            
            SELECT CODE INTO C2_PTS_CODE
            FROM PROFESSOR_TEACHABLE_SUBJECTS
            WHERE SUB_CODE = C_SUB_CODE AND PRO_ID = V_PRO_ID;
 
            UPDATE OP_SUBJECTS
            SET PTS_CODE = C2_PTS_CODE
            WHERE OP_COURSE_CODE = V_CODE AND PTS_CODE = C_PTS_CODE;
                      
            
            EXIT WHEN CUR_COMPARE%NOTFOUND;
        
        END LOOP;
        
        CLOSE CUR_COMPARE;
    
        UPDATE OP_COURSES
        SET PRO_ID = V_PRO_ID
        WHERE CODE = V_CODE;
    END IF;
    
    COMMIT;
    
    EXCEPTION 
        WHEN USER_DEFINE_ERROR 
            THEN RAISE_APPLICATION_ERROR(-20010, '�ش� ������ȣ�� ���� ������ �Ұ����մϴ�. (�������ɰ��� ����)');
                 ROLLBACK;
    
END;

--4. ���� �Ⱓ ���� (������ ������ ���� ������ �׳� ����, ���� ���� ������ �Ұ��� )
CREATE OR REPLACE PROCEDURE PRC_OP_COURSE_CHANGE_DATE
(V_CODE         IN  OP_COURSES.CODE%TYPE
,V_START_DATE   IN  OP_COURSES.START_DATE%TYPE
,V_END_DATE     IN  OP_COURSES.END_DATE%TYPE)
IS
    V_COUNT NUMBER;
    V_FLAG  NUMBER;
    
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    
    -- ������ ������ �����ϴ� ���������� ���� ��� �Ⱓ���� �Ұ��� 
    SELECT COUNT(*) INTO V_COUNT
    FROM OP_SUBJECTS
    WHERE OP_COURSE_CODE = V_CODE;
    
    IF(V_COUNT>0)
        THEN RAISE USER_DEFINE_ERROR ;
    END IF;
    
    UPDATE OP_COURSES
    SET START_DATE = V_START_DATE , END_DATE = V_END_DATE
    WHERE CODE = V_CODE;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR    
        THEN RAISE_APPLICATION_ERROR(-20011, '�ش� ������ ���������� �����մϴ�.');
        ROLLBACK;

END;

--�� ���� ���� ��� 
CREATE OR REPLACE PROCEDURE PRC_OP_COURSE_DEL
( V_CODE    IN  OP_COURSES.CODE%TYPE)
IS
BEGIN
    DELETE
    FROM OP_COURSES
    WHERE CODE = V_CODE;
    
    COMMIT;
    
END;

--��. ���� ���� ��� ����

--�� ���� �� ���� ���� ��� (= ���񰳼� OP_SUBJECTS) (������, �����, ����Ⱓ, �����, �����ڸ�)
CREATE OR REPLACE PROCEDURE PRC_SUB_OPEN 
( V_OP_COURSE_CODE IN  OP_COURSES.CODE%TYPE
, V_START_DATE     IN  OP_SUBJECTS.START_DATE%TYPE
, V_END_DATE       IN  OP_SUBJECTS.END_DATE%TYPE
, V_BOOK_NUM       IN  OP_SUBJECTS.BOOK_NUM%TYPE
, V_PTS_CODE       IN  PROFESSOR_TEACHABLE_SUBJECTS.CODE%TYPE
)
IS
-- ���� ����
C_OP_COURSE_CODE   OP_COURSES.CODE%TYPE;
C_PTS_CODE         PROFESSOR_TEACHABLE_SUBJECTS.CODE%TYPE;
C_BOOK_NUM         OP_SUBJECTS.BOOK_NUM%TYPE;

C_START_DATE        OP_COURSES.START_DATE%TYPE;
C_END_DATE          OP_COURSES.END_DATE%TYPE;

-- ī��Ʈ ���� ���� 
V_COUNT NUMBER;

-- ���� ���� ����
SUB_OPEN_CERROR   EXCEPTION;
SUB_OPEN_SERROR   EXCEPTION;
SUB_OPEN_BERROR   EXCEPTION;
SUB_OPEN_DERROR   EXCEPTION;

BEGIN
    
    --������ ������ �� �Է�
    -- �������� ���ų� ������� ���ų� ������� ���ų� �����ڸ��� ������ ����ó�� - ��� �����ϼ��� 
    
    -- �������� ���� ��� 
    SELECT COUNT(*) INTO V_COUNT
    FROM OP_COURSES
    WHERE CODE = V_OP_COURSE_CODE;
    
    IF(V_COUNT = 0)
        THEN RAISE SUB_OPEN_CERROR;
    END IF;
    
    -- ������ �������� ���� ��� 
    SELECT COUNT(*) INTO V_COUNT
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE CODE =  V_PTS_CODE;
    
    IF(V_COUNT = 0)
        THEN RAISE SUB_OPEN_SERROR;
    END IF;
    
     -- ������� ���� ��� 
    SELECT COUNT(*) INTO V_COUNT
    FROM BOOKS
    WHERE NUM = V_BOOK_NUM;
    
    IF(V_COUNT = 0)
        THEN RAISE SUB_OPEN_BERROR;
    END IF;
    
    -- �����Ϸ��� ������ �Ⱓ�� ������ �Ⱓ ���� �����ؾ� �Ѵ�.
    SELECT START_DATE, END_DATE INTO C_START_DATE, C_END_DATE
    FROM OP_COURSES
    WHERE CODE = V_OP_COURSE_CODE;
    
    IF(C_START_DATE <= V_START_DATE AND  V_END_DATE <= C_END_DATE)
        THEN  INSERT INTO OP_SUBJECTS(NUM, BOOK_NUM, PTS_CODE, OP_COURSE_CODE, START_DATE, END_DATE)
              VALUES(SEQ_OP_SUBJECTS_CODE.NEXTVAL, V_BOOK_NUM, V_PTS_CODE, V_OP_COURSE_CODE, V_START_DATE, V_END_DATE);
    ELSE RAISE SUB_OPEN_DERROR;          
    END IF;

    COMMIT;
    
    EXCEPTION
        WHEN SUB_OPEN_CERROR THEN RAISE_APPLICATION_ERROR(-20012,'��ϵ��� ���� �����Դϴ�.');
                    ROLLBACK;
        WHEN SUB_OPEN_SERROR THEN RAISE_APPLICATION_ERROR(-20013,'��ϵ��� ���� �����Դϴ�.');
                    ROLLBACK;
        WHEN SUB_OPEN_BERROR THEN RAISE_APPLICATION_ERROR(-20024,'��ϵ��� ���� �����Դϴ�.');
                    ROLLBACK;
        WHEN SUB_OPEN_DERROR THEN RAISE_APPLICATION_ERROR(-20015,'�Ⱓ�� Ȯ�����ּ���.');
                    ROLLBACK;            
        
END; 
 
 
--�� ������ ���� ���� ����(PROFESSOR_TEACHABLE_SUBJECTS) �Է� ���
--  (�䱸�м��� �� - ���� ������ �̸� �����ϴ� ���) 
CREATE OR REPLACE PROCEDURE ALREADY_BAEJUNG
( V_PRO_ID    IN PROFESSORS.ID%TYPE
, V_SUB_CODE  IN SUBJECTS.CODE%TYPE
)
IS
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN  

    IF(V_PRO_ID IS NULL OR V_SUB_CODE IS NULL)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    INSERT INTO PROFESSOR_TEACHABLE_SUBJECTS(CODE,PRO_ID, SUB_CODE)
           VALUES(SEQ_PTS_CODE.NEXTVAL,V_PRO_ID, V_SUB_CODE);
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20016, '��ĭ�� ä���ּ���');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;      

END;

--�� ������ ���� ���� ����(PROFESSOR_TEACHABLE_SUBJECTS) ���� ��� 
CREATE OR REPLACE PROCEDURE PRC_PTS_DELETE
( V_PTS_CODE    IN PROFESSOR_TEACHABLE_SUBJECTS.CODE%TYPE )
IS 
    V_COUNT     NUMBER;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_COUNT
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE CODE = V_PTS_CODE;
    
    IF (V_COUNT = 0)
        THEN RAISE USER_DEFINE_ERROR ;
    END IF;
    
    DELETE
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE CODE = V_PTS_CODE;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20017, '�ش� ��ȣ�� �������� �ʽ��ϴ�.');
             ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;      
END;


-- �� ��� ��ϵ� ������ ���� ��� ��(������,���ǽ�, �����, ����Ⱓ, �����, �����ڸ�)
CREATE OR REPLACE VIEW VIEW_SUBJECT_INFO
AS
SELECT S1.NAME "������"
     , S3.INFO "���ǽ�"
     , S8.NAME "�����"
     , S4.START_DATE "�������"
     , S4.END_DATE "��������"
     , S6.NAME "�����"
     , S5.NAME "�����ڸ�"
FROM COURSES S1, OP_COURSES S2, CLASSROOMS S3, OP_SUBJECTS S4, PROFESSORS S5, BOOKS S6, PROFESSOR_TEACHABLE_SUBJECTS S7, SUBJECTS S8
WHERE S1.CODE = S2.COURSE_CODE(+)
  AND S2.ROOM_CODE = S3.CODE(+)
  AND S2.CODE = S4.OP_COURSE_CODE(+)
  AND S2.PRO_ID = S5.ID(+)
  AND S4.BOOK_NUM = S6.NUM(+)
  AND S4.PTS_CODE = S7.CODE
  AND S5.ID = S7.PRO_ID(+)
  AND S7.SUB_CODE = S8.CODE(+);
  

--�� �Էµ� ���� ���� ���� ����(����Ⱓ, ������, �����), ���� 
                                        
--1. ���� �Ⱓ ����
CREATE OR REPLACE PROCEDURE PRC_OP_SUBJECTS_UPDATE_DATE
( V_OPS_NUM     IN OP_SUBJECTS.NUM%TYPE
, V_START_DATE  IN OP_SUBJECTS.START_DATE%TYPE
, V_END_DATE    IN OP_SUBJECTS.END_DATE%TYPE
)
IS
    V_C_START_DATE  OP_COURSES.START_DATE%TYPE;
    V_C_END_DATE    OP_COURSES.END_DATE%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    IF (V_START_DATE > V_END_DATE)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    SELECT START_DATE, END_DATE INTO V_C_START_DATE, V_C_END_DATE
    FROM OP_COURSES
    WHERE CODE = (SELECT OP_COURSE_CODE
                  FROM OP_SUBJECTS
                  WHERE NUM = V_OPS_NUM);
                  
                  
    IF (V_C_START_DATE > V_START_DATE OR V_C_END_DATE < V_END_DATE)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    UPDATE OP_SUBJECTS
    SET START_DATE = V_START_DATE, END_DATE = V_END_DATE
    WHERE NUM = V_OPS_NUM;
    
    COMMIT;
EXCEPTION
    WHEN USER_DEFINE_ERROR 
        THEN RAISE_APPLICATION_ERROR(-20018, '�Է��� �Ⱓ�� ��ȿ���� �ʽ��ϴ�.');
        ROLLBACK;
END;


--2. �ʿ��� ��� �������� ��� ������ ���� ��� 
--  (�� ���� ���� Ư������ �ٸ� �����ڰ� ����ġ�� �Ǿ��� ��츦 ���) 
CREATE OR REPLACE PROCEDURE PRC_OP_SUBJECTS_UPDATE_PROF
( V_OPS_NUM     IN OP_SUBJECTS.NUM%TYPE
, V_PRO_ID      IN PROFESSORS.ID%TYPE
)
IS
    
    V_COUNT     NUMBER;
    V_PTS_CODE  PROFESSOR_TEACHABLE_SUBJECTS.CODE%TYPE;
    V_SUB_CODE  SUBJECTS.CODE%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN

    -- ������ ������ �� �Ҵ� 
    SELECT COUNT(*) INTO V_COUNT
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE CODE = (SELECT PTS_CODE
                  FROM OP_SUBJECTS
                  WHERE NUM = V_OPS_NUM);

    -- PTS �ڵ尡 ���� ��� 
    IF(V_COUNT>0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    SELECT SUB_CODE INTO V_SUB_CODE
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE CODE = (SELECT PTS_CODE
                  FROM OP_SUBJECTS
                  WHERE NUM = V_OPS_NUM);

    SELECT CODE INTO V_PTS_CODE
    FROM PROFESSOR_TEACHABLE_SUBJECTS
    WHERE PRO_ID = V_PRO_ID AND SUB_CODE = V_SUB_CODE;
    
  
    UPDATE OP_SUBJECTS
    SET PTS_CODE = V_PTS_CODE
    WHERE NUM = V_OPS_NUM;
    
    COMMIT;
       
    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20019, '�ش� �����ڰ� ������ �� ���� �����Դϴ�.');
                ROLLBACK;
 
END;


-- 3. ����� ����
CREATE OR REPLACE PROCEDURE PRC_OP_SUBJECTS_UPDATE_BOOK
( V_OPS_NUM     IN OP_SUBJECTS.NUM%TYPE
, V_BOOK_NAME   IN BOOKS.NAME%TYPE
)
IS
    V_BOOK_NUM  BOOKS.NUM%TYPE;
BEGIN
    
    BEGIN
        SELECT NUM INTO V_BOOK_NUM
        FROM BOOKS
        WHERE NAME = V_BOOK_NAME;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_BOOK_NUM := SEQ_BOOKS.NEXTVAL;
                                INSERT INTO BOOKS VALUES(V_BOOK_NUM, V_BOOK_NAME);
    END;
    
    UPDATE OP_SUBJECTS
    SET BOOK_NUM = V_BOOK_NUM
    WHERE NUM = V_OPS_NUM;
    
    COMMIT;
END;

-- ���� ���� ���� 
CREATE OR REPLACE PROCEDURE OP_SUBJECTS_DELETE
( V_OPS_NUM IN OP_SUBJECTS.NUM%TYPE
)
IS
BEGIN
    DELETE
    FROM OP_SUBJECTS
    WHERE NUM = V_OPS_NUM;
    
    COMMIT;
END;

--��. �л� ���� ��� ����
--��  �� �� ������ ���� ���� �л� ��� ��� (�Է����� : �л���, �ֹε�Ϲ�ȣ ���ڸ�) 
CREATE OR REPLACE PROCEDURE PRC_INSERT_STUDENT
( V_STUDENT_NAME    IN STUDENTS.NAME%TYPE
, V_STUDENT_SSN     IN STUDENTS.SSN%TYPE
, V_OP_COURSES_CODE IN OP_COURSES.CODE%TYPE
)
IS
    V_STUDENT_ID        STUDENTS.ID%TYPE;
    V_STUDENT_PW        STUDENTS.PW%TYPE;
    
    SSN_LEGNTH_ERROR EXCEPTION;
BEGIN
    V_STUDENT_PW := V_STUDENT_SSN;
    
    BEGIN
        IF(LENGTH(V_STUDENT_SSN) <= 6 OR LENGTH(V_STUDENT_SSN) >=8)
            THEN RAISE SSN_LEGNTH_ERROR;
        END IF;
    
        SELECT ID INTO V_STUDENT_ID  
        FROM STUDENTS
        WHERE NAME = V_STUDENT_NAME
          AND SSN = V_STUDENT_SSN;
    EXCEPTION
        WHEN SSN_LEGNTH_ERROR
            THEN RAISE_APPLICATION_ERROR(-20020, '�ֹι�ȣ ���̰� ���� �ʽ��ϴ�.');
        WHEN OTHERS THEN V_STUDENT_ID := LPAD(SEQ_STUDENT_ID.NEXTVAL, 6, '0');
             INSERT INTO STUDENTS(ID, NAME, PW, SSN)
             VALUES(V_STUDENT_ID, V_STUDENT_NAME, V_STUDENT_SSN, V_STUDENT_SSN);    
    END;
    
    COMMIT;
    
    INSERT INTO STUDENT_COURSES_LISTS(NUM, STUDENT_ID, OP_COURSE_CODE)
    VALUES(SEQ_SCL_NUM.NEXTVAL, V_STUDENT_ID, V_OP_COURSES_CODE);
    
END;


--�� ���������� �����л� ��� Ȯ��(�ʿ䵥����: ���������ڵ�)
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_IN_COURSE
( V_OPC_CODE    IN  OP_COURSES.CODE%TYPE
, V_OUT         OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN V_OUT FOR
        SELECT ST.ID, ST.NAME
        FROM STUDENT_COURSES_LISTS SCL, NON_PASS NP, STUDENTS ST
        WHERE SCL.OP_COURSE_CODE = V_OPC_CODE
          AND NP.SCL_NUM(+) = SCL.NUM
          AND NP.NUM IS NULL
          AND ST.ID = SCL.STUDENT_ID;
END;


--�� ��� �л��� ���� ��� ��(�л���, ������, ��������, �������� ���� + �ߵ�Ż������)
CREATE OR REPLACE VIEW VIEW_STUDENT_INFO
AS
SELECT S1.NAME "�л��̸�"
     , S4.NAME "������"
     , S7.NAME "��������"
     , (S8.PRESENCE*(S5.PRE_RATE/100) + S8.PRACTICE*(S5.PRAC_RATE/100) + S8.WRITING*(S5.WRITE_RATE/100)) "������������"
     , TO_CHAR(S9.NP_DATE, 'YYYY/MM/DD') "�ߵ�Ż����¥"
FROM STUDENTS S1
   , STUDENT_COURSES_LISTS S2
   , OP_COURSES S3
   , COURSES S4
   , OP_SUBJECTS S5
   , PROFESSOR_TEACHABLE_SUBJECTS S6
   , SUBJECTS S7
   , SCORES S8
   , NON_PASS S9
WHERE S1.ID = S2.STUDENT_ID(+)
  AND S3.CODE(+) = S2.OP_COURSE_CODE
  AND S4.CODE(+) = S3.COURSE_CODE
  AND S3.CODE = S5.OP_COURSE_CODE(+)
  AND S6.CODE(+) = S5.PTS_CODE
  AND S6.SUB_CODE = S7.CODE(+)
  AND S2.NUM = S8.SCL_NUM(+)
  AND S2.NUM = S9.SCL_NUM(+)
  AND S8.OP_SUB_NUM = S5.NUM;
  
--�� �Էµ� �л� ���� ����(�л���, PW) , ���� 
-- 1. �л� ���� ����
CREATE OR REPLACE PROCEDURE STUDENT_UPDATE
( V_STUDENT_ID      IN STUDENTS.ID%TYPE
, V_STUDENT_NAME    IN STUDENTS.NAME%TYPE
, V_STUDENT_PW      IN STUDENTS.PW%TYPE
)
IS
BEGIN
    UPDATE STUDENTS
    SET NAME = V_STUDENT_NAME
      , PW = V_STUDENT_PW
    WHERE ID = V_STUDENT_ID;
    
    COMMIT;
END;

-- 2. �л� ���� ����
CREATE OR REPLACE PROCEDURE STUDENT_DELETE
( V_STUDENT_ID      IN STUDENTS.ID%TYPE
)
IS
BEGIN
    DELETE
    FROM STUDENTS
    WHERE ID = V_STUDENT_ID;
    
    COMMIT;
END;

-- ��. ���� ���� ��� ����
-- �л� �� �䱸�м�, �������� �䱸�м��� �ߺ���

-- [ ������� �䱸�м�(������) ] -----------------------------------------------------------------------------------------------

-- ��.�α��� ��� ����
-- �� ������ �α��� ���
CREATE OR REPLACE FUNCTION FN_PRO_LOGIN
(V_ID IN PROFESSORS.ID%TYPE 
,V_PW IN PROFESSORS.PW%TYPE
)
RETURN NUMBER
IS
-- ���� ����
V_PW2    ADMIN.PW%TYPE;
V_FLAG   NUMBER := 0;
-- ���� ���� ����
USER_LOGIN_ERROR    EXCEPTION;
BEGIN
-- ������ ������ �� ����     
    BEGIN
        SELECT PW INTO V_PW2
        FROM PROFESSORS
        WHERE ID = V_ID;
    EXCEPTION
        WHEN OTHERS THEN RAISE USER_LOGIN_ERROR;  
    END;
    -- �Է��� �н����尡 �������� �н����尡 ������ 1 ��ȯ
    IF(V_PW = V_PW2)
        THEN V_FLAG := 1;
        ELSE V_FLAG := 2;
    END IF;
    
        
    RETURN V_FLAG;
    
    EXCEPTION 
       WHEN USER_LOGIN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20021, '�ش� ���̵� �������� �ʽ��ϴ�.');
            ROLLBACK;
END;


--��. ���� �Է� ��� ���� 
-- �� �� �������� ���� ����  - ������ 
CREATE OR REPLACE PROCEDURE OP_SUBJECTS_RATE_UPDATE
( V_OP_SUB_NUM  IN OP_SUBJECTS.NUM%TYPE
, V_PRE_RATE    IN OP_SUBJECTS.PRE_RATE%TYPE
, V_PRAC_RATE   IN OP_SUBJECTS.PRAC_RATE%TYPE
, V_WRITE_RATE  IN OP_SUBJECTS.WRITE_RATE%TYPE
)
IS
BEGIN

    UPDATE OP_SUBJECTS
    SET PRE_RATE = V_PRE_RATE, PRAC_RATE = V_PRAC_RATE, WRITE_RATE = V_WRITE_RATE
    WHERE NUM = V_OP_SUB_NUM;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20022, '������ �ùٸ��� �Է����ּ���.'); 
                ROLLBACK;
END;


--�� �� ���� ���� ó��(���/�Ǳ�/�ʱ�) ���(�Է� / ����)
-- �Լ�: (�л����̵�, ���������ȣ) -> ������Ϲ�ȣ
CREATE OR REPLACE FUNCTION FN_FIND_SCL_NUM
( V_STD_ID  STUDENTS.ID%TYPE
, V_OPS_NUM OP_SUBJECTS.NUM%TYPE
)
RETURN STUDENT_COURSES_LISTS.NUM%TYPE
IS
    V_SCL_NUM   STUDENT_COURSES_LISTS.NUM%TYPE;
    V_OPC_CODE  OP_COURSES.CODE%TYPE;
BEGIN
    SELECT OP_COURSE_CODE INTO V_OPC_CODE
    FROM OP_SUBJECTS
    WHERE NUM = V_OPS_NUM;

    SELECT NUM INTO V_SCL_NUM
    FROM STUDENT_COURSES_LISTS
    WHERE STUDENT_ID = V_STD_ID
      AND OP_COURSE_CODE = V_OPC_CODE;

    RETURN V_SCL_NUM;
    
     COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN RETURN NULL;
END;

-- ���� �Է�/���� �� ����Ǵ� Ʈ����
CREATE OR REPLACE TRIGGER TRG_SCORES_INSERT_UPDATE
        BEFORE
        INSERT OR UPDATE ON SCORES
        FOR EACH ROW
DECLARE
    V_START_DATE    OP_SUBJECTS.START_DATE%TYPE;
    V_END_DATE      OP_SUBJECTS.END_DATE%TYPE;
    V_COUNT         NUMBER;
BEGIN
    IF (:NEW.PRESENCE < 0 OR :NEW.PRACTICE < 0 OR :NEW.WRITING < 0) THEN 
        RAISE_APPLICATION_ERROR(-20023, '0���� ���� ������ �Է��� �� �����ϴ�.');
        ROLLBACK;
    END IF;
    
    IF(INSERTING) THEN
        SELECT START_DATE, END_DATE INTO V_START_DATE, V_END_DATE
        FROM OP_SUBJECTS
        WHERE NUM = :NEW.OP_SUB_NUM;
        
        IF (V_START_DATE > SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20024, '���������� ���� ���� ������ ������ �Է��� �� �����ϴ�.');
            ROLLBACK;
        END IF;
        
        SELECT COUNT(*) INTO V_COUNT
        FROM NON_PASS
        WHERE SCL_NUM = :NEW.SCL_NUM AND NP_DATE < V_END_DATE;
        
        IF (V_COUNT > 0) THEN
            RAISE_APPLICATION_ERROR(-20025, '�ߵ�Ż���� �л��� ������ �Է��� �� �����ϴ�.');
            ROLLBACK;
        END IF;
        
    END IF;
END;

-- ���� �Է�/���� �� ����ϴ� ���ν���
CREATE OR REPLACE PROCEDURE PRC_SCORES_INSERT_OR_UPDATE
( V_STD_ID      IN STUDENTS.ID%TYPE
, V_OPS_NUM     IN OP_SUBJECTS.NUM%TYPE
, V_PRESENCE    IN SCORES.PRESENCE%TYPE
, V_WRITING     IN SCORES.WRITING%TYPE
, V_PRACTICE    IN SCORES.PRACTICE%TYPE
)
IS
    V_SCL_NUM       STUDENT_COURSES_LISTS.NUM%TYPE;
    V_SCORES_NUM    SCORES.NUM%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN

    V_SCL_NUM := FN_FIND_SCL_NUM(V_STD_ID, V_OPS_NUM);

    IF(V_SCL_NUM IS NULL) THEN
        RAISE USER_DEFINE_ERROR;
    END IF;

    SELECT NUM INTO V_SCORES_NUM
    FROM SCORES
    WHERE SCL_NUM = V_SCL_NUM AND OP_SUB_NUM = V_OPS_NUM;
    
    UPDATE SCORES
    SET PRESENCE = V_PRESENCE, WRITING = v_WRITING, PRACTICE = V_PRACTICE
    WHERE NUM = V_SCORES_NUM;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO SCORES (NUM, SCL_NUM, OP_SUB_NUM, PRESENCE, WRITING, PRACTICE)
        VALUES(SEQ_SCORES.NEXTVAL, V_SCL_NUM, V_OPS_NUM, V_PRESENCE, V_WRITING, V_PRACTICE);
        COMMIT;
    WHEN USER_DEFINE_ERROR THEN RAISE_APPLICATION_ERROR(-20026, '�ش� ������ ���Ե� ������ ������� ���� �л��Դϴ�.');
                           ROLLBACK;
    WHEN OTHERS THEN ROLLBACK;
END;

-- ���� �����ϴ� ���ν���
CREATE OR REPLACE PROCEDURE PRC_SCORES_DELETE
( V_STD_ID      IN STUDENTS.ID%TYPE
, V_OPS_NUM     IN OP_SUBJECTS.NUM%TYPE
)
IS
    V_SCL_NUM       STUDENT_COURSES_LISTS.NUM%TYPE;
    NO_SCL_ERROR    EXCEPTION;
BEGIN
    V_SCL_NUM := FN_FIND_SCL_NUM(V_STD_ID, V_OPS_NUM);

    IF (V_SCL_NUM IS NULL)
        THEN RAISE NO_SCL_ERROR;
    END IF;

    DELETE FROM SCORES
    WHERE SCL_NUM = V_SCL_NUM AND OP_SUB_NUM = V_OPS_NUM;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;


--�� ���� ��� ��� ����

--�� �ڽ��� ������ ������ ���� ���(�����, ����Ⱓ, �����, �л���, �������, �Ǳ�����, �ʱ�����, ����, ���, �ߵ�Ż�� ����) 
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_IN_COURSE
( V_PRO_ID      IN  PROFESSORS.ID%TYPE
, V_OUT         OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN V_OUT FOR
        SELECT T.*, RANK() OVER(PARTITION BY T.SUBJECT_NUM ORDER BY T.TOTAL DESC) "RANK"
        FROM
        (
            SELECT OPS.NUM "SUBJECT_NUM"
                 , SUBJ.NAME "SUBJECT_NAME"
                 , OPS.START_DATE
                 , OPS.END_DATE
                 , B.NAME "BOOK_NAME"
                 , STD.ID "STUDENT_ID"
                 , STD.NAME "STUDENT_NAME"
                 , SC.PRESENCE * OPS.PRE_RATE / 100 "PRESENCE"  -- ���� ������ ����
                 , SC.WRITING * OPS.WRITE_RATE / 100 "WRITING"
                 , SC.PRACTICE * OPS.PRAC_RATE / 100 "PRACTICE"
                 , (SC.PRESENCE * OPS.PRE_RATE + SC.WRITING * OPS.WRITE_RATE + SC.PRACTICE * OPS.PRAC_RATE) / 100 "TOTAL"
                 , NVL2(NP.NUM, 'T', 'F') "NON_PASS"
            FROM SCORES SC
               , STUDENT_COURSES_LISTS SCL
               , STUDENTS STD
               , OP_SUBJECTS OPS
               , BOOKS B
               , PROFESSOR_TEACHABLE_SUBJECTS PTS
               , NON_PASS NP
               , SUBJECTS SUBJ
            WHERE SC.SCL_NUM = SCL.NUM
              AND SCL.STUDENT_ID = STD.ID
              AND OPS.NUM = SC.OP_SUB_NUM
              AND B.NUM = OPS.BOOK_NUM
              AND PTS.CODE = OPS.PTS_CODE
              AND PTS.PRO_ID = V_PRO_ID
              AND NP.SCL_NUM(+) = SCL.NUM
              AND (NP.NP_DATE >= OPS.END_DATE OR NP.NUM IS NULL)
              AND SUBJ.CODE = PTS.SUB_CODE
        ) T;
END;


--[ ������� �䱸�м�(�л�) ]---------------------------------------------------------------------------------------------------

--��. �α��� ��� ����
-- �� �л��α���
CREATE OR REPLACE FUNCTION FN_STU_LOGIN
(V_ID IN STUDENTS.ID%TYPE 
,V_PW IN STUDENTS.PW%TYPE
)
RETURN NUMBER
IS
-- ���� ����
V_COUNT NUMBER;
V_PW2   STUDENTS.PW%TYPE;
V_FLAG  NUMBER := 0;
-- ���� ���� ����
USER_LOGIN_ERROR    EXCEPTION;
BEGIN
     
-- ������ ������ �� ����
    BEGIN
        SELECT PW INTO V_PW2
        FROM STUDENTS
        WHERE ID = V_ID;
    EXCEPTION
        WHEN OTHERS THEN RAISE USER_LOGIN_ERROR;      
    END;
    -- �Է��� �н����尡 �������� �н����尡 ������ 1 ��ȯ
    IF(V_PW = V_PW2)
        THEN V_FLAG := 1;
        ELSE V_FLAG := 2;
    END IF;
    
    -- ������ �� ���� , �ߵ�Ż�� ��ܿ� ������ 3 ��ȯ 
    SELECT COUNT(*) INTO V_COUNT
    FROM NON_PASS T1, STUDENT_COURSES_LISTS T2
    WHERE T1.SCL_NUM = T2.NUM
      AND V_ID = T2.STUDENT_ID;
              
    IF(V_COUNT > 0 )
        THEN V_FLAG := 3;
    END IF;
    
    RETURN V_FLAG;
    
    EXCEPTION 
        WHEN USER_LOGIN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20027, '�ش� ���̵� �������� �ʽ��ϴ�.');
            ROLLBACK;

END;


--��. ���� ��� ��� ����

--�� ���� ���� ���� ����ϴ� ��� (������ :�й�)
CREATE OR REPLACE PROCEDURE PRC_SUBJECTS_OF_STUDENT
( V_STD_ID  IN  STUDENTS.ID%TYPE
, V_OUT     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN V_OUT FOR
        SELECT C.NAME "COURSE_NAME"
             , S.NAME "SUBJECT_NAME"
             , OPS.START_DATE
             , OPS.END_DATE
        FROM STUDENT_COURSES_LISTS SCL
           , OP_COURSES OPC
           , OP_SUBJECTS OPS
           , PROFESSOR_TEACHABLE_SUBJECTS PTS
           , SUBJECTS S
           , COURSES C
           , NON_PASS NP
        WHERE SCL.STUDENT_ID = V_STD_ID
          AND SCL.OP_COURSE_CODE = OPC.CODE
          AND OPC.COURSE_CODE = C.CODE
          AND OPS.OP_COURSE_CODE = OPC.CODE
          AND OPS.PTS_CODE = PTS.CODE
          AND PTS.SUB_CODE = S.CODE
          AND OPS.END_DATE < SYSDATE
          AND NP.SCL_NUM(+) = SCL.NUM
          AND (NP.NUM IS NULL OR OPS.END_DATE < NP.NP_DATE);
END;

--�� ���� ���� �� ���� ���� �� ����Ȯ�� ��� (������, �����, �����Ⱓ, �����, ���, �Ǳ�, �ʱ�, ����, ���)
--    (�Ű����� : �й�, ���������ڵ�)
CREATE OR REPLACE PROCEDURE PRC_SUBJECTS_OF_STUDENT
( V_STD_ID      IN  STUDENTS.ID%TYPE
, V_OPS_NUM     IN  OP_SUBJECTS.NUM%TYPE
, V_OUT         OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN V_OUT FOR
        SELECT T.*
        FROM
        (
            SELECT SCL.STUDENT_ID
                 , C.NAME "COURSE_NAME"
                 , S.NAME "SUBJECT_NAME"
                 , OPS.START_DATE
                 , OPS.END_DATE
                 , B.NAME "BOOK_NAME"
                 , SC.PRESENCE * OPS.PRE_RATE / 100 "PRESENCE"
                 , SC.WRITING * OPS.WRITE_RATE / 100 "WRITING"
                 , SC.PRACTICE * OPS.PRAC_RATE / 100 "PRACTICE"
                 , (SC.PRESENCE * OPS.PRE_RATE + SC.WRITING * OPS.WRITE_RATE + SC.PRACTICE * OPS.PRAC_RATE) / 100 "TOTAL"
                 , RANK() OVER(ORDER BY (SC.PRESENCE * OPS.PRE_RATE + SC.WRITING * OPS.WRITE_RATE + SC.PRACTICE * OPS.PRAC_RATE) / 100 DESC) "RANK"
            FROM STUDENT_COURSES_LISTS SCL
               , OP_COURSES OPC
               , OP_SUBJECTS OPS
               , PROFESSOR_TEACHABLE_SUBJECTS PTS
               , SUBJECTS S
               , COURSES C
               , SCORES SC
               , BOOKS B
            WHERE SC.OP_SUB_NUM = V_OPS_NUM
              AND SC.SCL_NUM = SCL.NUM
              AND SC.OP_SUB_NUM = OPS.NUM
              AND SCL.OP_COURSE_CODE = OPC.CODE
              AND OPC.COURSE_CODE = C.CODE
              AND OPS.OP_COURSE_CODE = OPC.CODE
              AND OPS.PTS_CODE = PTS.CODE
              AND PTS.SUB_CODE = S.CODE
              AND OPS.END_DATE < SYSDATE
              AND B.NUM(+) = OPS.BOOK_NUM
        ) T
        WHERE STUDENT_ID = V_STD_ID;
END;    

-- �� ��� ������ �� ���������� ���(�Ű����� :�й�)
-- (������, �����, �����Ⱓ, �����, ���, �Ǳ�, �ʱ�, ����, ���)
CREATE OR REPLACE PROCEDURE PRC_SUBJECTS_OF_STUDENT_DETAIL
( V_STD_ID  IN  STUDENTS.ID%TYPE
, V_OUT     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN V_OUT FOR
        SELECT *
        FROM
        (
            SELECT T.*, RANK() OVER(PARTITION BY T.SUBJECT_NUM ORDER BY T.TOTAL DESC) "RANK"
            FROM
            (
                SELECT SCL.STUDENT_ID
                     , OPS.NUM "SUBJECT_NUM"
                     , C.NAME "COURSE_NAME"
                     , S.NAME "SUBJECT_NAME"
                     , OPS.START_DATE
                     , OPS.END_DATE
                     , B.NAME "BOOK_NAME"
                     , SC.PRESENCE * OPS.PRE_RATE / 100 "PRESENCE"
                     , SC.WRITING * OPS.WRITE_RATE / 100 "WRITING"
                     , SC.PRACTICE * OPS.PRAC_RATE / 100 "PRACTICE"
                     , (SC.PRESENCE * OPS.PRE_RATE + SC.WRITING * OPS.WRITE_RATE + SC.PRACTICE * OPS.PRAC_RATE) / 100 "TOTAL"
                FROM STUDENT_COURSES_LISTS SCL
                   , OP_COURSES OPC
                   , OP_SUBJECTS OPS
                   , PROFESSOR_TEACHABLE_SUBJECTS PTS
                   , SUBJECTS S
                   , COURSES C
                   , BOOKS B
                   , SCORES SC
                WHERE SCL.OP_COURSE_CODE = OPC.CODE
                  AND OPC.COURSE_CODE = C.CODE
                  AND OPS.OP_COURSE_CODE = OPC.CODE
                  AND OPS.PTS_CODE = PTS.CODE
                  AND PTS.SUB_CODE = S.CODE
                  AND OPS.END_DATE < SYSDATE
                  AND OPS.BOOK_NUM = B.NUM
                  AND SC.OP_SUB_NUM = OPS.NUM
                  AND SC.SCL_NUM = SCL.NUM
            ) T
        )
        WHERE STUDENT_ID = V_STD_ID;
END;
