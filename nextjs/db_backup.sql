PGDMP                      |            software_engineering_db    16.0    16.0 0                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            !           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            "           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            #           1262    106920    software_engineering_db    DATABASE     �   CREATE DATABASE software_engineering_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
 '   DROP DATABASE software_engineering_db;
                postgres    false                        2615    106925    course_management    SCHEMA     !   CREATE SCHEMA course_management;
    DROP SCHEMA course_management;
                postgres    false                        2615    106926    finance    SCHEMA        CREATE SCHEMA finance;
    DROP SCHEMA finance;
                postgres    false                        2615    106924    student_info    SCHEMA        CREATE SCHEMA student_info;
    DROP SCHEMA student_info;
                postgres    false            �            1255    107113    select_all_students()    FUNCTION     �  CREATE FUNCTION student_info.select_all_students() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj TEXT DEFAULT '';
BEGIN
      json_result_obj= json_build_object('success',true,'data',array_to_json(array_agg(row_to_json(t))))
 from (SELECT * FROM student_info.students) t;
IF  json_result_obj IS NULL THEN
     json_result_obj = json_build_object('success',false,'msg','Error Loading Data');
END IF;
  RETURN json_result_obj;
END;
$$;
 2   DROP FUNCTION student_info.select_all_students();
       student_info          postgres    false    6            �            1259    107045    course_enrollment    TABLE     �   CREATE TABLE course_management.course_enrollment (
    enrollment_id integer NOT NULL,
    student_id integer NOT NULL,
    course_code character varying(20) NOT NULL,
    reg_date date DEFAULT CURRENT_DATE
);
 0   DROP TABLE course_management.course_enrollment;
       course_management         heap    postgres    false    7            �            1259    107044 #   course_enrollment_enrollment_id_seq    SEQUENCE     �   CREATE SEQUENCE course_management.course_enrollment_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE course_management.course_enrollment_enrollment_id_seq;
       course_management          postgres    false    223    7            $           0    0 #   course_enrollment_enrollment_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE course_management.course_enrollment_enrollment_id_seq OWNED BY course_management.course_enrollment.enrollment_id;
          course_management          postgres    false    222            �            1259    107039    courses    TABLE     �   CREATE TABLE course_management.courses (
    course_code character varying(20) NOT NULL,
    course_name character varying(100) NOT NULL,
    credits integer NOT NULL,
    level integer,
    course_info text,
    lecturer text,
    ta text
);
 &   DROP TABLE course_management.courses;
       course_management         heap    postgres    false    7            �            1259    107062 	   lecturers    TABLE     �   CREATE TABLE course_management.lecturers (
    lecturer_id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL
);
 (   DROP TABLE course_management.lecturers;
       course_management         heap    postgres    false    7            �            1259    107061    lecturers_lecturer_id_seq    SEQUENCE     �   CREATE SEQUENCE course_management.lecturers_lecturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE course_management.lecturers_lecturer_id_seq;
       course_management          postgres    false    7    225            %           0    0    lecturers_lecturer_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE course_management.lecturers_lecturer_id_seq OWNED BY course_management.lecturers.lecturer_id;
          course_management          postgres    false    224            �            1259    107088    teaching_assistants    TABLE     �   CREATE TABLE course_management.teaching_assistants (
    ta_id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL
);
 2   DROP TABLE course_management.teaching_assistants;
       course_management         heap    postgres    false    7            �            1259    107087    teaching_assistants_ta_id_seq    SEQUENCE     �   CREATE SEQUENCE course_management.teaching_assistants_ta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE course_management.teaching_assistants_ta_id_seq;
       course_management          postgres    false    7    227            &           0    0    teaching_assistants_ta_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE course_management.teaching_assistants_ta_id_seq OWNED BY course_management.teaching_assistants.ta_id;
          course_management          postgres    false    226            �            1259    107028    student_fees    TABLE     �   CREATE TABLE finance.student_fees (
    payment_id integer NOT NULL,
    student_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date date NOT NULL
);
 !   DROP TABLE finance.student_fees;
       finance         heap    postgres    false    8            �            1259    107027    student_fees_payment_id_seq    SEQUENCE     �   CREATE SEQUENCE finance.student_fees_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE finance.student_fees_payment_id_seq;
       finance          postgres    false    220    8            '           0    0    student_fees_payment_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE finance.student_fees_payment_id_seq OWNED BY finance.student_fees.payment_id;
          finance          postgres    false    219            �            1259    107020    students    TABLE       CREATE TABLE student_info.students (
    student_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    level integer NOT NULL,
    password character varying(255) NOT NULL
);
 "   DROP TABLE student_info.students;
       student_info         heap    postgres    false    6            l           2604    107048    course_enrollment enrollment_id    DEFAULT     �   ALTER TABLE ONLY course_management.course_enrollment ALTER COLUMN enrollment_id SET DEFAULT nextval('course_management.course_enrollment_enrollment_id_seq'::regclass);
 Y   ALTER TABLE course_management.course_enrollment ALTER COLUMN enrollment_id DROP DEFAULT;
       course_management          postgres    false    222    223    223            n           2604    107065    lecturers lecturer_id    DEFAULT     �   ALTER TABLE ONLY course_management.lecturers ALTER COLUMN lecturer_id SET DEFAULT nextval('course_management.lecturers_lecturer_id_seq'::regclass);
 O   ALTER TABLE course_management.lecturers ALTER COLUMN lecturer_id DROP DEFAULT;
       course_management          postgres    false    224    225    225            o           2604    107091    teaching_assistants ta_id    DEFAULT     �   ALTER TABLE ONLY course_management.teaching_assistants ALTER COLUMN ta_id SET DEFAULT nextval('course_management.teaching_assistants_ta_id_seq'::regclass);
 S   ALTER TABLE course_management.teaching_assistants ALTER COLUMN ta_id DROP DEFAULT;
       course_management          postgres    false    227    226    227            k           2604    107031    student_fees payment_id    DEFAULT     �   ALTER TABLE ONLY finance.student_fees ALTER COLUMN payment_id SET DEFAULT nextval('finance.student_fees_payment_id_seq'::regclass);
 G   ALTER TABLE finance.student_fees ALTER COLUMN payment_id DROP DEFAULT;
       finance          postgres    false    220    219    220                      0    107045    course_enrollment 
   TABLE DATA           h   COPY course_management.course_enrollment (enrollment_id, student_id, course_code, reg_date) FROM stdin;
    course_management          postgres    false    223   �>                 0    107039    courses 
   TABLE DATA           q   COPY course_management.courses (course_code, course_name, credits, level, course_info, lecturer, ta) FROM stdin;
    course_management          postgres    false    221   ?                 0    107062 	   lecturers 
   TABLE DATA           H   COPY course_management.lecturers (lecturer_id, name, email) FROM stdin;
    course_management          postgres    false    225   �B                 0    107088    teaching_assistants 
   TABLE DATA           L   COPY course_management.teaching_assistants (ta_id, name, email) FROM stdin;
    course_management          postgres    false    227   C                 0    107028    student_fees 
   TABLE DATA           U   COPY finance.student_fees (payment_id, student_id, amount, payment_date) FROM stdin;
    finance          postgres    false    220   VC                 0    107020    students 
   TABLE DATA           c   COPY student_info.students (student_id, first_name, last_name, email, level, password) FROM stdin;
    student_info          postgres    false    218   sC       (           0    0 #   course_enrollment_enrollment_id_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('course_management.course_enrollment_enrollment_id_seq', 1, false);
          course_management          postgres    false    222            )           0    0    lecturers_lecturer_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('course_management.lecturers_lecturer_id_seq', 4, true);
          course_management          postgres    false    224            *           0    0    teaching_assistants_ta_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('course_management.teaching_assistants_ta_id_seq', 3, true);
          course_management          postgres    false    226            +           0    0    student_fees_payment_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('finance.student_fees_payment_id_seq', 1, false);
          finance          postgres    false    219            y           2606    107050 (   course_enrollment course_enrollment_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_pkey PRIMARY KEY (enrollment_id);
 ]   ALTER TABLE ONLY course_management.course_enrollment DROP CONSTRAINT course_enrollment_pkey;
       course_management            postgres    false    223            w           2606    107043    courses courses_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY course_management.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_code);
 I   ALTER TABLE ONLY course_management.courses DROP CONSTRAINT courses_pkey;
       course_management            postgres    false    221            {           2606    107069    lecturers lecturers_email_key 
   CONSTRAINT     d   ALTER TABLE ONLY course_management.lecturers
    ADD CONSTRAINT lecturers_email_key UNIQUE (email);
 R   ALTER TABLE ONLY course_management.lecturers DROP CONSTRAINT lecturers_email_key;
       course_management            postgres    false    225            }           2606    107067    lecturers lecturers_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY course_management.lecturers
    ADD CONSTRAINT lecturers_pkey PRIMARY KEY (lecturer_id);
 M   ALTER TABLE ONLY course_management.lecturers DROP CONSTRAINT lecturers_pkey;
       course_management            postgres    false    225                       2606    107095 1   teaching_assistants teaching_assistants_email_key 
   CONSTRAINT     x   ALTER TABLE ONLY course_management.teaching_assistants
    ADD CONSTRAINT teaching_assistants_email_key UNIQUE (email);
 f   ALTER TABLE ONLY course_management.teaching_assistants DROP CONSTRAINT teaching_assistants_email_key;
       course_management            postgres    false    227            �           2606    107093 ,   teaching_assistants teaching_assistants_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY course_management.teaching_assistants
    ADD CONSTRAINT teaching_assistants_pkey PRIMARY KEY (ta_id);
 a   ALTER TABLE ONLY course_management.teaching_assistants DROP CONSTRAINT teaching_assistants_pkey;
       course_management            postgres    false    227            u           2606    107033    student_fees student_fees_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY finance.student_fees
    ADD CONSTRAINT student_fees_pkey PRIMARY KEY (payment_id);
 I   ALTER TABLE ONLY finance.student_fees DROP CONSTRAINT student_fees_pkey;
       finance            postgres    false    220            q           2606    107026    students students_email_key 
   CONSTRAINT     ]   ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_email_key UNIQUE (email);
 K   ALTER TABLE ONLY student_info.students DROP CONSTRAINT students_email_key;
       student_info            postgres    false    218            s           2606    107024    students students_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);
 F   ALTER TABLE ONLY student_info.students DROP CONSTRAINT students_pkey;
       student_info            postgres    false    218            �           2606    107056 4   course_enrollment course_enrollment_course_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_course_code_fkey FOREIGN KEY (course_code) REFERENCES course_management.courses(course_code);
 i   ALTER TABLE ONLY course_management.course_enrollment DROP CONSTRAINT course_enrollment_course_code_fkey;
       course_management          postgres    false    4727    221    223            �           2606    107051 3   course_enrollment course_enrollment_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);
 h   ALTER TABLE ONLY course_management.course_enrollment DROP CONSTRAINT course_enrollment_student_id_fkey;
       course_management          postgres    false    218    223    4723            �           2606    107034 )   student_fees student_fees_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY finance.student_fees
    ADD CONSTRAINT student_fees_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);
 T   ALTER TABLE ONLY finance.student_fees DROP CONSTRAINT student_fees_student_id_fkey;
       finance          postgres    false    218    220    4723                  x^����� � �         �  x^�UMs7=�~����㺝|se�ɤI3u��^(.�Ř�+�n�=����ܵd[n.Ғ���p���#]�_4�*+��q�y�&��]�m��{�\4���[N9�}9;wl(l����W;������'�0f��3��g���t���l���Td��w��9��9x��(JKWZ��p�a�>�ƍ�kw�J/���v��r�ge���f���4z�	7�t�;���,W�M��~U�>G�H��u<�jk��t��ې��bU��Kc�i�Q��������XWc�ۨ|�M�����%�VJ�JU���VB\q�f���=s^kՐ��[�4�pBZN�=��}��$#�
*=}��B�m��yZ��w�����x��m�V,��� ���o�X���x"�AEe��ů߯#wR���$;X��I9ķ�Q��ݷ��&ª������dɲ3���V����)�2lilF��dŸ+���&����y��q�8~�:u��\���'{H�R2��1�A�zR*���ڹ t��4oFYP������"�A�1���Px.���8������[�l$�7�� �H�J�-�G��t��}_;�T�=Zҡ\�I:�P��<I:U+�e4-)�Nc4lÅ�iK�u
b�w����aǅ5cJ�
�*�~�7����J�,G�%g:V-evUl�h0�����k�>p��v�Y�􁓡�B��^y?���=u�N�at�J0�qU��R��Ô�w7��o6x>3P�|k�6?������1A��JB?�u5�7���V�����6�e��2���2(��̹��G��N��}a���);b���¿�]VaZ���)y��f���g�Z�	,©p���ċ�����G��3cZ�}�X,�+`�}         Q   x^3�t)�S�MLO-J-��MLwH�M���K���2��e��s�H$9c��gqbb2gfv*��	Xƻ�$��3��I&F��� �{#n         A   x^3��H�NM���H�vH�M����K���2�t�/.I-�LS`)��1gpbnj
gqb.�h� ��            x^����� � �         I   x^34425�05���/�(M��+�.��Y@����Cznbf�^r~.�����bne���iV�����+W� �@T     