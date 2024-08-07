toc.dat                                                                                             0000600 0004000 0002000 00000051261 14650423477 0014460 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   2        
            |            software_engineering_db    16.0    16.0 5    &           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         '           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         (           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         )           1262    106920    software_engineering_db    DATABASE     �   CREATE DATABASE software_engineering_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
 '   DROP DATABASE software_engineering_db;
                postgres    false                     2615    106925    course_management    SCHEMA     !   CREATE SCHEMA course_management;
    DROP SCHEMA course_management;
                postgres    false                     2615    106926    finance    SCHEMA        CREATE SCHEMA finance;
    DROP SCHEMA finance;
                postgres    false                     2615    106924    student_info    SCHEMA        CREATE SCHEMA student_info;
    DROP SCHEMA student_info;
                postgres    false         �            1255    115485    add_new_course(text)    FUNCTION     g  CREATE FUNCTION course_management.add_new_course(json_request text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
   vr_student_id int;
    vr_course_code VARCHAR;
	vr_img text;
	json_result_obj json;
    
   
BEGIN
   vr_course_code := json_request::json->>'course_code';
    vr_student_id := json_request::json->>'student_id';
	vr_img := json_request::json->>'img';


    INSERT INTO course_management.course_enrollment (student_id,course_code,img)
    VALUES (vr_student_id, vr_course_code,vr_img)
    RETURNING row_to_json(course_enrollment.*) INTO json_result_obj;

    RETURN json_result_obj;
END;
$$;
 C   DROP FUNCTION course_management.add_new_course(json_request text);
       course_management          postgres    false    7         �            1255    115484    select_all_courses()    FUNCTION     �  CREATE FUNCTION course_management.select_all_courses() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj TEXT DEFAULT '';
BEGIN
      json_result_obj= json_build_object('success',true,'data',array_to_json(array_agg(row_to_json(t))))
 from (SELECT * FROM course_management.courses) t;
IF  json_result_obj IS NULL THEN
     json_result_obj = json_build_object('success',false,'msg','Error Loading Data');
END IF;
  RETURN json_result_obj;
END;
$$;
 6   DROP FUNCTION course_management.select_all_courses();
       course_management          postgres    false    7         �            1255    115486 &   select_all_courses_and_registrations()    FUNCTION     }  CREATE FUNCTION course_management.select_all_courses_and_registrations() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj TEXT DEFAULT '';
    courses_json json;
    registrations_json json;
BEGIN
    -- Select courses
    SELECT array_to_json(array_agg(row_to_json(c)))
    INTO courses_json
    FROM (SELECT * FROM course_management.courses) c;

    -- Select registrations
    SELECT array_to_json(array_agg(row_to_json(r)))
    INTO registrations_json
    FROM (SELECT * FROM course_management.course_enrollment) r;

    -- Build the result JSON
    json_result_obj = json_build_object(
        'success', true,
        'data', json_build_array(courses_json, registrations_json)
    );

    IF json_result_obj IS NULL THEN
        json_result_obj = json_build_object('success', false, 'msg', 'Error Loading Data');
    END IF;

    RETURN json_result_obj;
END;
$$;
 H   DROP FUNCTION course_management.select_all_courses_and_registrations();
       course_management          postgres    false    7         �            1255    123692    get_outstanding_fees()    FUNCTION     V  CREATE FUNCTION finance.get_outstanding_fees() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result json;
BEGIN
    SELECT json_agg(row_to_json(t))
    INTO result
    FROM (
        SELECT
            s.student_id,
            COALESCE(SUM(5000.00) - COALESCE(SUM(f.amount), 0.00), 0.00)::NUMERIC(10,2) AS outstanding_fees
        FROM student_info.students s
        LEFT JOIN course_management.course_enrollment c ON s.student_id = c.student_id
        LEFT JOIN finance.student_fees f ON s.student_id = f.student_id
        GROUP BY s.student_id
    ) t;

    RETURN result;
