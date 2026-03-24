--tabele
ALTER TABLE public.test_p OWNER TO test_user;
GRANT ALL PRIVILEGES ON TABLE public.test_p TO test_user;

ALTER TABLE public.inna_tabela OWNER TO test_user;
GRANT ALL PRIVILEGES ON TABLE public.inna_tabela TO test_user;

--widoki
ALTER VIEW public.v_test_op OWNER TO test_user;
GRANT SELECT ON public.v_test_op TO test_user;

ALTER VIEW public.v_inny OWNER TO test_user;
GRANT SELECT ON public.v_inny TO test_user;

--widoki zmaterializowane
ALTER MATERIALIZED VIEW public.mv_test OWNER TO test_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.mv_test TO test_user;

--sekwencje
ALTER SEQUENCE public.seq_test OWNER TO test_user;
GRANT ALL PRIVILEGES ON SEQUENCE public.seq_test TO test_user;

ALTER SEQUENCE public.seq_inna OWNER TO test_user;
GRANT ALL PRIVILEGES ON SEQUENCE public.seq_inna TO test_user;

--funkcje procedury
GRANT EXECUTE ON FUNCTION public.nazwa_funkcji(param_typ) TO test_user;
GRANT EXECUTE ON FUNCTION public.inna_funkcja(param_typ) TO test_user;

--domeny
GRANT USAGE ON TYPE public.nazwa_typu TO test_user;
GRANT USAGE ON DOMAIN public.nazwa_domeny TO test_user;

--schematy
GRANT USAGE ON SCHEMA public TO test_user;

--domyslne uprawnienia dla nowych obiektow
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO test_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO test_user;

--usuniecie su,cr,cdb
ALTER ROLE test_user NOSUPERUSER NOCREATEROLE NOCREATEDB;
