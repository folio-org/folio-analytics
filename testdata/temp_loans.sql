--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.15
-- Dumped by pg_dump version 9.6.15

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: temp_loans; Type: TABLE; Schema: public; Owner: ldpqadmin
--

CREATE TABLE public.temp_loans (
    id character varying(36) NOT NULL,
    temp_location character varying(65535)
);


ALTER TABLE public.temp_loans OWNER TO ldpqadmin;

--
-- Data for Name: temp_loans; Type: TABLE DATA; Schema: public; Owner: ldpqadmin
--

INSERT INTO public.temp_loans (id, temp_location) VALUES ('0bab56e5-1ab6-4ac2-afdf-8b2df0434378', 'Annex');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('959f65f6-ce51-4984-99fa-5e11c1f5661c', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('21b34ab5-fdb1-4922-88ba-4f32750f61da', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('7be59e21-73b2-4801-bb8e-43213f483b51', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('9a091cbd-b335-4db6-94d7-b405c386a357', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('3fd2d7aa-a6fe-4794-9d34-837a6bd31a8b', 'SECOND FLOOR');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('0c3d1397-b9c1-4cac-9cbf-2c207b37b4d3', 'SECOND FLOOR');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('9917ed7b-114f-4612-828d-3185e0580713', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('40f5e9d9-38ac-458e-ade7-7795bd821652', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('17245ff3-868f-4e3a-bbc0-9043e61164b0', 'SECOND FLOOR');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('0d8e3cac-c7b5-49d0-be39-136cd2d6615c', 'SECOND FLOOR');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('a546ed1b-ff03-43f4-a468-4fd2fccc174f', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('a2dd9538-8ae8-475e-bb9d-f7e76049b3b8', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('894ff520-feba-4014-adcf-d8cbd6afdac9', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('9291c7a9-4f3d-43f8-8083-2437bf85ebe2', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('1e15e20d-5395-4694-b282-acc3cdd79aa0', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('296273d3-ee92-497c-a25a-71eb01e181c1', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('6cfdc7a9-4409-4afb-aee9-2bc2dc9d71ce', 'Main Library');
INSERT INTO public.temp_loans (id, temp_location) VALUES ('843695a2-3fbe-4497-a1f2-bcebb5d5fc6a', 'Main Library');


--
-- Name: temp_loans load_temp_loans_pkey1; Type: CONSTRAINT; Schema: public; Owner: ldpqadmin
--

ALTER TABLE ONLY public.temp_loans
    ADD CONSTRAINT load_temp_loans_pkey1 PRIMARY KEY (id);


--
-- Name: TABLE temp_loans; Type: ACL; Schema: public; Owner: ldpqadmin
--

GRANT SELECT ON TABLE public.temp_loans TO ldp;


--
-- PostgreSQL database dump complete
--