END;
$$;
 .   DROP FUNCTION finance.get_outstanding_fees();
       finance          postgres    false    8         �            1255    115483    add_new_student(text)    FUNCTION     ~  CREATE FUNCTION student_info.add_new_student(json_request text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj json;
    vr_student_id int;
    vr_first_name varchar;
    vr_last_name varchar;
    vr_email varchar;
    vr_level int;
    vr_password varchar;
    vr_random_fee numeric(10,2);
BEGIN
    vr_student_id := (json_request::json->>'student_id')::int;
    vr_first_name := json_request::json->>'first_name';
    vr_last_name := json_request::json->>'last_name';
    vr_email := json_request::json->>'email';
    vr_level := (json_request::json->>'level')::int;
    vr_password := json_request::json->>'password';

    -- Insert new student
    INSERT INTO student_info.students (student_id, first_name, last_name, email, "level", "password")
    VALUES (vr_student_id, vr_first_name, vr_last_name, vr_email, vr_level, vr_password)
    RETURNING row_to_json(students.*) INTO json_result_obj;

    -- Generate random fee between 1000 and 5000
    vr_random_fee := (random() * 4000 + 1000)::numeric(10,2);

    -- Insert random fee into student_fees table
    INSERT INTO finance.student_fees (student_id, amount)
    VALUES (vr_student_id, vr_random_fee);

    -- Add fee information to the result JSON
    json_result_obj := jsonb_set(
        json_result_obj::jsonb, 
        '{assigned_fee}', 
        to_jsonb(vr_random_fee)
    );

    RETURN json_result_obj;
END;
$$;
 ?   DROP FUNCTION student_info.add_new_student(json_request text);
       student_info          postgres    false    6         �            1255    107113    select_all_students()    FUNCTION     �  CREATE FUNCTION student_info.select_all_students() RETURNS text
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
       student_info          postgres    false    6         �            1259    107045    course_enrollment    TABLE       CREATE TABLE course_management.course_enrollment (
    enrollment_id integer NOT NULL,
    student_id integer NOT NULL,
    course_code character varying(20) NOT NULL,
    reg_date timestamp with time zone DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'::text),
    img text
);
 0   DROP TABLE course_management.course_enrollment;
       course_management         heap    postgres    false    7         �            1259    107044 #   course_enrollment_enrollment_id_seq    SEQUENCE     �   CREATE SEQUENCE course_management.course_enrollment_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE course_management.course_enrollment_enrollment_id_seq;
       course_management          postgres    false    7    223         *           0    0 #   course_enrollment_enrollment_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE course_management.course_enrollment_enrollment_id_seq OWNED BY course_management.course_enrollment.enrollment_id;
          course_management          postgres    false    222         �            1259    107039    courses    TABLE     �   CREATE TABLE course_management.courses (
    course_code character varying(20) NOT NULL,
    course_name character varying(100) NOT NULL,
    credits integer NOT NULL,
    level integer,
    course_info text,
    lecturer text,
    ta text
);
 &   DROP TABLE course_management.courses;
       course_management         heap    postgres    false    7         �            1259    107062 	   lecturers    TABLE     �   CREATE TABLE course_management.lecturers (
    lecturer_id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL
);
 (   DROP TABLE course_management.lecturers;
       course_management         heap    postgres    false    7         �            1259    107061    lecturers_lecturer_id_seq    SEQUENCE     �   CREATE SEQUENCE course_management.lecturers_lecturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE course_management.lecturers_lecturer_id_seq;
       course_management          postgres    false    7    225         +           0    0    lecturers_lecturer_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE course_management.lecturers_lecturer_id_seq OWNED BY course_management.lecturers.lecturer_id;
          course_management          postgres    false    224         �            1259    107088    teaching_assistants    TABLE     �   CREATE TABLE course_management.teaching_assistants (
    ta_id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL
);
 2   DROP TABLE course_management.teaching_assistants;
       course_management         heap    postgres    false    7         �            1259    107087    teaching_assistants_ta_id_seq    SEQUENCE     �   CREATE SEQUENCE course_management.teaching_assistants_ta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE course_management.teaching_assistants_ta_id_seq;
       course_management          postgres    false    7    227         ,           0    0    teaching_assistants_ta_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE course_management.teaching_assistants_ta_id_seq OWNED BY course_management.teaching_assistants.ta_id;
          course_management          postgres    false    226         �            1259    107028    student_fees    TABLE     �   CREATE TABLE finance.student_fees (
    payment_id integer NOT NULL,
    student_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 !   DROP TABLE finance.student_fees;
       finance         heap    postgres    false    8         �            1259    107027    student_fees_payment_id_seq    SEQUENCE     �   CREATE SEQUENCE finance.student_fees_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE finance.student_fees_payment_id_seq;
       finance          postgres    false    8    220         -           0    0    student_fees_payment_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE finance.student_fees_payment_id_seq OWNED BY finance.student_fees.payment_id;
          finance          postgres    false    219         �            1259    107020    students    TABLE       CREATE TABLE student_info.students (
    student_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    level integer NOT NULL,
    password character varying(255) NOT NULL
);
 "   DROP TABLE student_info.students;
       student_info         heap    postgres    false    6         r           2604    107048    course_enrollment enrollment_id    DEFAULT     �   ALTER TABLE ONLY course_management.course_enrollment ALTER COLUMN enrollment_id SET DEFAULT nextval('course_management.course_enrollment_enrollment_id_seq'::regclass);
 Y   ALTER TABLE course_management.course_enrollment ALTER COLUMN enrollment_id DROP DEFAULT;
       course_management          postgres    false    222    223    223         t           2604    107065    lecturers lecturer_id    DEFAULT     �   ALTER TABLE ONLY course_management.lecturers ALTER COLUMN lecturer_id SET DEFAULT nextval('course_management.lecturers_lecturer_id_seq'::regclass);
 O   ALTER TABLE course_management.lecturers ALTER COLUMN lecturer_id DROP DEFAULT;
       course_management          postgres    false    225    224    225         u           2604    107091    teaching_assistants ta_id    DEFAULT     �   ALTER TABLE ONLY course_management.teaching_assistants ALTER COLUMN ta_id SET DEFAULT nextval('course_management.teaching_assistants_ta_id_seq'::regclass);
 S   ALTER TABLE course_management.teaching_assistants ALTER COLUMN ta_id DROP DEFAULT;
       course_management          postgres    false    227    226    227         p           2604    107031    student_fees payment_id    DEFAULT     �   ALTER TABLE ONLY finance.student_fees ALTER COLUMN payment_id SET DEFAULT nextval('finance.student_fees_payment_id_seq'::regclass);
 G   ALTER TABLE finance.student_fees ALTER COLUMN payment_id DROP DEFAULT;
       finance          postgres    false    219    220    220                   0    107045    course_enrollment 
   TABLE DATA           m   COPY course_management.course_enrollment (enrollment_id, student_id, course_code, reg_date, img) FROM stdin;
    course_management          postgres    false    223       4895.dat           0    107039    courses 
   TABLE DATA           q   COPY course_management.courses (course_code, course_name, credits, level, course_info, lecturer, ta) FROM stdin;
    course_management          postgres    false    221       4893.dat !          0    107062 	   lecturers 
   TABLE DATA           H   COPY course_management.lecturers (lecturer_id, name, email) FROM stdin;
    course_management          postgres    false    225       4897.dat #          0    107088    teaching_assistants 
   TABLE DATA           L   COPY course_management.teaching_assistants (ta_id, name, email) FROM stdin;
    course_management          postgres    false    227       4899.dat           0    107028    student_fees 
   TABLE DATA           U   COPY finance.student_fees (payment_id, student_id, amount, payment_date) FROM stdin;
    finance          postgres    false    220       4892.dat           0    107020    students 
   TABLE DATA           c   COPY student_info.students (student_id, first_name, last_name, email, level, password) FROM stdin;
    student_info          postgres    false    218       4890.dat .           0    0 #   course_enrollment_enrollment_id_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('course_management.course_enrollment_enrollment_id_seq', 52, true);
          course_management          postgres    false    222         /           0    0    lecturers_lecturer_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('course_management.lecturers_lecturer_id_seq', 4, true);
          course_management          postgres    false    224         0           0    0    teaching_assistants_ta_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('course_management.teaching_assistants_ta_id_seq', 3, true);
          course_management          postgres    false    226         1           0    0    student_fees_payment_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('finance.student_fees_payment_id_seq', 8, true);
          finance          postgres    false    219                    2606    107050 (   course_enrollment course_enrollment_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_pkey PRIMARY KEY (enrollment_id);
 ]   ALTER TABLE ONLY course_management.course_enrollment DROP CONSTRAINT course_enrollment_pkey;
       course_management            postgres    false    223         }           2606    107043    courses courses_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY course_management.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_code);
 I   ALTER TABLE ONLY course_management.courses DROP CONSTRAINT courses_pkey;
       course_management            postgres    false    221         �           2606    107069    lecturers lecturers_email_key 
   CONSTRAINT     d   ALTER TABLE ONLY course_management.lecturers
    ADD CONSTRAINT lecturers_email_key UNIQUE (email);
 R   ALTER TABLE ONLY course_management.lecturers DROP CONSTRAINT lecturers_email_key;
       course_management            postgres    false    225         �           2606    107067    lecturers lecturers_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY course_management.lecturers
    ADD CONSTRAINT lecturers_pkey PRIMARY KEY (lecturer_id);
 M   ALTER TABLE ONLY course_management.lecturers DROP CONSTRAINT lecturers_pkey;
       course_management            postgres    false    225         �           2606    107095 1   teaching_assistants teaching_assistants_email_key 
   CONSTRAINT     x   ALTER TABLE ONLY course_management.teaching_assistants
    ADD CONSTRAINT teaching_assistants_email_key UNIQUE (email);
 f   ALTER TABLE ONLY course_management.teaching_assistants DROP CONSTRAINT teaching_assistants_email_key;
       course_management            postgres    false    227         �           2606    107093 ,   teaching_assistants teaching_assistants_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY course_management.teaching_assistants
    ADD CONSTRAINT teaching_assistants_pkey PRIMARY KEY (ta_id);
 a   ALTER TABLE ONLY course_management.teaching_assistants DROP CONSTRAINT teaching_assistants_pkey;
       course_management            postgres    false    227         {           2606    107033    student_fees student_fees_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY finance.student_fees
    ADD CONSTRAINT student_fees_pkey PRIMARY KEY (payment_id);
 I   ALTER TABLE ONLY finance.student_fees DROP CONSTRAINT student_fees_pkey;
       finance            postgres    false    220         w           2606    107026    students students_email_key 
   CONSTRAINT     ]   ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_email_key UNIQUE (email);
 K   ALTER TABLE ONLY student_info.students DROP CONSTRAINT students_email_key;
       student_info            postgres    false    218         y           2606    107024    students students_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);
 F   ALTER TABLE ONLY student_info.students DROP CONSTRAINT students_pkey;
       student_info            postgres    false    218         �           2606    107056 4   course_enrollment course_enrollment_course_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_course_code_fkey FOREIGN KEY (course_code) REFERENCES course_management.courses(course_code);
 i   ALTER TABLE ONLY course_management.course_enrollment DROP CONSTRAINT course_enrollment_course_code_fkey;
       course_management          postgres    false    221    4733    223         �           2606    107051 3   course_enrollment course_enrollment_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);
 h   ALTER TABLE ONLY course_management.course_enrollment DROP CONSTRAINT course_enrollment_student_id_fkey;
       course_management          postgres    false    4729    218    223         �           2606    107034 )   student_fees student_fees_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY finance.student_fees
    ADD CONSTRAINT student_fees_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);
 T   ALTER TABLE ONLY finance.student_fees DROP CONSTRAINT student_fees_student_id_fkey;
       finance          postgres    false    218    220    4729                                                                                                                                                                                                                                                                                                                                                       4895.dat                                                                                            0000600 0004000 0002000 00000005511 14650423477 0014301 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        39	11023595	CPEN 204	2024-07-25 08:24:47.625951+00	https://pixabay.com/get/gfe2c89e910c07e67691cda94396bfbe4e274e1d7d9538909910b4a5ab2a822af74a9d461c3f1220cdaa936e5d51bfa571b1bc125c200bb873293f01ec9576370_640.jpg
