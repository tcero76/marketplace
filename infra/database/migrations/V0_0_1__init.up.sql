--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Debian 14.18-1.pgdg120+1)
-- Dumped by pg_dump version 14.18 (Debian 14.18-1.pgdg120+1)

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
-- Name: hydra; Type: SCHEMA; Schema: -; Owner: tcero
--

CREATE SCHEMA IF NOT EXISTS hydra;


ALTER SCHEMA hydra OWNER TO tcero;

--
-- Name: marketplace; Type: SCHEMA; Schema: -; Owner: tcero
--

CREATE SCHEMA IF NOT EXISTS marketplace;


ALTER SCHEMA marketplace OWNER TO tcero;

--
-- Name: scrap; Type: SCHEMA; Schema: -; Owner: tcero
--

CREATE SCHEMA IF NOT EXISTS scrap;


ALTER SCHEMA scrap OWNER TO tcero;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hydra_client; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE IF NOT EXISTS hydra.hydra_client (
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
    skip_logout_consent boolean
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


ALTER TABLE hydra.hydra_client_pk_seq OWNER TO tcero;

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


ALTER TABLE hydra.hydra_jwk_pk_seq OWNER TO tcero;

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
    identity_provider_session_id character varying(40)
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
    access_token_signature character varying(255) DEFAULT NULL::character varying
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
-- Name: schema_migrations; Type: TABLE; Schema: hydra; Owner: tcero
--

CREATE TABLE hydra.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE hydra.schema_migrations OWNER TO tcero;

--
-- Name: productos; Type: TABLE; Schema: marketplace; Owner: tcero
--

CREATE TABLE marketplace.productos (
    id integer,
    text text,
    author character varying(125),
    tags text,
    job_id uuid,
    processed_at timestamp without time zone
);


ALTER TABLE marketplace.productos OWNER TO tcero;

--
-- Name: items; Type: TABLE; Schema: scrap; Owner: tcero
--

CREATE TABLE scrap.items (
    id integer NOT NULL,
    text text,
    author character varying(125),
    tags text,
    job_id uuid,
    processed_at timestamp without time zone DEFAULT now()
);


ALTER TABLE scrap.items OWNER TO tcero;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: scrap; Owner: tcero
--

CREATE SEQUENCE scrap.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scrap.items_id_seq OWNER TO tcero;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: scrap; Owner: tcero
--

ALTER SEQUENCE scrap.items_id_seq OWNED BY scrap.items.id;


--
-- Name: hydra_client pk_deprecated; Type: DEFAULT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_client ALTER COLUMN pk_deprecated SET DEFAULT nextval('hydra.hydra_client_pk_seq'::regclass);


--
-- Name: hydra_jwk pk_deprecated; Type: DEFAULT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.hydra_jwk ALTER COLUMN pk_deprecated SET DEFAULT nextval('hydra.hydra_jwk_pk_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: scrap; Owner: tcero
--

ALTER TABLE ONLY scrap.items ALTER COLUMN id SET DEFAULT nextval('scrap.items_id_seq'::regclass);


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
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: hydra; Owner: tcero
--

ALTER TABLE ONLY hydra.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: scrap; Owner: tcero
--

ALTER TABLE ONLY scrap.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


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

