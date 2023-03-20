region = "us-central1"
zone   = "us-central1-c"
# Defined in TF cloud: project_id
# Controlled by DevX: project

org_id          = "32136287506"
service_account = "cribl-stream-org"
svc_pub_key     = "test-cribl.pem"

admin_pipeline      = "org-logs-admin"
admin_log_filter    = "logName:cloudaudit OR logName:externalaudit" 
admin_log_excl_filter = "log_id(cloudaudit.googleapis.com/data_access)"

network_pipeline   = "org-logs-network"
network_log_filter = "logName:vpc_flows OR logName:firewall"

prod_pipeline = "org-logs-prod"

nonprod_pipeline = "org-logs-nonprod"

labels = { "owner" = "gromovd"
  "integration"    = "observability"
  "classification" = "internal_use_only"
  "costcenter"     = "le0500-81387"
  "department"     = "technology"
  "projectname"    = "observability_platform"
  "generator"      = "terraform"
  "repository"     = "terraform-google-dnb_gcp_central_logging"
  "drn"            = "3320"
}

sink_project_ids = [
  # nonprod project_id(s)
  # drn: 2163
  "nprd-dap-mvp-project9f56eb3b51",
  "nprd-prime-migrationd56a4bb810",
  "nprd-prime-dev-project0b60ce35",
  "nprd-prime-qa-project54d88eb95",
  
  # drn: 2443
  "nprd-midas-dev-project27d99114",
  "nprd-midas-cmposer-dev-project",
  "nprd-midas-qa-projecte488c81e",
  "nprd-midas-cmposer-qa-project2",
  "nprd-midas-dbrick-qa-project53",
  
  # drn: 2544
  "nprd-ustc-dev-projectb9bc83ee9",
  "nprd-ustc-qa-projectb2fcfdc6c9",
  # drn: 3316
  "terratest-costaf08ed4a432de706",
  "datacenter-in-the-cloud9b856e0",
  "nprd-devx-githubrunnersd4738e1",
  # drn: 3320
  "techops-logging-module-testing",
  "dnb-techops-cribl-nonprod796f3",
  "dnb-techops-cribl-nonprod23114",
  #DRN: 3256
  "citrix-vdi-masters15dfb2201b4c",
  "citrix-vdi-infrastructure242fd",  
  # drn:3333
  "nprd-dap-project96a08ac35af5fd",
  "nprd-dap-mvp-acceldata-project",
  "nprd-dap-mvp-composer573c5af8e",
  "nprd-dap-dev-projectdc2940c858",
  "nprd-dap-cmposer-dev-project1b",
  "nprd-dap-qa-project03c38476317",
  "nprd-dap-cmposer-qa-project680",
  # drn: 3377
  "nprd-smb-sbn8c6396766fcf6cab15",
  # prod project_id(s)
]