40	11023595	CPEN 208	2024-07-25 08:24:47.687524+00	https://pixabay.com/get/g3576524b1bf3f31da89712eb8fe2cbe172929f353ab047c17f2b527bc0aaa55d48698e7e24d26195ec3143cbc13e2edd24f3b5e9aec9bdf8e8a03d3089e80238_640.jpg
41	11023595	CPEN 206	2024-07-25 08:24:48.265146+00	https://pixabay.com/get/gd6d549abe94724029f83177ad69a272f0a8cc88d50194a4be4004127eea43fb39140d9fd0cf87bca6eec70ecacec47fdb54276c3ce0be24418c73e4693ddc6f7_640.jpg
43	11252857	CPEN 204	2024-07-25 08:33:19.691275+00	https://pixabay.com/get/gfe2c89e910c07e67691cda94396bfbe4e274e1d7d9538909910b4a5ab2a822af74a9d461c3f1220cdaa936e5d51bfa571b1bc125c200bb873293f01ec9576370_640.jpg
42	11252857	CPEN 206	2024-07-25 08:33:19.594024+00	https://pixabay.com/get/gd6d549abe94724029f83177ad69a272f0a8cc88d50194a4be4004127eea43fb39140d9fd0cf87bca6eec70ecacec47fdb54276c3ce0be24418c73e4693ddc6f7_640.jpg
44	11252857	CPEN 208	2024-07-25 08:33:19.868484+00	https://pixabay.com/get/g3576524b1bf3f31da89712eb8fe2cbe172929f353ab047c17f2b527bc0aaa55d48698e7e24d26195ec3143cbc13e2edd24f3b5e9aec9bdf8e8a03d3089e80238_640.jpg
45	11012343	CPEN 204	2024-07-25 08:38:13.352194+00	https://pixabay.com/get/gfe2c89e910c07e67691cda94396bfbe4e274e1d7d9538909910b4a5ab2a822af74a9d461c3f1220cdaa936e5d51bfa571b1bc125c200bb873293f01ec9576370_640.jpg
46	11012343	CPEN 206	2024-07-25 08:38:13.396017+00	https://pixabay.com/get/gd6d549abe94724029f83177ad69a272f0a8cc88d50194a4be4004127eea43fb39140d9fd0cf87bca6eec70ecacec47fdb54276c3ce0be24418c73e4693ddc6f7_640.jpg
47	11012343	CPEN 202	2024-07-25 08:38:14.350553+00	https://pixabay.com/get/gcee842dc171e9f0966ff044caa096e3a341f2be3d4a94f040dac474716fe41d8df8672ad3bcb088e69a2942ed5f74f16_640.jpg
48	11012343	CBAS 210	2024-07-25 08:38:14.677066+00	https://pixabay.com/get/gc2f507466b513d65e0fbe103fcd88a3b43ac341d8b1da9cd24ce3011f1107764c3cb75c79c6122400d666efe40b0fdd9_640.jpg
49	11012343	CPEN 212	2024-07-25 08:38:14.9115+00	https://pixabay.com/get/gad4a0e72730b20e4b9ca5afad2a25ff1d3e77f605013857d06d5fb8ddac4d87b31384fbe6ea46ca72205749b98f1cb1565b271c4fab244b8e898c5945b296a9d_640.jpg
50	11012343	SENG 202	2024-07-25 08:38:16.021304+00	https://pixabay.com/get/gb65e183830565d82e37203da4918fcd5d0d39c0f1fa1e5531af10f52a9901eacf95f4f2e27edd9c9490c23cbe03a84ee74ee41d03f73cef8fd923e0773685a27_640.jpg
51	11252857	CPEN 212	2024-07-25 09:20:12.864627+00	https://pixabay.com/get/gad4a0e72730b20e4b9ca5afad2a25ff1d3e77f605013857d06d5fb8ddac4d87b31384fbe6ea46ca72205749b98f1cb1565b271c4fab244b8e898c5945b296a9d_640.jpg
52	11252857	CBAS 210	2024-07-25 09:20:12.901514+00	https://pixabay.com/get/gc2f507466b513d65e0fbe103fcd88a3b43ac341d8b1da9cd24ce3011f1107764c3cb75c79c6122400d666efe40b0fdd9_640.jpg
\.


                                                                                                                                                                                       4893.dat                                                                                            0000600 0004000 0002000 00000005664 14650423477 0014310 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CPEN 204	Data Structures and Algorithm	2	200	History and overview of data structures and algorithms, role of algorithms in computing. Pointers and Structures: Pointer Data Types and Pointer Variables, Introduction to Structures, Accessing Structure Members, Pointers and Structures as Structure Members. Fundamental concepts: Recursion, Divide-and-Conquer , Backtracking.	Dr. Mageret Ansah	Foster
