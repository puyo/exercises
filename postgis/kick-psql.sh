cat << EOF | psql
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'location_based_game_server_dev'
AND pid <> pg_backend_pid();
EOF

echo "DONE"
