#!/bin/bash

cat >> prod.tf  << EOF

module "auto-scaling" {
  source           = "../modules/auto-scaling"
  ecs_cluster_name = module.ecs.ecs_cluster.name
  ecs_service_name = module.ecs.ecs_service[0].name
}
EOF