CPEN 206	Linear Circuits	3	200	History and overview of linear circuits, reasons for studying linear circuits, areas of applications, relevance of linear circuits to computer engineering. Circuit components – resistance, reactance, inductance, capacitance, active and reactive elements, resistance and impedance. Circuit configurations: series, parallel and hybrid configuration of circuits and applications. Circuit laws: Ohm’s law, Kirchhoff law, dependent and independent sources, voltage and current divider circuits.	Dr. Godgrey Mills	Hakeem
CPEN 212	Data Communications	2	200	History and overview of information transmission, reasons for studying data transmission, modern trends in telecommunication technology for data transmission, role of information transmission in computer engineering. Fundamental principles: telecommunication signals and their representation, building blocks of a telecommunication systems, description of communication systems types - optical fiber system, microwave system, satellite system, mobile communication system, basic concepts of signal transmission in transmission media, time and frequency signal bandwidth, signal-to-noise ratio, channel and channel capacity, sampling theorem.	Dr. Isaac Aboagye	Samed
SENG 202	Differential Equations	4	200	The course covers differential equations (first and second order ordinary differential equations, series solutions, and system of ordinary differential equations), Initial-value problems (Laplace transforms, partial differential equations, boundary-value problems, Fourier series and transforms), and applications.	Dr. John Kutor	Thaddeus
CPEN 202	Computer Systems Design	3	200	Software engineering is the branch of computer science that deals with the design, development, testing, and maintenance of software applications. Software engineers apply engineering principles and knowledge of programming languages to build software solutions for end users.	Dr. Agyare Debrah	Bamzy
CBAS 210	Academic Writing 2	3	200	Academic writing aims to convey information in an impartial way. The goal is to base arguments on the evidence under consideration, not the authors preconceptions. All claims should be supported with relevant evidence, not just asserted.	Dr. Percy Okae	
CPEN 208	Software Engineering	3	200	Software engineering is the branch of computer science that deals with the design, development, testing, and maintenance of software applications. Software engineers apply engineering principles and knowledge of programming languages to build software solutions for end users.	Mr. John Assiamah	Foster
\.


                                                                            4897.dat                                                                                            0000600 0004000 0002000 00000000161 14650423477 0014277 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Dr. Mageret	mag@gmail.com
