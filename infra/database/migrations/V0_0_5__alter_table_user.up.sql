alter table marketplace.users drop column video_code;
alter table marketplace.users add column roles text;
update marketplace.users set roles = 'streamer' where user_id='123e4567-e89b-12d3-a456-426614174000';