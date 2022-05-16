CREATE EXTENSION pg_trgm;

\set total 10000

SELECT :total AS number_of_images;

DROP TABLE IF EXISTS images;

CREATE TABLE images (
  id integer,
  hash text,
  bytes text
);

CREATE INDEX hash_idx_gist ON images USING gist(bytes gist_trgm_ops);

-- ----------------------------------------------------------------------

\timing on

INSERT
INTO images
SELECT id, hash, regexp_replace(hash, '(.)', '\1 ', 'g') AS bytes
FROM (
  SELECT
    id,
    (
      md5(random()::text) ||
      md5(random()::text) ||
      md5(random()::text) ||
      md5(random()::text) ||
      md5(random()::text) ||
      md5(random()::text) ||
      md5(random()::text) ||
      md5(random()::text)
    ) AS hash
  FROM generate_series(1, :total) id
) AS in1;

\echo "Adding index..."


\echo "Querying for similarity..."

\echo "10 records"

SELECT id, hash, similarity(regexp_replace('ef18e30c00b2164cd4c350d13a554f6f068db5926bff9c790f9b6648e1543f4d80ad97339559e646e7729fa0c15436702122bd05e93e613114b7c07b9ec532260081d356ebab6069a6668c670e7b00451dabdc4c964510dba6c0851fcba497daa2d514a1c7abfc277e56c6e0022adcdeec620fdd4052dd51d4e37a1f26cd6546', '(.)', '\1', 'g'), images.bytes) AS similarity FROM images LIMIT 10;

-- \echo "100 records"

-- SELECT id, hash, similarity(regexp_replace('ef18e30c00b2164cd4c350d13a554f6f068db5926bff9c790f9b6648e1543f4d80ad97339559e646e7729fa0c15436702122bd05e93e613114b7c07b9ec532260081d356ebab6069a6668c670e7b00451dabdc4c964510dba6c0851fcba497daa2d514a1c7abfc277e56c6e0022adcdeec620fdd4052dd51d4e37a1f26cd6546', '(.)', '\1', 'g'), images.bytes) AS similarity FROM images LIMIT 100;

-- \echo "1000 records"

-- SELECT id, hash, similarity('ef18e30c00b2164cd4c350d13a554f6f068db5926bff9c790f9b6648e1543f4d80ad97339559e646e7729fa0c15436702122bd05e93e613114b7c07b9ec532260081d356ebab6069a6668c670e7b00451dabdc4c964510dba6c0851fcba497daa2d514a1c7abfc277e56c6e0022adcdeec620fdd4052dd51d4e37a1f26cd6546', images.bytes) AS similarity FROM images LIMIT 1000;

-- \echo "10000 records"

-- SELECT id, hash, similarity('ef18e30c00b2164cd4c350d13a554f6f068db5926bff9c790f9b6648e1543f4d80ad97339559e646e7729fa0c15436702122bd05e93e613114b7c07b9ec532260081d356ebab6069a6668c670e7b00451dabdc4c964510dba6c0851fcba497daa2d514a1c7abfc277e56c6e0022adcdeec620fdd4052dd51d4e37a1f26cd6546', images.bytes) AS similarity FROM images LIMIT 10000;

-- \echo "All records"

SELECT id, hash, similarity(regexp_replace('ef18e30c00b2164cd4c350d13a554f6f068db5926bff9c790f9b6648e1543f4d80ad97339559e646e7729fa0c15436702122bd05e93e613114b7c07b9ec532260081d356ebab6069a6668c670e7b00451dabdc4c964510dba6c0851fcba497daa2d514a1c7abfc277e56c6e0022adcdeec620fdd4052dd51d4e37a1f26cd6546', '(.)', '\1 ', 'g'), images.bytes) AS similarity FROM images;