2	Dr. Mills	mills@gmail.com
3	Dr. Isaac	ike@gmail.com
4	Dr. Kutor	kut@gmail.com
\.


                                                                                                                                                                                                                                                                                                                                                                                                               4899.dat                                                                                            0000600 0004000 0002000 00000000115 14650423477 0014300 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Hakeem	hak@gmaiil.com
2	Foster	foster@gmail.com
3	Samed	sam@gmail.com
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                   4892.dat                                                                                            0000600 0004000 0002000 00000000506 14650423477 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	11252857	2086.45	2024-07-15 19:39:07.499906
3	11080058	2588.20	2024-07-20 19:29:02.90109
4	11252859	2812.34	2024-07-20 23:33:02.193306
5	11252850	4138.10	2024-07-20 23:36:25.144915
6	11252851	4198.06	2024-07-21 10:52:21.155112
7	11023595	2541.91	2024-07-22 13:01:41.851078
8	11012343	2262.00	2024-07-25 08:35:51.983486
\.


                                                                                                                                                                                          4890.dat                                                                                            0000600 0004000 0002000 00000001346 14650423477 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        11252857	Joshua	Nuku	nukujosh119@gmail.com	200	$2a$12$mk2vK5Bt6je027rvh1rIQORYK1d6WUQjAH.NbtE7NudpTZzvW4fI.
11080058	Richmond	Sakyi	sakyirichmond@gmail.com	200	$2a$12$U/PBOka2BzZxOc21RiBU0.i8Y7BHnEPE9.aIXMNAS8lh3M/vCuqFG
11252859	Tim	Drake	td@gmail.com	100	$2a$12$9HbpMcSWJ4tox3Klxfa70eGmxW0SQIDKCNdYH/ULRNSzinyvNNRdS
11252850	Jason	Todd	jt@gmail.com	200	$2a$12$COkLkKlfACcjFE5yXXCgTOie2RTq.Nxb/dfAMMaImtvtd56JY4Bou
11252851	Tracy	Morgan	tm@gmail.com	100	$2a$12$XJFZsHi07t6exPOh76e3MuxXr9Oo6GS2NTmkgoNPNsRPwMZf44ccG
11023595	Cyril	Nyavor	cyrilnyavor@gmail.com	200	$2a$12$xoCHD9XI0hCR6BcxDL778uHE97TrG7SvxoqirFL36UsQMqqHaOqZu
11012343	Kelvin	Kumi	gyabaahkelvin29@gmail.com	200	$2a$12$Bn667pBho0ectJER0wgW.uOqevR0P2r5oQAfF1PptBUP3toRcOPxa
\.


                                                                                                                                                                                                                                                                                          restore.sql                                                                                         0000600 0004000 0002000 00000043622 14650423477 0015407 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE software_engineering_db;
