--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.7 (Ubuntu 17.7-3.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hydra; Type: SCHEMA; Schema: -; Owner: tcero
--

CREATE SCHEMA IF NOT EXISTS hydra;

ALTER SCHEMA hydra OWNER TO tcero;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hydra_client; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_client (
    id character varying(255) NOT NULL,
    client_name text NOT NULL,
    client_secret text NOT NULL,
    scope text NOT NULL,
    owner text NOT NULL,
    policy_uri text NOT NULL,
    tos_uri text NOT NULL,
    client_uri text NOT NULL,
    logo_uri text NOT NULL,
    client_secret_expires_at integer DEFAULT 0 NOT NULL,
    sector_identifier_uri text NOT NULL,
    jwks text NOT NULL,
    jwks_uri text NOT NULL,
    token_endpoint_auth_method character varying(25) DEFAULT ''::character varying NOT NULL,
    request_object_signing_alg character varying(10) DEFAULT ''::character varying NOT NULL,
    userinfo_signed_response_alg character varying(10) DEFAULT ''::character varying NOT NULL,
    subject_type character varying(15) DEFAULT ''::character varying NOT NULL,
    pk_deprecated integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    frontchannel_logout_uri text DEFAULT ''::text NOT NULL,
    frontchannel_logout_session_required boolean DEFAULT false NOT NULL,
    backchannel_logout_uri text DEFAULT ''::text NOT NULL,
    backchannel_logout_session_required boolean DEFAULT false NOT NULL,
    metadata text NOT NULL,
    token_endpoint_auth_signing_alg character varying(10) DEFAULT ''::character varying NOT NULL,
    authorization_code_grant_access_token_lifespan bigint,
    authorization_code_grant_id_token_lifespan bigint,
    authorization_code_grant_refresh_token_lifespan bigint,
    client_credentials_grant_access_token_lifespan bigint,
    implicit_grant_access_token_lifespan bigint,
    implicit_grant_id_token_lifespan bigint,
    jwt_bearer_grant_access_token_lifespan bigint,
    password_grant_access_token_lifespan bigint,
    password_grant_refresh_token_lifespan bigint,
    refresh_token_grant_id_token_lifespan bigint,
    refresh_token_grant_access_token_lifespan bigint,
    refresh_token_grant_refresh_token_lifespan bigint,
    pk uuid,
    registration_access_token_signature character varying(128) DEFAULT ''::character varying NOT NULL,
    nid uuid NOT NULL,
    redirect_uris jsonb NOT NULL,
    grant_types jsonb NOT NULL,
    response_types jsonb NOT NULL,
    audience jsonb NOT NULL,
    allowed_cors_origins jsonb NOT NULL,
    contacts jsonb NOT NULL,
    request_uris jsonb NOT NULL,
    post_logout_redirect_uris jsonb DEFAULT '[]'::jsonb NOT NULL,
    access_token_strategy character varying(10) DEFAULT ''::character varying NOT NULL,
    skip_consent boolean DEFAULT false NOT NULL,
    skip_logout_consent boolean,
    device_authorization_grant_id_token_lifespan bigint,
    device_authorization_grant_access_token_lifespan bigint,
    device_authorization_grant_refresh_token_lifespan bigint
);


ALTER TABLE hydra.hydra_client OWNER TO tcero;

--
-- Name: hydra_client_pk_seq; Type: SEQUENCE; Schema: hydra; Owner: tcero
--

CREATE SEQUENCE hydra.hydra_client_pk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hydra.hydra_client_pk_seq OWNER TO tcero;

--
-- Name: hydra_client_pk_seq; Type: SEQUENCE OWNED BY; Schema: hydra; Owner: tcero
--

ALTER SEQUENCE hydra.hydra_client_pk_seq OWNED BY hydra.hydra_client.pk_deprecated;


--
-- Name: hydra_jwk; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_jwk (
    sid character varying(255) NOT NULL,
    kid character varying(255) NOT NULL,
    version integer DEFAULT 0 NOT NULL,
    keydata text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    pk_deprecated integer NOT NULL,
    pk uuid NOT NULL,
    nid uuid NOT NULL
);


ALTER TABLE hydra.hydra_jwk OWNER TO tcero;

--
-- Name: hydra_jwk_pk_seq; Type: SEQUENCE; Schema: hydra; Owner: tcero
--

CREATE SEQUENCE hydra.hydra_jwk_pk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hydra.hydra_jwk_pk_seq OWNER TO tcero;

--
-- Name: hydra_jwk_pk_seq; Type: SEQUENCE OWNED BY; Schema: hydra; Owner: tcero
--

ALTER SEQUENCE hydra.hydra_jwk_pk_seq OWNED BY hydra.hydra_jwk.pk_deprecated;


--
-- Name: hydra_oauth2_access; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_access (
    signature character varying(255) NOT NULL,
    request_id character varying(40) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text NOT NULL,
    granted_scope text NOT NULL,
    form_data text NOT NULL,
    session_data text NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    requested_audience text DEFAULT ''::text,
    granted_audience text DEFAULT ''::text,
    challenge_id character varying(40),
    nid uuid NOT NULL,
    expires_at timestamp without time zone
);


ALTER TABLE hydra.hydra_oauth2_access OWNER TO tcero;

--
-- Name: hydra_oauth2_authentication_session; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_authentication_session (
    id character varying(40) NOT NULL,
    authenticated_at timestamp without time zone,
    subject character varying(255) NOT NULL,
    remember boolean DEFAULT false NOT NULL,
    nid uuid NOT NULL,
    identity_provider_session_id character varying(40),
    expires_at timestamp without time zone
);


ALTER TABLE hydra.hydra_oauth2_authentication_session OWNER TO tcero;

--
-- Name: hydra_oauth2_code; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_code (
    signature character varying(255) NOT NULL,
    request_id character varying(40) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text NOT NULL,
    granted_scope text NOT NULL,
    form_data text NOT NULL,
    session_data text NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    requested_audience text DEFAULT ''::text,
    granted_audience text DEFAULT ''::text,
    challenge_id character varying(40),
    nid uuid NOT NULL,
    expires_at timestamp without time zone
);


ALTER TABLE hydra.hydra_oauth2_code OWNER TO tcero;

--
-- Name: hydra_oauth2_device_auth_codes; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_device_auth_codes (
    device_code_signature character varying(255) NOT NULL,
    user_code_signature character varying(255) NOT NULL,
    request_id character varying(40) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    client_id character varying(255) NOT NULL,
    scope character varying(1024) NOT NULL,
    granted_scope character varying(1024) NOT NULL,
    form_data character varying(4096) NOT NULL,
    session_data text NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    device_code_active boolean DEFAULT true NOT NULL,
    user_code_state smallint DEFAULT 0 NOT NULL,
    requested_audience character varying(1024) NOT NULL,
    granted_audience character varying(1024) NOT NULL,
    challenge_id character varying(40),
    expires_at timestamp without time zone,
    nid uuid NOT NULL
);


ALTER TABLE hydra.hydra_oauth2_device_auth_codes OWNER TO tcero;

--
-- Name: hydra_oauth2_flow; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_flow (
    login_challenge character varying(40) NOT NULL,
    login_verifier character varying(40) NOT NULL,
    login_csrf character varying(40) NOT NULL,
    subject character varying(255) NOT NULL,
    request_url text NOT NULL,
    login_skip boolean NOT NULL,
    client_id character varying(255) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    login_initialized_at timestamp without time zone,
    oidc_context jsonb DEFAULT '{}'::jsonb NOT NULL,
    login_session_id character varying(40),
    state integer NOT NULL,
    login_remember boolean DEFAULT false NOT NULL,
    login_remember_for integer NOT NULL,
    login_error text,
    acr text DEFAULT ''::text NOT NULL,
    login_authenticated_at timestamp without time zone,
    login_was_used boolean DEFAULT false NOT NULL,
    forced_subject_identifier character varying(255) DEFAULT ''::character varying NOT NULL,
    context jsonb DEFAULT '{}'::jsonb NOT NULL,
    consent_challenge_id character varying(40),
    consent_skip boolean DEFAULT false NOT NULL,
    consent_verifier character varying(40),
    consent_csrf character varying(40),
    consent_remember boolean DEFAULT false NOT NULL,
    consent_remember_for integer,
    consent_handled_at timestamp without time zone,
    consent_error text,
    session_access_token jsonb DEFAULT '{}'::jsonb NOT NULL,
    session_id_token jsonb DEFAULT '{}'::jsonb NOT NULL,
    consent_was_used boolean DEFAULT false NOT NULL,
    nid uuid NOT NULL,
    requested_scope jsonb NOT NULL,
    requested_at_audience jsonb DEFAULT '[]'::jsonb,
    amr jsonb DEFAULT '[]'::jsonb,
    granted_scope jsonb,
    granted_at_audience jsonb DEFAULT '[]'::jsonb,
    login_extend_session_lifespan boolean DEFAULT false NOT NULL,
    identity_provider_session_id character varying(40),
    device_challenge_id character varying(255),
    device_code_request_id character varying(255),
    device_verifier character varying(40),
    device_csrf character varying(40),
    device_was_used boolean,
    device_handled_at timestamp without time zone,
    device_error character varying(2048),
    expires_at timestamp without time zone GENERATED ALWAYS AS (
CASE
    WHEN (consent_remember_for > 0) THEN (requested_at + ((consent_remember_for)::double precision * '00:00:01'::interval))
    ELSE NULL::timestamp without time zone
END) STORED,
    CONSTRAINT hydra_oauth2_flow_check CHECK (((state = 128) OR (state = 129) OR (state = 1) OR ((state = 2) AND ((login_remember IS NOT NULL) AND (login_remember_for IS NOT NULL) AND (login_error IS NOT NULL) AND (acr IS NOT NULL) AND (login_was_used IS NOT NULL) AND (context IS NOT NULL) AND (amr IS NOT NULL))) OR ((state = 3) AND ((login_remember IS NOT NULL) AND (login_remember_for IS NOT NULL) AND (login_error IS NOT NULL) AND (acr IS NOT NULL) AND (login_was_used IS NOT NULL) AND (context IS NOT NULL) AND (amr IS NOT NULL))) OR ((state = 4) AND ((login_remember IS NOT NULL) AND (login_remember_for IS NOT NULL) AND (login_error IS NOT NULL) AND (acr IS NOT NULL) AND (login_was_used IS NOT NULL) AND (context IS NOT NULL) AND (amr IS NOT NULL) AND (consent_challenge_id IS NOT NULL) AND (consent_verifier IS NOT NULL) AND (consent_skip IS NOT NULL) AND (consent_csrf IS NOT NULL))) OR ((state = 5) AND ((login_remember IS NOT NULL) AND (login_remember_for IS NOT NULL) AND (login_error IS NOT NULL) AND (acr IS NOT NULL) AND (login_was_used IS NOT NULL) AND (context IS NOT NULL) AND (amr IS NOT NULL) AND (consent_challenge_id IS NOT NULL) AND (consent_verifier IS NOT NULL) AND (consent_skip IS NOT NULL) AND (consent_csrf IS NOT NULL))) OR ((state = 6) AND ((login_remember IS NOT NULL) AND (login_remember_for IS NOT NULL) AND (login_error IS NOT NULL) AND (acr IS NOT NULL) AND (login_was_used IS NOT NULL) AND (context IS NOT NULL) AND (amr IS NOT NULL) AND (consent_challenge_id IS NOT NULL) AND (consent_verifier IS NOT NULL) AND (consent_skip IS NOT NULL) AND (consent_csrf IS NOT NULL) AND (granted_scope IS NOT NULL) AND (consent_remember IS NOT NULL) AND (consent_remember_for IS NOT NULL) AND (consent_error IS NOT NULL) AND (session_access_token IS NOT NULL) AND (session_id_token IS NOT NULL) AND (consent_was_used IS NOT NULL)))))
);


ALTER TABLE hydra.hydra_oauth2_flow OWNER TO tcero;

--
-- Name: hydra_oauth2_jti_blacklist; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_jti_blacklist (
    signature character varying(64) NOT NULL,
    expires_at timestamp without time zone DEFAULT now() NOT NULL,
    nid uuid NOT NULL
);


ALTER TABLE hydra.hydra_oauth2_jti_blacklist OWNER TO tcero;

--
-- Name: hydra_oauth2_logout_request; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_logout_request (
    challenge character varying(36) NOT NULL,
    verifier character varying(36) NOT NULL,
    subject character varying(255) NOT NULL,
    sid character varying(36) NOT NULL,
    client_id character varying(255),
    request_url text NOT NULL,
    redir_url text NOT NULL,
    was_used boolean DEFAULT false NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    rp_initiated boolean DEFAULT false NOT NULL,
    nid uuid NOT NULL,
    expires_at timestamp without time zone,
    requested_at timestamp without time zone
);


ALTER TABLE hydra.hydra_oauth2_logout_request OWNER TO tcero;

--
-- Name: hydra_oauth2_obfuscated_authentication_session; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_obfuscated_authentication_session (
    subject character varying(255) NOT NULL,
    client_id character varying(255) NOT NULL,
    subject_obfuscated character varying(255) NOT NULL,
    nid uuid NOT NULL
);


ALTER TABLE hydra.hydra_oauth2_obfuscated_authentication_session OWNER TO tcero;

--
-- Name: hydra_oauth2_oidc; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_oidc (
    signature character varying(255) NOT NULL,
    request_id character varying(40) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text NOT NULL,
    granted_scope text NOT NULL,
    form_data text NOT NULL,
    session_data text NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    requested_audience text DEFAULT ''::text,
    granted_audience text DEFAULT ''::text,
    challenge_id character varying(40),
    nid uuid NOT NULL,
    expires_at timestamp without time zone
);


ALTER TABLE hydra.hydra_oauth2_oidc OWNER TO tcero;

--
-- Name: hydra_oauth2_pkce; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_pkce (
    signature character varying(255) NOT NULL,
    request_id character varying(40) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text NOT NULL,
    granted_scope text NOT NULL,
    form_data text NOT NULL,
    session_data text NOT NULL,
    subject character varying(255) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    requested_audience text DEFAULT ''::text,
    granted_audience text DEFAULT ''::text,
    challenge_id character varying(40),
    nid uuid NOT NULL,
    expires_at timestamp without time zone
);


ALTER TABLE hydra.hydra_oauth2_pkce OWNER TO tcero;

--
-- Name: hydra_oauth2_refresh; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_refresh (
    signature character varying(255) NOT NULL,
    request_id character varying(40) NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text NOT NULL,
    granted_scope text NOT NULL,
    form_data text NOT NULL,
    session_data text NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    requested_audience text DEFAULT ''::text,
    granted_audience text DEFAULT ''::text,
    challenge_id character varying(40),
    nid uuid NOT NULL,
    expires_at timestamp without time zone,
    first_used_at timestamp without time zone,
    access_token_signature character varying(255) DEFAULT NULL::character varying,
    used_times integer
);


ALTER TABLE hydra.hydra_oauth2_refresh OWNER TO tcero;

--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.hydra_oauth2_trusted_jwt_bearer_issuer (
    id uuid NOT NULL,
    issuer character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    scope text NOT NULL,
    key_set character varying(255) NOT NULL,
    key_id character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp without time zone DEFAULT now() NOT NULL,
    nid uuid NOT NULL,
    allow_any_subject boolean DEFAULT false NOT NULL
);


ALTER TABLE hydra.hydra_oauth2_trusted_jwt_bearer_issuer OWNER TO tcero;

--
-- Name: networks; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.networks (
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE hydra.networks OWNER TO tcero;

--
-- Name: schema_migration; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.schema_migration (
    version character varying(48) NOT NULL,
    version_self integer DEFAULT 0 NOT NULL
);


ALTER TABLE hydra.schema_migration OWNER TO tcero;

--
-- Name: hydra_client pk_deprecated; Type: DEFAULT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_client ALTER COLUMN pk_deprecated SET DEFAULT nextval('hydra.hydra_client_pk_seq'::regclass);


--
-- Name: hydra_jwk pk_deprecated; Type: DEFAULT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_jwk ALTER COLUMN pk_deprecated SET DEFAULT nextval('hydra.hydra_jwk_pk_seq'::regclass);


--
-- Data for Name: hydra_client; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_client (id, client_name, client_secret, scope, owner, policy_uri, tos_uri, client_uri, logo_uri, client_secret_expires_at, sector_identifier_uri, jwks, jwks_uri, token_endpoint_auth_method, request_object_signing_alg, userinfo_signed_response_alg, subject_type, pk_deprecated, created_at, updated_at, frontchannel_logout_uri, frontchannel_logout_session_required, backchannel_logout_uri, backchannel_logout_session_required, metadata, token_endpoint_auth_signing_alg, authorization_code_grant_access_token_lifespan, authorization_code_grant_id_token_lifespan, authorization_code_grant_refresh_token_lifespan, client_credentials_grant_access_token_lifespan, implicit_grant_access_token_lifespan, implicit_grant_id_token_lifespan, jwt_bearer_grant_access_token_lifespan, password_grant_access_token_lifespan, password_grant_refresh_token_lifespan, refresh_token_grant_id_token_lifespan, refresh_token_grant_access_token_lifespan, refresh_token_grant_refresh_token_lifespan, pk, registration_access_token_signature, nid, redirect_uris, grant_types, response_types, audience, allowed_cors_origins, contacts, request_uris, post_logout_redirect_uris, access_token_strategy, skip_consent, skip_logout_consent, device_authorization_grant_id_token_lifespan, device_authorization_grant_access_token_lifespan, device_authorization_grant_refresh_token_lifespan) FROM stdin;
657d0bb0-2314-4c8b-b649-1525af797d72	bff-service	$pbkdf2-sha256$i=25000,l=32$EqY4G+Jztp099WqlJjcbHg$9VLgmG6hDgGxy+LLJyCqMCEboiI/Aguy0qS9mBwiT/k	openid offline mediamtx:stream						0		{}		client_secret_post	RS256	none	public	1	2026-01-06 15:58:13	2026-01-06 15:58:13.074241		f		f	{}		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UdABBmKGIMDO4l5dlhIBoPJifStb08xrMForqAGOjXY	33c11459-e9b5-4080-adea-b249c302d99f	["${URL_EXTERNAL}/bff/callback"]	["authorization_code", "refresh_token"]	["code"]	[]	[]	[]	[]	[]	jwt	f	t	\N	\N	\N
\.


--
-- Data for Name: hydra_jwk; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_jwk (sid, kid, version, keydata, created_at, pk_deprecated, pk, nid) FROM stdin;
hydra.jwt.access-token	f1685b9b-935f-4e86-b0e3-d779628db69d	0	GX6iWD9TRy9dAEw4G6t8mw2jqTiN4hy2OMz-5fk5IyvohEQO9YWMJmIh24yQ_UMoNDnE7gL7WYPQ3AnRUUnWAt4JrBtx1xuFmgcysw5JcELDZbxNSw2BWkmMOkyqwGNJZytfu_9mmT9IB0WaBqxLhHv-HUaA01O0S36uxaF8FJn5vjfRASL4w8lnVHC1HrGzgZIsyo4cV4RMaDOigdqA7KsRLcAUx42BskmGUACmXmMxic102XqZTOdEKvbfTp6w9JQcIMgONCzVE15YQYtzBiTdqG9WtgCFxfR5CqUJPZEVGIQX8NMYp3Esj7E1ixQtzsE7QP4gpEfeLET0pFD1fcjCZA4yZisZOB633m6jBxZkSxkOzZPBgRtBhdxznL3OHgzr-dmWQ1nHG9TvsPDFec12Toot7c4IrQ71OgMCPII6BfYsuEW9dlr_qzpOPG1mZYzgC9wrZIdEqzIc-uCATpbHuTKrxZ-lcBQRokQQ5ugOeBdxm4EJcqFQM1RximDqvNqF8bJlXs08KvS_-d-L6qbyA2cfTuu94sn-EUEOOOOqye8xcAS_68mEnWWUFaY_Z8c3S-PHnSgQJQd5iOel_qCEvohwOE4vDAzJXppZYnZSjU86uDfaCRPJv6oiJAxrhDHbKm1WVeoJfBZ-M7o2Q2UklmXmGUuoTImzXT24q7XGo4jyEwfHy7qKstF04831EOxvTAT4i1xlMxoYNLGZtGZDSJEmjG6rrRfCutxStz1x04oN95wvauIxUZphXJShRY8nRKBzta5_X7c6QWcfWirdvOfCw-f2RjhrQBOByRMbUpzzwxedP1OUpHQTmSmVkO3_zHKqULFluJKhhqCAVoLZA0x2p8AGADbC_tSHTJrcWqs5nUKuFoOFYDz0TbAerW-PYH7kSB6ty3ipdusHDpmqjAmNUW74-y3PaaZM7I5HgeiQ9WaKlAXJsDC_cpCa5Qar47zmYEUztsPqALw_uSmliLG74C50NnkQa7QpKrANn2sB_Fsg1dfPlbHtEWg4ZG7dVs5AvrMKhGVe5jQjpB3InGa1nnszBAYeQVPI-2ER-o4ys9ISA7ajqRvSRonqUjvKor1OEYkzFJmGYx07HdlQTAqMBlncROFOkBAdRGb7DIXuXf083rSMN9B8xrO8qw0pAjUIudYsefAC86uN2eUHXMt7YN8842tDI2nxtPdMO7y9ZMoQryrkj9jtXylwtbJLCUi1SCcM45jXcSLmz6jOhJvSMAiKg1O0soIkNL-5TbQiNA5r_e_08fG3wthNC9SrVcZwNFBPluW6nAgzukiILi2Lh5cpSdfNFbvQh38kb_NLkxXdHAE-sLdddIaCAXO3_N6Hp2y-qimi8WWfIpUmmtXG9BeUxyPeYGmQTh_-aTiPqdnin8GlL5ceDxF4t7_muu8pDbTspwwEN0nRpMLrSXgykFYEmqqUq-LfcaCONIPJcOzmUY00FREg5joZ5-OYNp4rXd0y8NIPBTb1gMDtkr5WS1poP7qiRvnvDqSI457um55Ml_L6_zbqriyNnPKyddoZ5SVDbDte-Amc5fpQDLkbRDxCZuCTCFBFvkJNUHKMQbwzRegJsMa-q5FpC2JPDPsNBQlViq9JAsAh6pJST2NAauveDBaW_06Nsy0t2Fk0vZp8d3f4ozQw3dLbGYfi-XlyEIWjhYimT4mTfe6KgpZeB4TZ3hd70YF7bXds7UWE-55-HJh-FjlPdnylpjl21DbrtWfiMa7ozxC1XTqQPZ9Iz7c3FWg7DFVQdqfZjm-qWq5gx_mmpfEzkffunQU2Rl6Thmvy5m2IMhZXg6DwppT3M5V4wubF5eNyJQ0rl5gZShIOAPCwq1sLz2PykCUZ9635kkTiXdDlvtPeRW6yJAP2N46KqxsqY9cvGYuh21Bqa6P2H_HEIJU7KIktRXhkyUcE4Zc1cc_69sLLZCktd7L0l5rqOJoFVQnmybVt4qL9GxQbDSs6FXLn8RKT-DvpXJN3fQmcvQEoCOF4ajdmTzjJ58fF8XVKNq40EnAMygfiV1VVFRc9jTicBMRCA_jKWwwmG68rn4y5ZAhpfuKjcemf2_Tepu9d_2D2Vf6H4rsZ8Rgcvb1VMaBcbic9nH_xOy5YYcLBu33xZvGDlCI1cxZy53knBxeZ2Uhc9cqNAUuQVW9Q3ajMkRwPe7v7yrjKL82Z-3tU7ALrOAoV7KFLu5d08JmFAu8AYcl7T6ZLcSVn_L6ZAmoTYH52yBj3chHheNIHpWTBsais_cn_SBsaFyFdfqcJJbu3nEZPCSaYhCFaQc7zoUjl1cKVDPz9jq5GZqlKs-B32NTLdt9N0iK2IFjc60wBqmLjE8tZH-na3cKtyvzOdRRg_UT4q7Vi1eYM5KVDKwIdqpGu371cTkPnoiMoGNsFiiF-Utb8QzJJAtTOPHlDsNIs_Jfv77qdaqjtQiQW0tDqk6f0p2F0Qec_1u0Oqwxo9RcgGDS_n2uuEm34hjQFNrkR1SAL-KsHf6mwxzJ5L2i703eqN36OHoUqWF6ePyaOIHf_ci24t0kiLNDFqZ4Xa0Hy3BK_S4Nrvxt0SA4a2L8m3XgNaEijeNfPrwAbrM8h3bYxmthEuIN2mBdf9lCE9p3lii5P9HjzolNrtc6i0TzSnaHO5yaMKhESYIb2o9e-f0J14Vesr2Yg0wbSUghJTCNtrJfybQc9VNIPKTHZDMSCPArVlGfchw5ftPJkONa-iCA2l8lBoOJoII505_OBVoZj7qDwIMuksX4bJCgF-W-_FIMBuofA5lsUj88kYmHBPlpBjfyPzX-vHNhTF_GCWuOEAFBn0Ea2k0k-ZeaXEPE3neDI9WwtC9RF53RAjM37f1jhCcMqvtGNFxJkfMfdCjPl1Zwi7X-15QS0IJSRJQJ-QzjiByOAbi67_qU9Sw3byYP7HBCjVAjaNzcSGjRkjLjjhTkEJ45sdytV0lLoRahlu7s1QeQCx5dqMwiQzg5HJjk0d7pNz4Y5u3IFC6Lj1WLgPmhCGF5gv7Eo6s4KhiZ03TcneasUJfljB2_ztNk1mOt66wZTuPx1I5p4oKbhac89cjfSLoB9evtdHuS4mzRCIpI4vEA9ogr03DgX_TaEuWS9QsDCXv1o8zCa8DZRgJg-aWYtsJtGEfI7oeK7XnSk6JGCiBaWy0gsv8u6mhybVlELXYLGgvNsv-3UVEVhAKb8jxN9qvAKfEW696Ozw_jN8zFt1KtMys4hrv3EV4W_S7rBkwJRImBSJ7DLwvsP56IQIZ2CHpDhiWd74G4XctAwZCNpzcb6jjymV3rlqSpCbqzA3LDhE9mehF-unFWR1zzF3UDDB2kwxJaPQL3S1Sssk6UaK61kl44vZqBrZx9RB2lNsC5h-7XUTmcUAQesQRiEiKB5vu7TOsvPwlvHOpgN7Ag6DdjCltAStEeyOnQ6s8BQpyegJNfVlSmCqYEMTfafYRJead0Jfn9TZycyukoBwUQ_u0-Kf_sEvx0uNMyCTssJi2S0g96jzD8skZmLM5EIPCZWRKDJL5vGgUUlbcHruhXNqd8t7WCD_ShLq--Bx2teEugpUSIOl5P738oXkcpznLgaw-JK7YmB3BWT_X3aKmX_gn7C12fdyCY34yfu9ngq4yp3XM74POGKH69AswKepgK18PkOhpLW_U_Su4XXnQq9sG2Y8dwIPdrN_cehVVJTMKD9AHUTgYPQ9UJaVhKRTfetJN9QstrR4qRCkwmSRqf4unKW0LXtD5qlsOcFvwMyV-qpOGAbbKMpQlA31MSsUOizIPxP4s_3iaCTIOAtnVMI3vuHTNeLjS8tlfODRYI1fIbSUvjjLTo0_6K_dnfke4LPav7MJbDS_E7hF4GkpyaMqSz2TTFd07FuYk1ieRry-dhNhGftCtelYW6UKGlJ-RO3ViM97tQM-2EKC0dRBIyPIHYjGvSCvaTbrfBiIQeQViySlA4ywSTOCwSTKY2ZOP_rSkRTZV0Q-CJ2vUn25KdltXUtDe90vTbMxFhO77gQ1EL2LJu29qOY-dz5hyzD-K3v91746MCDhVaUnTUrdFiczOXZ56GpmAPCOwtC8WG_4hhEstPBBJ14gCDmY2367-huJE0eXwYV2ctYmPTQDrHEGyEFDQ6pSY6Bzgm6OI9yafu425RiFCK9y2MMTEh4319MNTNZgOXtInJYKKQhd89Ilw8Xjgmbrn1Tq8eDWM-pzeVSKVWLrXBD2SmqFLIA4rFMzsL3J1SXtpc9QKyR12GMmKbOsdHLs79QiPzqxoVLULoxIWapFem4zGgyu0BH3Ki9xXUUw2wfZlivMUOJcKipaHFaj_oAxMzOMSnDP8pIdQimrHp-N7g=	2026-01-06 16:30:51.410985	0	429f241b-585c-429f-97b3-d4a8d2cf88c8	33c11459-e9b5-4080-adea-b249c302d99f
hydra.openid.id-token	4530fb6c-1db9-4daa-a6c3-2eba9bd1d001	0	xWfZ5IhaYy2MUuSunv2J5zKQtGNEbrHDbif9n522G_P0YdZV-AvcsRfw8MBAQuQ4e8qXFOOhn4x2AfkOfb1U_dWk_X9eOFSEJON8POauTJaJwJm7BQ-ODEz5hKTOPpNroTQr8Fa5cpg3Y3XRm3FiSVhDEjbNSuvPHia-pzn67tdAMpM4nygApWhRStt3MEvV8cp_R503UxnhXR5LNDEzVoPzclKdN8gCyE84p7POwYMzuN8IcHrxtFc5zC-2miZsVcy9o0FZC9P9ImYBY4oJ1WrXchMio8j42c9Pe2pdTHji7JX2YIt6H5-Ryox3EyMcwrCMxBS5BVjwAYO-3XxE0cCa5ezR5OGxo5keygcPSnzrvXSmMpAK2WS-5-PzdUIwPHQiDkpJRCZYPQyfWSeD-QR5DOQWhBeaM5hgqOfHzC6e4pOXTgDuvIgAU7_iMfFvVvTy2p4RXl_8On_cuuIEzNGZAl_tDy6YP2x9m-fF2re5t_633psv4buMzqqn7IonX_Ezu8bv-5PmTN6DZ2lh51-B36onupA01g50DqHWIvQZV7Od-01ZFrMzzAT2NIvEno0Dihf3CYOZ_D7g9X1UoBhtehQ8DiqUW5qKZoopwAKEDlJEbo3ccpMzIIW3Pl0AzAK_v3LWogYMn34Ux6fHa5lc4107e5qauOe8t0bARmuDT4QnPZfG8WRXyaUNmKB-SMxsrrxzDP4oydeddqrZPTesudIVHp_OibOzdtNIPwdcnCsYDipBgPTOUnmyYQY9QECBu2bYGGsI1pOMMbu2wDJs_-r-VspBNBdDSyGEF2GE1h2oJa6zmU9oWPKQhlrRKSPhXPMnROb5gL6qGRGSbh5HoFi5EWRKTR-_wCRmn0VWV61zvE3b6AazBIhkPo958xlpFc5GM-ye_o-r8IyZvnmhD7vbpPX1-okvM8jG-ww6iJUhXblwD-UqmqQRwSgUateJ_ZoLfCu_7kEFisllKHYv4eYHZSqXJtXNJ03YI5tEd20fNQCx5XSaVFd8Lq4h6ldFd3aiB0GYS_IjI_E7yKbJJv9CZtxax-F-xPV8YR8Jbbl7jCwO804BCES6ThIdMkZVqQBOpZ5ZWkyvj7u68J4UL1ieVaGlI_KfftzH4hod0zS6mMDCTY3Z00FuSALswalWurgyUNqDyhpGWqw-Ck7EMPChm4PBGxgn6tqfuOZ1lUv4DXlF0u1t1oWobqO0yapV_VA2RT6qPZt9CIB8hl24KYVbmAvf-hYukIsgbqQpZx2VcQCpR0kuD8_upEAYpMg4vJNOxhfc3sVPmtDRROnd-9utXf0MrHOCTJHC3eFsepmfxKr-IijOuMSzwm8sPoCjusOo1ictBfK9k8ft4toSqljh4B3LPfR6BGCnisb9DKlH6gb-FtFWYZ75oPXtvvv4pG8kmDJENblEh9CCAcE1QPfdFopMF2NxCh9z4DTDC1H_YTntYDPFdnAG2Bx1jHfhhtu5trRvv7cN82NAe7LPpHBMtzhTf9FwZm28wIgR0fGqJsFOKjUUKoxoOUO5gQDtRDI1mo422UH3TCr7_8aIobELWP2Npxyv7HvOE1hGoFG-rfJb4Eawbvicud6qJFhNfUoM1_jDLDYTeSEW1EyhCJsoHRRNiXJ0CASmRGlmUuUMadhpdHJC_X397j0QXLnL6rzA8nan1VIhLYl9W9kR8_gRid6lE0K6-rGTOMpboqTcHogN5InyrPTs8O7UHAEu__jfdg8-58C5YL5zJlBDYWd1eI35C-Qx1fQUedNea4R_J5j-hNVW2mu6kmhGgeIl3j7m7nSt6BYhVhkI64beRB8vixJRATAnBzKKOfk-nb4W8rkwhoDkWHIL7njBEvhE83FLTDXn7HIdy8wkghvcDLab8S83_kpo9LMaE6vR3YftgZYYIOxwAdy1RfGmABRHU-p5yZPhLly2ghMkLkzetgWv6zSFQdZDt9aAKLUcjIvkJBL3wsw_hMN1kkpZr7jmi2UdgQA2Es7R0u-HngUS1a8VRf0iPIDDM2lR_O1n2XhuIQKIRDPNT0qhIO1I5IZcuCsITlVoVfaZOtcxNaMWw9OB_hlwdiSpeGWFYc3-koA87DOKr-RppkB2fIbXLkbJJk0NaVFf1WpM1gZiTuH-Kj5j8FbZdmtTAa1CLwuGluWLrwt6mCYiwrqsqnFpWjopAsrIvjUGEEa4QInuq8RYBznVMqJ6hZk9zIXNIh54xbK80k2cWqav7dLL8tlor1Atbjd-NyTisK56xRc29tc4ZYeycJLwRTbcbKhC0eM2n7uHkc384KW9JHinfZTfOObSxWf7F3L8Xl66xn_0R47BCBcBplFcIxDVp-mIo2kVkb23Ly2TuSiOUvtKxH-qaOKuJKSFtdmlIXuGjnJzqXKzIa2HjIRRzspjk3GUEoX0525tsu-usdAabk8EBuiVlczWe063Yn_6_WHyqg9e3I-03z8-MDnQvhJ9ujym3DCaOrPZ0LBrsWgzSqtBO6llOFdl6tObtd7F7J5U4CcVbybwTqZ-D5Nx_fQECBoQP2SNjB_Kr5Zm5xIkpvgaCqDZ9BmyssZPuIcQ3A4kLIxozjH9u0cnZ2btWoiDASK6ISE9yP0Y2RWVwRMfrtiUdrxrbbCoKKkHMVrx4imzAzGPhG2t5NBqa6W-A6qkMhAeMV52gA9RX0vRS2hbIUJDpqzEzzSVlI5keb20Wj9GF8bxiP9-rl3FhfewIIp_N-pZ6Vcx759U--AEwOVxcyOZWUNAXaAfZClufi1hxK3MnVsQ45pv3DTG8-k-tBOVDnkvVVlOEtZv5X2y48U8gB3Q4lAkhd-M1h7k8r6N_cVturOLP9lF1XO0A0YlvAqP8RM4Eu5lHfL-4JcifddbZAaqRJBxB7VzYXQZIEIXhEvZhWok-ja-6N_gHcw1wgZcmikSjfb30ZSyCoP4f4tgCC29SCoIeI1Fz9Ky0-dy06z-eLOskZ6c-4NmIytbnpOz8lUDiQXy7nuX49JmNCY6XRAl-X_NRfOwgpTywCQRznHy8JyfnN1dq3I42NA1ZqAkdrokYB3nG0NUCgkGpJ1p8AlJ5RNuvrumaieAVAmisE7DqLgrP1moPqDgz7AYPGd3x5AUekwWp3m0J-NS17W2lYUBfmSLt-PJ3aNl0iCn8e9hqLqTZgNiah8ER2OQ9Xde3JGhthHZHjqnLiustyGDFibTjr51RVSmd6FZZukd_LCD0_RQ7PH5f3TX2P66l5z-9vw1ml-7QmTqARHFdGe8lhnMVeDk265s2m14ChR46B0XBDQDiruXL6BR42LhvnB8jhKGHTJ1r1cRd5ZmVRJ_Isd0AqGug85DVh8eCN1q3zeD21yu8LylAWwW3wJc4JskY71OSm3uVZlOecPM7l1-hcs-Mp6NAvP5aTeYYnbGrm1DY2A2i7N_9Fi90EQhq1-nGZmnkVyIbxZtK78vTot_9hHRecGu8A-JJfXTVeX88qqOTq3IPO277i5vP0sQ5xAug_SogzcmnglK2ZtG9xyIlz-BLc2nUFlFVVKMeN_lzIQOYVXpyfhUYrfCpt4aKWmP0GO2jCFquqhRiEs0SN5ATLjOmynwirhTRHgv1_YDf-WBRwV5SuOjuwkf4WDkRDiFe0cDKQIWaTJDH-OxCAyGC7DxLYGKIGdXfs7G1SUBF8HsLDg92SoFtZQv9uqr2AZTkYodyL0fzFJnxYZyOWGNlYfZrqHvfOWYHnZ17izo-FlFo8uQyeyjyr7JFb6eU4rVPizRuavKdZkfJfPqyeS2P_78gKF9agdUv_iod0geZCZZT5-RIJ9f01QrRcTk46rrsCKmMXx3-1I9l3EHHBsdftsmUsbt6a8K65vU4UWWqcEaePoVizsdxz1WNUmqD3SA3I7pb3M0mGHdd1XSvh9__BIw44TsJmFK41uG9EnfW1giCEPl0JRtiI68-ydcOe7nmJH2cdkiLHAUZWcCSwuxng8flhSF8HWuk20DJ0mzuxat6wbkXITmY_84aJ2rMSz2j1wt72wcuj0sSxILihKRAMDzoE0tBsjTm-GkniFrLRQkXjr2JiDW3x17BgBtO4Tl5y9ejI69eNMLe848BIR8aHFPIg4XvN1LlAR25FwfP1pEacYlZUJ8B8-KxUFGMVJRtgI-HP2uNsc_QzCD1JqAdwuYIKmzjjacmzerMG3-mOeZQpXu4EHCb-BYEVaCg_tjHEWQx5flLa-f_ovOWczpRhtDVBueS_0LFr4aogevsgbHnn5gouygxx7vZ6iCsOxHQwgf9ZlCp3cvwSnDfDIZLFjerrW5t3NIuQ0S21D1h2ATEiKTIJsWgBGhc1V1ZAzTqtEAU3nz8Jc=	2026-01-06 18:34:26.499415	0	43eab3ee-8fd1-400b-a402-76be5720273a	33c11459-e9b5-4080-adea-b249c302d99f
\.

--
-- Data for Name: hydra_oauth2_authentication_session; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_authentication_session (id, authenticated_at, subject, remember, nid, identity_provider_session_id, expires_at) FROM stdin;
ccae1dae-f745-4560-ab52-5b3c9987b814	2026-01-06 22:45:39	123e4567-e89b-12d3-a456-426614174000	f	33c11459-e9b5-4080-adea-b249c302d99f	\N	2026-02-05 22:45:39
\.


--
-- Data for Name: hydra_oauth2_code; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_code (signature, request_id, requested_at, client_id, scope, granted_scope, form_data, session_data, subject, active, requested_audience, granted_audience, challenge_id, nid, expires_at) FROM stdin;
kPKlyzLv1Gxtj1-I7Ld6HYllH-qf6P1RHjLBL7RZeEk	ac5acff52d5d4ed3a1ea97d65172de1f	2026-01-06 22:45:39.923099	657d0bb0-2314-4c8b-b649-1525af797d72	openid|offline|mediamtx:stream	openid|offline|mediamtx:stream	client_id=657d0bb0-2314-4c8b-b649-1525af797d72&redirect_uri=https%3A%2F%2Fsugarfever.ddns.net%2Fbff%2Fcallback&response_type=code&scope=openid+offline+mediamtx%3Astream	LZ4lWSpf7j99fULlMeNMh2d1_fHI6CDbWmrId8wZLFD2WZ6oBr7q-RnmK9Tymk31EhsIOViVZ1rBxQo5CVbrbveWUUz_c6B07opvYOk6MfzrgfmxtxW2CuSn4IsKtI6w8ckRGBic3YCfrnuH4ao_--puGoMt8BM3IJkHJs640GCaM2QHkTAH_9g1NFI8_IXsQl9nmEL3CoaU-dD8w2d1D5r3PVoIbO5TjWDpLauu3Xxs6OTsYFBFb_T9RHvkxX1EIbOGhY3ZZl7_MIluI-b77JfjkeunXKeguAi0cP5gbv0ASYjVpm0noa3aCb9eTwBmZhwra6sACv4Qv_5-KawSNz-SAdlhgCSLfR8M_IMhXoVkIA8YnV5c3KzXGlaxH2h0MJS-oYbZOYtR-WLcFygcVQn0LQ-CeuQbHwtmpf8dbzsJK8_JkU_ZJ2buwomYFfmOFYAHIxDhTvdcw9VwJU3glZMdCRKaYEBumyNJjxYym3uYzDy7S--cXJq7-Hm61O1M2OQo860CcEehJAWurGFxrSNb3k-Byeo5J-jE6EdJelBKuOIEBSGWl2FcKo0-W2dpk1bpr9bTyxvn7A_Nh1aFVB1pJ8eCMh-zUpeCBkqHlbUkHk5H47EMh_Bj9Czu_XZ__1gtDl9dmFNlJ7BznWqlfLD9-fYU-oKEfV1gZ-M1mN7t9IENwPU1uzSsE1MqU8dM077WijZkEUqoLMVGomN30HFdJ6yoObksts_vGNtpY0lII8xANa2XMIIjx5X0WRcnWaoB-bVqLqkmfgQm5iMTwf6-cG2DR-lvEXzILeJvNbCYKLVXuphY6sMIuGfQLr68eWyIYdDc2Hv9MMFuNXSFqSZ_-5x-rNt8kAuHOx0Yb4_qpf5kZUOUX47P87Fu-_wRg5dG4OKfRDyHxxQWJxAi3U68xZWhVLjbYDubQ7JFvIUNQtGDvF40uW7YIyfYqvmse_9voyjZIdsBJoIyFNIotBo7_TyQxbgdTnsEgmX0CVb_HC_mjlbLm32OK3lyZf3Pb1uq_lejT_yTyFWN1kHhXGDboZp4ROOsmZR70LEwwPbskgDY1qxBMXEVcbojBPhSvq1f1RIytRz54Kw83ASegGaT8ZzUjdn_hw-Y3PKNGtb3Z-SchVPrf53vyTWm9v7svjCOtxOdL7B-yqI2ZXsqsusIV5f8g3D3ijYlTFZGTeVTABlU0Hg=	123e4567-e89b-12d3-a456-426614174000	f			ac5acff52d5d4ed3a1ea97d65172de1f	33c11459-e9b5-4080-adea-b249c302d99f	2026-01-06 23:15:39.964
\.


--
-- Data for Name: hydra_oauth2_device_auth_codes; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_device_auth_codes (device_code_signature, user_code_signature, request_id, requested_at, client_id, scope, granted_scope, form_data, session_data, subject, device_code_active, user_code_state, requested_audience, granted_audience, challenge_id, expires_at, nid) FROM stdin;
\.


--
-- Data for Name: hydra_oauth2_flow; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_flow (login_challenge, login_verifier, login_csrf, subject, request_url, login_skip, client_id, requested_at, login_initialized_at, oidc_context, login_session_id, state, login_remember, login_remember_for, login_error, acr, login_authenticated_at, login_was_used, forced_subject_identifier, context, consent_challenge_id, consent_skip, consent_verifier, consent_csrf, consent_remember, consent_remember_for, consent_handled_at, consent_error, session_access_token, session_id_token, consent_was_used, nid, requested_scope, requested_at_audience, amr, granted_scope, granted_at_audience, login_extend_session_lifespan, identity_provider_session_id, device_challenge_id, device_code_request_id, device_verifier, device_csrf, device_was_used, device_handled_at, device_error) FROM stdin;
322294b23b594d5e938b41424e618cd1			123e4567-e89b-12d3-a456-426614174000	https://sugarfever.ddns.net/hydra/oauth2/auth?client_id=657d0bb0-2314-4c8b-b649-1525af797d72&response_type=code&scope=openid%20offline%20mediamtx:stream&state=9d09e216-8202-4661-820a-667195fb00a2&redirect_uri=https://sugarfever.ddns.net/bff/callback	f	657d0bb0-2314-4c8b-b649-1525af797d72	2026-01-06 22:45:33	\N	{}	ccae1dae-f745-4560-ab52-5b3c9987b814	6	f	0	{}		\N	t		null	ac5acff52d5d4ed3a1ea97d65172de1f	f			t	3600	2026-01-06 22:45:39.916868	{}	{"name": "leonardo", "avatar": ""}	null	t	33c11459-e9b5-4080-adea-b249c302d99f	["openid", "offline", "mediamtx:stream"]	[]	[]	["openid", "offline", "mediamtx:stream"]	[]	f	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: hydra_oauth2_jti_blacklist; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_jti_blacklist (signature, expires_at, nid) FROM stdin;
\.


--
-- Data for Name: hydra_oauth2_logout_request; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_logout_request (challenge, verifier, subject, sid, client_id, request_url, redir_url, was_used, accepted, rejected, rp_initiated, nid, expires_at, requested_at) FROM stdin;
\.


--
-- Data for Name: hydra_oauth2_obfuscated_authentication_session; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_obfuscated_authentication_session (subject, client_id, subject_obfuscated, nid) FROM stdin;
\.


--
-- Data for Name: hydra_oauth2_oidc; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_oidc (signature, request_id, requested_at, client_id, scope, granted_scope, form_data, session_data, subject, active, requested_audience, granted_audience, challenge_id, nid, expires_at) FROM stdin;
\.


--
-- Data for Name: hydra_oauth2_pkce; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_pkce (signature, request_id, requested_at, client_id, scope, granted_scope, form_data, session_data, subject, active, requested_audience, granted_audience, challenge_id, nid, expires_at) FROM stdin;
\.


--
-- Data for Name: hydra_oauth2_refresh; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_refresh (signature, request_id, requested_at, client_id, scope, granted_scope, form_data, session_data, subject, active, requested_audience, granted_audience, challenge_id, nid, expires_at, first_used_at, access_token_signature, used_times) FROM stdin;
GWPiEvTCw_7pB2nxvYx0_7HoxkUgr_PTu6_JZY6MAmQ	ac5acff52d5d4ed3a1ea97d65172de1f	2026-01-06 22:45:39.945588	657d0bb0-2314-4c8b-b649-1525af797d72	openid|offline|mediamtx:stream	openid|offline|mediamtx:stream	client_id=657d0bb0-2314-4c8b-b649-1525af797d72&grant_type=authorization_code	S49rrtYRSFjAQ9lugDHal5860gJhmvbM2InDBCDjVhO67_jvvQxnFFp3RQ6xBB3L9JB-7MYP0Wrd6Ygn9NlcgSFpgW71wQy9ZERuwkaXfSzVfjfCQDlTUyJiduaotmCfO9ijekt_Qk3F3MP1oNc15kEXkERmzzAMVvoGdd60O6gfhi-ZXFdzNywCTUv9Odd3mruHr74spnj4XmJzu5BslOviswD_e1WNrQykpukV4nXtSxk1taZLWOsdMIaQt1381j-XF7_Xi2pfKnr8tSJuOAAtMti9tETLoSRkVsrqLKn1IfYgxlA4pNbBRxKUrSaqKFozFh8AUXfRSSbCnoBa9BkzHvJWlHSlqtJ0rNnfArAkMsYSDfwBL3YN0A-BmRWbNNKeagFZSGJQKPbndvnEnq-aq8NMiCTG86XZ1-aYe45KAxGoByd9_8jvn-M8ge5baC6K3XhI6KCmp5rLWTtsyzFP7OM_T0lwtXXOwt6nYlM-VgU27YlUAdKX8TbmaBZ-taLKQ5SsMK1nSGdmwlzWgQZljuluCWo5IsFyyHibdHml-wh1xmL_hx7vAWeByj6XkvNaMDuS99k9d9tu8fmvmulQ4whureKvGLzVg4OuwGx7HN9nL2xUm3ErGOnJQxGhFiBOE8mzJswlIc-nXGbrttLtybBVSYmJRLcAD-uLiBSvQctxuMuUT8QmWd4eiJMPK5eWs0vA8gyu2cvvo88685WVGG-g9qK33SShfH7lGOiPSYw-H82jAOpg4uo7LmIbfjzsuQto0plZZ-DHyybqcyCfhFvhC0h_Wo21On0UAs3YFVAEEOlmQwJ6JI7cng-1FYBJK_6OW97R-4_8eMc0FJXllsTx2QRsTcm3kYrypNX8CfNEmdFUqn76iWXdKCxE6Ng2iEKXChvKpAB-EiqWa-6Z8-FyNoxCfkliNbiFUq7csB7bQCdN5Drq_6HDpDQWVQ6CwId0RaEz2dd_DEsHf-obbnmBBuAiBBaBP8jtczdYCIbdEeevwXDFbxNw_XF8IpTGTKffKwdjC-Ug665PBBEZvLfROVQQ-yVC-TKtsaoLHbYgeMnE6SGkirvHZxeAgh56v0P5KpQkaAXLOGKIANy7dzDoaT_trfJpUQU0pdFQekop8lOpQsjVITbY_6BKNsw7kJxw-yg4oyC8ZYJ6jAdS_BzALbFSE-q_IlirurW_1LLEp_E7l4xUrHcbuJ9QBWyZIuzK89axKm8bIhItUo8Y6M4re0tJvQDs0E3gN9ImAQiO9wYk6cDgj5iyVgt6KVb0ZhaPTdX1gSq2soE6jvCeQw==	123e4567-e89b-12d3-a456-426614174000	t			ac5acff52d5d4ed3a1ea97d65172de1f	33c11459-e9b5-4080-adea-b249c302d99f	2026-02-05 22:45:40	\N	cf8ee2dd49f21131388cf12b255ed9871b6d361b1109d7eb6c1d6227b1806d412ef46fafd306a5804f627b0a7237166b	\N
\.


--
-- Data for Name: hydra_oauth2_trusted_jwt_bearer_issuer; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.hydra_oauth2_trusted_jwt_bearer_issuer (id, issuer, subject, scope, key_set, key_id, created_at, expires_at, nid, allow_any_subject) FROM stdin;
\.


--
-- Data for Name: networks; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.networks (id, created_at, updated_at) FROM stdin;
33c11459-e9b5-4080-adea-b249c302d99f	2013-10-07 08:23:19	2013-10-07 08:23:19
\.


--
-- Data for Name: schema_migration; Type: TABLE DATA; Schema: hydra; Owner: tcero
--

COPY hydra.schema_migration (version, version_self) FROM stdin;
20150101000001000000	0
20190100000001000000	0
20190100000002000000	0
20190100000003000000	0
20190100000004000000	0
20190100000005000000	0
20190100000006000000	0
20190100000007000000	0
20190100000008000000	0
20190100000009000000	0
20190100000010000000	0
20190100000011000000	0
20190100000012000000	0
20190100000013000000	0
20190100000014000000	0
20190200000001000000	0
20190200000002000000	0
20190200000003000000	0
20190200000004000000	0
20190300000001000000	0
20190300000002000000	0
20190300000003000000	0
20190300000004000000	0
20190300000005000000	0
20190300000006000000	0
20190300000007000000	0
20190300000008000000	0
20190300000009000000	0
20190300000010000000	0
20190300000011000000	0
20190300000012000000	0
20190300000013000000	0
20190300000014000000	0
20190400000001000000	0
20190400000002000000	0
20190400000003000000	0
20190400000004000000	0
20190400000005000000	0
20190400000006000000	0
20190400000007000000	0
20190400000008000000	0
20190400000009000000	0
20190400000010000000	0
20190400000011000000	0
20200521071434000000	0
20200527215731000000	0
20200527215732000000	0
20200819163013000000	0
20200913192340000000	0
20201110104000000000	0
20201116133000000000	0
20210928155900000000	0
20210928175900000000	0
20211004110001000000	0
20211004110002000000	0
20211004110003000000	0
20211011000001000000	0
20211011000002000000	0
20211011000003000000	0
20211019000001000000	0
20211019000001000001	0
20211019000001000002	0
20211019000001000003	0
20211019000001000004	0
20211019000001000005	0
20211019000001000006	0
20211019000001000007	0
20211019000001000008	0
20211019000001000009	0
20211019000001000010	0
20211019000001000011	0
20211019000001000012	0
20211019000001000013	0
20211019000001000014	0
20211019000001000015	0
20211019000001000016	0
20211019000001000017	0
20211019000001000018	0
20211019000001000019	0
20211019000001000020	0
20211019000001000021	0
20211019000001000022	0
20211019000001000023	0
20211019000001000024	0
20211019000001000025	0
20211019000001000026	0
20211019000001000027	0
20211019000001000028	0
20211019000001000029	0
20211019000001000030	0
20211019000001000031	0
20211019000001000032	0
20211019000001000033	0
20211019000001000034	0
20211019000001000035	0
20211019000001000036	0
20211019000001000037	0
20211019000001000038	0
20211019000001000039	0
20211226155900000000	0
20211226156000000000	0
20220210000001000000	0
20220210000001000001	0
20220210000001000002	0
20220210000001000003	0
20220210000001000004	0
20220210000001000005	0
20220210000001000006	0
20220210000001000007	0
20220210000001000008	0
20220210000001000009	0
20220210000001000010	0
20220210000001000011	0
20220210000001000012	0
20220210000001000013	0
20220210000001000014	0
20220210000001000015	0
20220210000001000016	0
20220210000001000017	0
20220210000001000018	0
20220210000001000019	0
20220210000001000020	0
20220210000001000021	0
20220210000001000022	0
20220210000001000023	0
20220210000001000024	0
20220210000001000025	0
20220210000001000026	0
20220210000001000027	0
20220210000001000028	0
20220210000001000029	0
20220210000001000030	0
20220210000001000031	0
20220210000001000032	0
20220210000001000033	0
20220210000001000034	0
20220210000001000035	0
20220210000001000036	0
20220210000001000037	0
20220210000001000038	0
20220210000001000039	0
20220210000001000040	0
20220210000001000041	0
20220210000001000042	0
20220210000001000043	0
20220210000001000044	0
20220210000001000045	0
20220210000001000046	0
20220210000001000047	0
20220210000001000048	0
20220210000001000049	0
20220210000001000050	0
20220210000001000051	0
20220210000001000052	0
20220210000001000053	0
20220210000001000054	0
20220210000001000055	0
20220210000001000056	0
20220210000001000057	0
20220210000001000058	0
20220210000001000059	0
20220210000001000060	0
20220210000001000061	0
20220210000001000062	0
20220210000001000063	0
20220210000001000064	0
20220210000001000065	0
20220210000001000066	0
20220210000001000067	0
20220210000001000068	0
20220210000001000069	0
20220210000001000070	0
20220210000001000071	0
20220210000001000072	0
20220210000001000073	0
20220210000001000074	0
20220210000001000075	0
20220210000001000076	0
20220210000001000077	0
20220210000001000078	0
20220210000001000079	0
20220328111500000000	0
20220513000001000000	0
20220513000001000001	0
20220513000001000002	0
20220513000001000003	0
20220513000001000004	0
20220513000001000005	0
20220513000001000006	0
20220513000001000007	0
20220513000001000008	0
20220513000001000009	0
20220513000001000010	0
20220916000010000000	0
20221109000010000000	0
20221109000010000001	0
20230220000000000000	0
20230228000010000001	0
20230313112801000001	0
20230512112801000001	0
20230606112801000001	0
20230809122501000001	0
20230908104443000000	0
20230908104443000001	0
20240104181300000001	0
20240129174410000001	0
20240403121110000001	0
20240612222110000001	0
20240916105610000001	0
20241012144910000001	0
20241014121000000000	0
20241129111700000000	0
20241609000001000000	0
20250513132142000000	0
20250520000001000000	0
20250523000001000000	0
20250610132310000001	0
20251030112809000000	0
\.


--
-- Name: hydra_client_pk_seq; Type: SEQUENCE SET; Schema: hydra; Owner: tcero
--

SELECT pg_catalog.setval('hydra.hydra_client_pk_seq', 1, true);


--
-- Name: hydra_jwk_pk_seq; Type: SEQUENCE SET; Schema: hydra; Owner: tcero
--

SELECT pg_catalog.setval('hydra.hydra_jwk_pk_seq', 1, false);


--
-- Name: hydra_client hydra_client_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_client
    ADD CONSTRAINT hydra_client_pkey PRIMARY KEY (id, nid);


--
-- Name: hydra_jwk hydra_jwk_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_jwk
    ADD CONSTRAINT hydra_jwk_pkey PRIMARY KEY (pk);


--
-- Name: hydra_oauth2_access hydra_oauth2_access_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_access
    ADD CONSTRAINT hydra_oauth2_access_pkey PRIMARY KEY (signature);


--
-- Name: hydra_oauth2_authentication_session hydra_oauth2_authentication_session_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_authentication_session
    ADD CONSTRAINT hydra_oauth2_authentication_session_pkey PRIMARY KEY (id);


--
-- Name: hydra_oauth2_code hydra_oauth2_code_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_code
    ADD CONSTRAINT hydra_oauth2_code_pkey PRIMARY KEY (signature);


--
-- Name: hydra_oauth2_device_auth_codes hydra_oauth2_device_auth_codes_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_device_auth_codes
    ADD CONSTRAINT hydra_oauth2_device_auth_codes_pkey PRIMARY KEY (device_code_signature, nid);


--
-- Name: hydra_oauth2_flow hydra_oauth2_flow_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_flow
    ADD CONSTRAINT hydra_oauth2_flow_pkey PRIMARY KEY (login_challenge);


--
-- Name: hydra_oauth2_jti_blacklist hydra_oauth2_jti_blacklist_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_jti_blacklist
    ADD CONSTRAINT hydra_oauth2_jti_blacklist_pkey PRIMARY KEY (signature, nid);


--
-- Name: hydra_oauth2_logout_request hydra_oauth2_logout_request_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_logout_request
    ADD CONSTRAINT hydra_oauth2_logout_request_pkey PRIMARY KEY (challenge);


--
-- Name: hydra_oauth2_obfuscated_authentication_session hydra_oauth2_obfuscated_authentication_session_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_obfuscated_authentication_session
    ADD CONSTRAINT hydra_oauth2_obfuscated_authentication_session_pkey PRIMARY KEY (subject, client_id, nid);


--
-- Name: hydra_oauth2_oidc hydra_oauth2_oidc_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_oidc
    ADD CONSTRAINT hydra_oauth2_oidc_pkey PRIMARY KEY (signature);


--
-- Name: hydra_oauth2_pkce hydra_oauth2_pkce_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_pkce
    ADD CONSTRAINT hydra_oauth2_pkce_pkey PRIMARY KEY (signature);


--
-- Name: hydra_oauth2_refresh hydra_oauth2_refresh_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_refresh
    ADD CONSTRAINT hydra_oauth2_refresh_pkey PRIMARY KEY (signature);


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer hydra_oauth2_trusted_jwt_bearer_issue_issuer_subject_key_id_key; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_trusted_jwt_bearer_issuer
    ADD CONSTRAINT hydra_oauth2_trusted_jwt_bearer_issue_issuer_subject_key_id_key UNIQUE (issuer, subject, key_id, nid);


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer hydra_oauth2_trusted_jwt_bearer_issuer_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_trusted_jwt_bearer_issuer
    ADD CONSTRAINT hydra_oauth2_trusted_jwt_bearer_issuer_pkey PRIMARY KEY (id);


--
-- Name: networks networks_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.networks
    ADD CONSTRAINT networks_pkey PRIMARY KEY (id);


--
-- Name: hydra_client_idx_id_uq; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_client_idx_id_uq ON hydra.hydra_client USING btree (id, nid);


--
-- Name: hydra_jwk_nid_sid_created_at_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_jwk_nid_sid_created_at_idx ON hydra.hydra_jwk USING btree (nid, sid, created_at);


--
-- Name: hydra_jwk_nid_sid_kid_created_at_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_jwk_nid_sid_kid_created_at_idx ON hydra.hydra_jwk USING btree (nid, sid, kid, created_at);


--
-- Name: hydra_jwk_sid_kid_nid_key; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_jwk_sid_kid_nid_key ON hydra.hydra_jwk USING btree (sid, kid, nid);


--
-- Name: hydra_oauth2_access_challenge_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_access_challenge_id_idx ON hydra.hydra_oauth2_access USING btree (challenge_id);


--
-- Name: hydra_oauth2_access_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_access_client_id_idx ON hydra.hydra_oauth2_access USING btree (client_id, nid);


--
-- Name: hydra_oauth2_access_request_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_access_request_id_idx ON hydra.hydra_oauth2_access USING btree (request_id, nid);


--
-- Name: hydra_oauth2_access_requested_at_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_access_requested_at_idx ON hydra.hydra_oauth2_access USING btree (requested_at, nid);


--
-- Name: hydra_oauth2_authentication_session_sub_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_authentication_session_sub_idx ON hydra.hydra_oauth2_authentication_session USING btree (subject, nid);


--
-- Name: hydra_oauth2_code_challenge_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_code_challenge_id_idx ON hydra.hydra_oauth2_code USING btree (challenge_id, nid);


--
-- Name: hydra_oauth2_code_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_code_client_id_idx ON hydra.hydra_oauth2_code USING btree (client_id, nid);


--
-- Name: hydra_oauth2_device_auth_codes_challenge_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_device_auth_codes_challenge_id_idx ON hydra.hydra_oauth2_device_auth_codes USING btree (challenge_id);


--
-- Name: hydra_oauth2_device_auth_codes_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_device_auth_codes_client_id_idx ON hydra.hydra_oauth2_device_auth_codes USING btree (client_id, nid);


--
-- Name: hydra_oauth2_device_auth_codes_request_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_device_auth_codes_request_id_idx ON hydra.hydra_oauth2_device_auth_codes USING btree (request_id, nid);


--
-- Name: hydra_oauth2_device_auth_codes_user_code_signature_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_oauth2_device_auth_codes_user_code_signature_idx ON hydra.hydra_oauth2_device_auth_codes USING btree (nid, user_code_signature);


--
-- Name: hydra_oauth2_flow_cid_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_flow_cid_idx ON hydra.hydra_oauth2_flow USING btree (client_id, nid);


--
-- Name: hydra_oauth2_flow_client_id_subject_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_flow_client_id_subject_idx ON hydra.hydra_oauth2_flow USING btree (client_id, nid, subject);


--
-- Name: hydra_oauth2_flow_consent_challenge_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_oauth2_flow_consent_challenge_idx ON hydra.hydra_oauth2_flow USING btree (consent_challenge_id);


--
-- Name: hydra_oauth2_flow_device_challenge_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_oauth2_flow_device_challenge_idx ON hydra.hydra_oauth2_flow USING btree (device_challenge_id);


--
-- Name: hydra_oauth2_flow_login_session_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_flow_login_session_id_idx ON hydra.hydra_oauth2_flow USING btree (login_session_id, nid);


--
-- Name: hydra_oauth2_flow_previous_consents_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_flow_previous_consents_idx ON hydra.hydra_oauth2_flow USING btree (subject, client_id, nid, consent_skip, consent_error, consent_remember);


--
-- Name: hydra_oauth2_flow_sub_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_flow_sub_idx ON hydra.hydra_oauth2_flow USING btree (subject, nid);


--
-- Name: hydra_oauth2_jti_blacklist_expires_at_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_jti_blacklist_expires_at_idx ON hydra.hydra_oauth2_jti_blacklist USING btree (expires_at, nid);


--
-- Name: hydra_oauth2_logout_request_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_logout_request_client_id_idx ON hydra.hydra_oauth2_logout_request USING btree (client_id, nid);


--
-- Name: hydra_oauth2_logout_request_veri_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_oauth2_logout_request_veri_idx ON hydra.hydra_oauth2_logout_request USING btree (verifier);


--
-- Name: hydra_oauth2_obfuscated_authentication_session_so_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_oauth2_obfuscated_authentication_session_so_idx ON hydra.hydra_oauth2_obfuscated_authentication_session USING btree (client_id, subject_obfuscated, nid);


--
-- Name: hydra_oauth2_oidc_challenge_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_oidc_challenge_id_idx ON hydra.hydra_oauth2_oidc USING btree (challenge_id);


--
-- Name: hydra_oauth2_oidc_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_oidc_client_id_idx ON hydra.hydra_oauth2_oidc USING btree (client_id, nid);


--
-- Name: hydra_oauth2_pkce_challenge_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_pkce_challenge_id_idx ON hydra.hydra_oauth2_pkce USING btree (challenge_id);


--
-- Name: hydra_oauth2_pkce_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_pkce_client_id_idx ON hydra.hydra_oauth2_pkce USING btree (client_id, nid);


--
-- Name: hydra_oauth2_refresh_challenge_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_refresh_challenge_id_idx ON hydra.hydra_oauth2_refresh USING btree (challenge_id);


--
-- Name: hydra_oauth2_refresh_client_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_refresh_client_id_idx ON hydra.hydra_oauth2_refresh USING btree (client_id, nid);


--
-- Name: hydra_oauth2_refresh_request_id_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_refresh_request_id_idx ON hydra.hydra_oauth2_refresh USING btree (request_id);


--
-- Name: hydra_oauth2_refresh_requested_at_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_refresh_requested_at_idx ON hydra.hydra_oauth2_refresh USING btree (nid, requested_at);


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer_expires_at_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_trusted_jwt_bearer_issuer_expires_at_idx ON hydra.hydra_oauth2_trusted_jwt_bearer_issuer USING btree (expires_at);


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer_nid_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX hydra_oauth2_trusted_jwt_bearer_issuer_nid_idx ON hydra.hydra_oauth2_trusted_jwt_bearer_issuer USING btree (id, nid);


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer_nid_uq_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX hydra_oauth2_trusted_jwt_bearer_issuer_nid_uq_idx ON hydra.hydra_oauth2_trusted_jwt_bearer_issuer USING btree (nid, key_id, issuer, subject);


--
-- Name: schema_migration_version_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE UNIQUE INDEX schema_migration_version_idx ON hydra.schema_migration USING btree (version);


--
-- Name: schema_migration_version_self_idx; Type: INDEX; Schema: hydra; Owner: tcero
--

CREATE INDEX schema_migration_version_self_idx ON hydra.schema_migration USING btree (version_self);


--
-- Name: hydra_client hydra_client_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_client
    ADD CONSTRAINT hydra_client_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_jwk hydra_jwk_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_jwk
    ADD CONSTRAINT hydra_jwk_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_access hydra_oauth2_access_challenge_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_access
    ADD CONSTRAINT hydra_oauth2_access_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES hydra.hydra_oauth2_flow(consent_challenge_id) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_access hydra_oauth2_access_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_access
    ADD CONSTRAINT hydra_oauth2_access_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_access hydra_oauth2_access_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_access
    ADD CONSTRAINT hydra_oauth2_access_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_authentication_session hydra_oauth2_authentication_session_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_authentication_session
    ADD CONSTRAINT hydra_oauth2_authentication_session_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_code hydra_oauth2_code_challenge_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_code
    ADD CONSTRAINT hydra_oauth2_code_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES hydra.hydra_oauth2_flow(consent_challenge_id) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_code hydra_oauth2_code_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_code
    ADD CONSTRAINT hydra_oauth2_code_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_code hydra_oauth2_code_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_code
    ADD CONSTRAINT hydra_oauth2_code_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_device_auth_codes hydra_oauth2_device_auth_codes_challenge_id_fkey; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_device_auth_codes
    ADD CONSTRAINT hydra_oauth2_device_auth_codes_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES hydra.hydra_oauth2_flow(consent_challenge_id) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_device_auth_codes hydra_oauth2_device_auth_codes_client_id_nid_fkey; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_device_auth_codes
    ADD CONSTRAINT hydra_oauth2_device_auth_codes_client_id_nid_fkey FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_device_auth_codes hydra_oauth2_device_auth_codes_nid_fkey; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_device_auth_codes
    ADD CONSTRAINT hydra_oauth2_device_auth_codes_nid_fkey FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_flow hydra_oauth2_flow_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_flow
    ADD CONSTRAINT hydra_oauth2_flow_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_flow hydra_oauth2_flow_login_session_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_flow
    ADD CONSTRAINT hydra_oauth2_flow_login_session_id_fk FOREIGN KEY (login_session_id) REFERENCES hydra.hydra_oauth2_authentication_session(id) ON DELETE SET NULL;


--
-- Name: hydra_oauth2_flow hydra_oauth2_flow_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_flow
    ADD CONSTRAINT hydra_oauth2_flow_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_jti_blacklist hydra_oauth2_jti_blacklist_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_jti_blacklist
    ADD CONSTRAINT hydra_oauth2_jti_blacklist_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_logout_request hydra_oauth2_logout_request_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_logout_request
    ADD CONSTRAINT hydra_oauth2_logout_request_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_logout_request hydra_oauth2_logout_request_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_logout_request
    ADD CONSTRAINT hydra_oauth2_logout_request_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_obfuscated_authentication_session hydra_oauth2_obfuscated_authentication_session_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_obfuscated_authentication_session
    ADD CONSTRAINT hydra_oauth2_obfuscated_authentication_session_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_obfuscated_authentication_session hydra_oauth2_obfuscated_authentication_session_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_obfuscated_authentication_session
    ADD CONSTRAINT hydra_oauth2_obfuscated_authentication_session_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_oidc hydra_oauth2_oidc_challenge_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_oidc
    ADD CONSTRAINT hydra_oauth2_oidc_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES hydra.hydra_oauth2_flow(consent_challenge_id) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_oidc hydra_oauth2_oidc_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_oidc
    ADD CONSTRAINT hydra_oauth2_oidc_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_oidc hydra_oauth2_oidc_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_oidc
    ADD CONSTRAINT hydra_oauth2_oidc_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_pkce hydra_oauth2_pkce_challenge_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_pkce
    ADD CONSTRAINT hydra_oauth2_pkce_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES hydra.hydra_oauth2_flow(consent_challenge_id) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_pkce hydra_oauth2_pkce_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_pkce
    ADD CONSTRAINT hydra_oauth2_pkce_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_pkce hydra_oauth2_pkce_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_pkce
    ADD CONSTRAINT hydra_oauth2_pkce_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_refresh hydra_oauth2_refresh_challenge_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_refresh
    ADD CONSTRAINT hydra_oauth2_refresh_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES hydra.hydra_oauth2_flow(consent_challenge_id) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_refresh hydra_oauth2_refresh_client_id_fk; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_refresh
    ADD CONSTRAINT hydra_oauth2_refresh_client_id_fk FOREIGN KEY (client_id, nid) REFERENCES hydra.hydra_client(id, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_refresh hydra_oauth2_refresh_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_refresh
    ADD CONSTRAINT hydra_oauth2_refresh_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer hydra_oauth2_trusted_jwt_bearer_issuer_key_set_fkey; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_trusted_jwt_bearer_issuer
    ADD CONSTRAINT hydra_oauth2_trusted_jwt_bearer_issuer_key_set_fkey FOREIGN KEY (key_set, key_id, nid) REFERENCES hydra.hydra_jwk(sid, kid, nid) ON DELETE CASCADE;


--
-- Name: hydra_oauth2_trusted_jwt_bearer_issuer hydra_oauth2_trusted_jwt_bearer_issuer_nid_fk_idx; Type: FK CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_oauth2_trusted_jwt_bearer_issuer
    ADD CONSTRAINT hydra_oauth2_trusted_jwt_bearer_issuer_nid_fk_idx FOREIGN KEY (nid) REFERENCES hydra.networks(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

