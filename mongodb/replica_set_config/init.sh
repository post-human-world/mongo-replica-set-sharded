#!/bin/bash
# run this manually
mongosh -f /config/nodes_cfg.mongodb
sleep 10
mongosh -f /config/superuser.mongodb