--
-- Name: software_engineering_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE software_engineering_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE software_engineering_db OWNER TO postgres;

\connect software_engineering_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: course_management; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA course_management;


ALTER SCHEMA course_management OWNER TO postgres;

--
-- Name: finance; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA finance;


ALTER SCHEMA finance OWNER TO postgres;

--
-- Name: student_info; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA student_info;


ALTER SCHEMA student_info OWNER TO postgres;

--
-- Name: add_new_course(text); Type: FUNCTION; Schema: course_management; Owner: postgres
--

CREATE FUNCTION course_management.add_new_course(json_request text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
   vr_student_id int;
    vr_course_code VARCHAR;
	vr_img text;
	json_result_obj json;
    
   
BEGIN
   vr_course_code := json_request::json->>'course_code';
    vr_student_id := json_request::json->>'student_id';
	vr_img := json_request::json->>'img';


    INSERT INTO course_management.course_enrollment (student_id,course_code,img)
    VALUES (vr_student_id, vr_course_code,vr_img)
    RETURNING row_to_json(course_enrollment.*) INTO json_result_obj;

    RETURN json_result_obj;
END;
$$;


ALTER FUNCTION course_management.add_new_course(json_request text) OWNER TO postgres;

--
-- Name: select_all_courses(); Type: FUNCTION; Schema: course_management; Owner: postgres
--

CREATE FUNCTION course_management.select_all_courses() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj TEXT DEFAULT '';
BEGIN
      json_result_obj= json_build_object('success',true,'data',array_to_json(array_agg(row_to_json(t))))
 from (SELECT * FROM course_management.courses) t;
IF  json_result_obj IS NULL THEN
     json_result_obj = json_build_object('success',false,'msg','Error Loading Data');
END IF;
  RETURN json_result_obj;
END;
$$;


ALTER FUNCTION course_management.select_all_courses() OWNER TO postgres;

--
-- Name: select_all_courses_and_registrations(); Type: FUNCTION; Schema: course_management; Owner: postgres
--

CREATE FUNCTION course_management.select_all_courses_and_registrations() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj TEXT DEFAULT '';
    courses_json json;
    registrations_json json;
BEGIN
    -- Select courses
    SELECT array_to_json(array_agg(row_to_json(c)))
    INTO courses_json
    FROM (SELECT * FROM course_management.courses) c;

    -- Select registrations
    SELECT array_to_json(array_agg(row_to_json(r)))
    INTO registrations_json
    FROM (SELECT * FROM course_management.course_enrollment) r;

    -- Build the result JSON
    json_result_obj = json_build_object(
        'success', true,
        'data', json_build_array(courses_json, registrations_json)
    );

    IF json_result_obj IS NULL THEN
        json_result_obj = json_build_object('success', false, 'msg', 'Error Loading Data');
    END IF;

    RETURN json_result_obj;
END;
$$;


ALTER FUNCTION course_management.select_all_courses_and_registrations() OWNER TO postgres;

--
-- Name: get_outstanding_fees(); Type: FUNCTION; Schema: finance; Owner: postgres
--

CREATE FUNCTION finance.get_outstanding_fees() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result json;
BEGIN
    SELECT json_agg(row_to_json(t))
    INTO result
    FROM (
        SELECT
            s.student_id,
            COALESCE(SUM(5000.00) - COALESCE(SUM(f.amount), 0.00), 0.00)::NUMERIC(10,2) AS outstanding_fees
        FROM student_info.students s
        LEFT JOIN course_management.course_enrollment c ON s.student_id = c.student_id
        LEFT JOIN finance.student_fees f ON s.student_id = f.student_id
        GROUP BY s.student_id
    ) t;

    RETURN result;
END;
$$;


ALTER FUNCTION finance.get_outstanding_fees() OWNER TO postgres;

--
-- Name: add_new_student(text); Type: FUNCTION; Schema: student_info; Owner: postgres
--

CREATE FUNCTION student_info.add_new_student(json_request text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
    json_result_obj json;
    vr_student_id int;
    vr_first_name varchar;
    vr_last_name varchar;
    vr_email varchar;
    vr_level int;
    vr_password varchar;
    vr_random_fee numeric(10,2);
BEGIN
    vr_student_id := (json_request::json->>'student_id')::int;
    vr_first_name := json_request::json->>'first_name';
    vr_last_name := json_request::json->>'last_name';
    vr_email := json_request::json->>'email';
    vr_level := (json_request::json->>'level')::int;
    vr_password := json_request::json->>'password';

    -- Insert new student
    INSERT INTO student_info.students (student_id, first_name, last_name, email, "level", "password")
    VALUES (vr_student_id, vr_first_name, vr_last_name, vr_email, vr_level, vr_password)
    RETURNING row_to_json(students.*) INTO json_result_obj;

    -- Generate random fee between 1000 and 5000
    vr_random_fee := (random() * 4000 + 1000)::numeric(10,2);

    -- Insert random fee into student_fees table
    INSERT INTO finance.student_fees (student_id, amount)
    VALUES (vr_student_id, vr_random_fee);

    -- Add fee information to the result JSON
    json_result_obj := jsonb_set(
        json_result_obj::jsonb, 
        '{assigned_fee}', 
        to_jsonb(vr_random_fee)
    );

    RETURN json_result_obj;
END;
$$;


ALTER FUNCTION student_info.add_new_student(json_request text) OWNER TO postgres;

--
-- Name: select_all_students(); Type: FUNCTION; Schema: student_info; Owner: postgres
--

CREATE FUNCTION student_info.select_all_students() RETURNS text
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


ALTER FUNCTION student_info.select_all_students() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: course_enrollment; Type: TABLE; Schema: course_management; Owner: postgres
--

CREATE TABLE course_management.course_enrollment (
    enrollment_id integer NOT NULL,
    student_id integer NOT NULL,
    course_code character varying(20) NOT NULL,
    reg_date timestamp with time zone DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'::text),
    img text
);


ALTER TABLE course_management.course_enrollment OWNER TO postgres;

--
-- Name: course_enrollment_enrollment_id_seq; Type: SEQUENCE; Schema: course_management; Owner: postgres
--

CREATE SEQUENCE course_management.course_enrollment_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE course_management.course_enrollment_enrollment_id_seq OWNER TO postgres;

--
-- Name: course_enrollment_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: course_management; Owner: postgres
--

ALTER SEQUENCE course_management.course_enrollment_enrollment_id_seq OWNED BY course_management.course_enrollment.enrollment_id;


--
-- Name: courses; Type: TABLE; Schema: course_management; Owner: postgres
--

CREATE TABLE course_management.courses (
    course_code character varying(20) NOT NULL,
    course_name character varying(100) NOT NULL,
    credits integer NOT NULL,
    level integer,
    course_info text,
    lecturer text,
    ta text
);


ALTER TABLE course_management.courses OWNER TO postgres;

--
-- Name: lecturers; Type: TABLE; Schema: course_management; Owner: postgres
--

CREATE TABLE course_management.lecturers (
    lecturer_id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE course_management.lecturers OWNER TO postgres;

--
-- Name: lecturers_lecturer_id_seq; Type: SEQUENCE; Schema: course_management; Owner: postgres
--

CREATE SEQUENCE course_management.lecturers_lecturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE course_management.lecturers_lecturer_id_seq OWNER TO postgres;

--
-- Name: lecturers_lecturer_id_seq; Type: SEQUENCE OWNED BY; Schema: course_management; Owner: postgres
--

ALTER SEQUENCE course_management.lecturers_lecturer_id_seq OWNED BY course_management.lecturers.lecturer_id;


--
-- Name: teaching_assistants; Type: TABLE; Schema: course_management; Owner: postgres
--

CREATE TABLE course_management.teaching_assistants (
    ta_id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE course_management.teaching_assistants OWNER TO postgres;

--
-- Name: teaching_assistants_ta_id_seq; Type: SEQUENCE; Schema: course_management; Owner: postgres
--

CREATE SEQUENCE course_management.teaching_assistants_ta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE course_management.teaching_assistants_ta_id_seq OWNER TO postgres;

--
-- Name: teaching_assistants_ta_id_seq; Type: SEQUENCE OWNED BY; Schema: course_management; Owner: postgres
--

ALTER SEQUENCE course_management.teaching_assistants_ta_id_seq OWNED BY course_management.teaching_assistants.ta_id;


--
-- Name: student_fees; Type: TABLE; Schema: finance; Owner: postgres
--

CREATE TABLE finance.student_fees (
    payment_id integer NOT NULL,
    student_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE finance.student_fees OWNER TO postgres;

--
-- Name: student_fees_payment_id_seq; Type: SEQUENCE; Schema: finance; Owner: postgres
--

CREATE SEQUENCE finance.student_fees_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finance.student_fees_payment_id_seq OWNER TO postgres;

--
-- Name: student_fees_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: finance; Owner: postgres
--

ALTER SEQUENCE finance.student_fees_payment_id_seq OWNED BY finance.student_fees.payment_id;


--
-- Name: students; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.students (
    student_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    level integer NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE student_info.students OWNER TO postgres;

--
-- Name: course_enrollment enrollment_id; Type: DEFAULT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.course_enrollment ALTER COLUMN enrollment_id SET DEFAULT nextval('course_management.course_enrollment_enrollment_id_seq'::regclass);


--
-- Name: lecturers lecturer_id; Type: DEFAULT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.lecturers ALTER COLUMN lecturer_id SET DEFAULT nextval('course_management.lecturers_lecturer_id_seq'::regclass);


--
-- Name: teaching_assistants ta_id; Type: DEFAULT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.teaching_assistants ALTER COLUMN ta_id SET DEFAULT nextval('course_management.teaching_assistants_ta_id_seq'::regclass);


--
-- Name: student_fees payment_id; Type: DEFAULT; Schema: finance; Owner: postgres
--

ALTER TABLE ONLY finance.student_fees ALTER COLUMN payment_id SET DEFAULT nextval('finance.student_fees_payment_id_seq'::regclass);


--
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: course_management; Owner: postgres
--

COPY course_management.course_enrollment (enrollment_id, student_id, course_code, reg_date, img) FROM stdin;
\.
COPY course_management.course_enrollment (enrollment_id, student_id, course_code, reg_date, img) FROM '$$PATH$$/4895.dat';

--
-- Data for Name: courses; Type: TABLE DATA; Schema: course_management; Owner: postgres
--

COPY course_management.courses (course_code, course_name, credits, level, course_info, lecturer, ta) FROM stdin;
\.
COPY course_management.courses (course_code, course_name, credits, level, course_info, lecturer, ta) FROM '$$PATH$$/4893.dat';

--
-- Data for Name: lecturers; Type: TABLE DATA; Schema: course_management; Owner: postgres
--

COPY course_management.lecturers (lecturer_id, name, email) FROM stdin;
\.
COPY course_management.lecturers (lecturer_id, name, email) FROM '$$PATH$$/4897.dat';

--
-- Data for Name: teaching_assistants; Type: TABLE DATA; Schema: course_management; Owner: postgres
--

COPY course_management.teaching_assistants (ta_id, name, email) FROM stdin;
\.
COPY course_management.teaching_assistants (ta_id, name, email) FROM '$$PATH$$/4899.dat';

--
-- Data for Name: student_fees; Type: TABLE DATA; Schema: finance; Owner: postgres
--

COPY finance.student_fees (payment_id, student_id, amount, payment_date) FROM stdin;
\.
COPY finance.student_fees (payment_id, student_id, amount, payment_date) FROM '$$PATH$$/4892.dat';

--
-- Data for Name: students; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.students (student_id, first_name, last_name, email, level, password) FROM stdin;
\.
COPY student_info.students (student_id, first_name, last_name, email, level, password) FROM '$$PATH$$/4890.dat';

--
-- Name: course_enrollment_enrollment_id_seq; Type: SEQUENCE SET; Schema: course_management; Owner: postgres
--

SELECT pg_catalog.setval('course_management.course_enrollment_enrollment_id_seq', 52, true);


--
-- Name: lecturers_lecturer_id_seq; Type: SEQUENCE SET; Schema: course_management; Owner: postgres
--

SELECT pg_catalog.setval('course_management.lecturers_lecturer_id_seq', 4, true);


--
-- Name: teaching_assistants_ta_id_seq; Type: SEQUENCE SET; Schema: course_management; Owner: postgres
--

SELECT pg_catalog.setval('course_management.teaching_assistants_ta_id_seq', 3, true);


--
-- Name: student_fees_payment_id_seq; Type: SEQUENCE SET; Schema: finance; Owner: postgres
--

SELECT pg_catalog.setval('finance.student_fees_payment_id_seq', 8, true);


--
-- Name: course_enrollment course_enrollment_pkey; Type: CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_pkey PRIMARY KEY (enrollment_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_code);


--
-- Name: lecturers lecturers_email_key; Type: CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.lecturers
    ADD CONSTRAINT lecturers_email_key UNIQUE (email);


--
-- Name: lecturers lecturers_pkey; Type: CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.lecturers
    ADD CONSTRAINT lecturers_pkey PRIMARY KEY (lecturer_id);


--
-- Name: teaching_assistants teaching_assistants_email_key; Type: CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.teaching_assistants
    ADD CONSTRAINT teaching_assistants_email_key UNIQUE (email);


--
-- Name: teaching_assistants teaching_assistants_pkey; Type: CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.teaching_assistants
    ADD CONSTRAINT teaching_assistants_pkey PRIMARY KEY (ta_id);


--
-- Name: student_fees student_fees_pkey; Type: CONSTRAINT; Schema: finance; Owner: postgres
--

ALTER TABLE ONLY finance.student_fees
    ADD CONSTRAINT student_fees_pkey PRIMARY KEY (payment_id);


--
-- Name: students students_email_key; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: course_enrollment course_enrollment_course_code_fkey; Type: FK CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_course_code_fkey FOREIGN KEY (course_code) REFERENCES course_management.courses(course_code);


--
-- Name: course_enrollment course_enrollment_student_id_fkey; Type: FK CONSTRAINT; Schema: course_management; Owner: postgres
--

ALTER TABLE ONLY course_management.course_enrollment
    ADD CONSTRAINT course_enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);


--
-- Name: student_fees student_fees_student_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: postgres
--

ALTER TABLE ONLY finance.student_fees
    ADD CONSTRAINT student_fees_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              