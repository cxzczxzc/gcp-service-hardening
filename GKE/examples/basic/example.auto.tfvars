project_id                = "terratest-modules127c1f2e744f8"
cluster_name              = "terratest-gke"
region                    = "us-east4"
zone                      = "us-east4-c"
network                   = "nonprod-shared-trust"
subnet                    = "terratest-modules127c1f2e744f8"
secondary_subnet_pods     = "terratest-modules127c1f2e744f8-secondary-pods"
secondary_subnet_services = "terratest-modules127c1f2e744f8-secondary-services"
//service_account           = "devx-lz-gcp-tfc-svc@markusd-k8s-devd1f61a18a389e01.iam.gserviceaccount.com"
node_pools = [
  {
    name               = "default-node-pool"
    machine_type       = "e2-medium"
    node_locations     = "us-east4-c"
    min_count          = 1
    max_count          = 3
    local_ssd_count    = 0
    disk_size_gb       = 20
    disk_type          = "pd-standard"
    image_type         = "COS_CONTAINERD"
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    initial_node_count = 1
    tags               = "ssh-in"
    enable_secure_boot = true
  },
]
