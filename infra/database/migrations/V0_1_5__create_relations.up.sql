ALTER TABLE marketplace.users_posts DROP COLUMN id_user;
ALTER TABLE marketplace.users_posts ADD COLUMN id_users UUID;