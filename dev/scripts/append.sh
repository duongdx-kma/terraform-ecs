#!/bin/bash

cat >> prod.tf  << EOF

module "auto-scaling" {
  source      = "../modules/auto-scaling"
  ecs_cluster = module.ecs.ecs_cluster
  ecs_service = module.ecs.ecs_service
}
EOF
