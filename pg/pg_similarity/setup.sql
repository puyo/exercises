CREATE EXTENSION pg_trgm;

CREATE INDEX hash_idx ON images USING gin(hash gin_trgm_ops);

CREATE OR REPLACE VIEW image_lexeme AS
SELECT image_hash FROM ts_stat('SELECT to_tsvector('simple', images.hash)
FROM images');
