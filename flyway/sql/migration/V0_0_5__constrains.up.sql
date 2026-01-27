ALTER TABLE scrap.explore DROP CONSTRAINT explore_pkey;
ALTER TABLE scrap.explore ADD CONSTRAINT explore_pkey PRIMARY KEY (id,id_job);

ALTER TABLE scrap.modelos DROP CONSTRAINT modelos_pkey;
ALTER TABLE scrap.modelos ADD CONSTRAINT modelos_pkey PRIMARY KEY (id,id_job);

ALTER TABLE scrap.posts DROP CONSTRAINT posts_pkey;
ALTER TABLE scrap.posts ADD CONSTRAINT posts_pkey PRIMARY KEY (id,id_job);

ALTER TABLE marketplace.modelos DROP CONSTRAINT modelos_pkey;
ALTER TABLE marketplace.modelos ADD CONSTRAINT modelos_pkey PRIMARY KEY (id);

ALTER TABLE marketplace.posts DROP CONSTRAINT posts_pkey;
ALTER TABLE marketplace.posts ADD CONSTRAINT posts_pkey PRIMARY KEY (id);