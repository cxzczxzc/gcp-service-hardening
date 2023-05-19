dataset_name = "mybqtestdataset"
project_id   = "kcc-master"
views = [
  {
    view_id        = "barview",
    use_legacy_sql = false,
    query          = "SELECT name FROM `export-assets-examples.structured_export.example_compute_googleapis_com_Instance`",
    labels = {
      env      = "devops"
      billable = "true"
      owner    = "joedoe"
    }
  }
]
tables = [
  {
    table_id           = "test",
    time_partitioning  = null,
    range_partitioning = null,
    clustering         = [],
    expiration_time    = 2524604400000, # 2050/01/01
    labels = {
      env      = "devops"
      billable = "true"
      owner    = "joedoe"
    },
    schema = <<EOF
      [
    {
      "description": "Full Studentor ID",
      "mode": "NULLABLE",
      "name": "FullStudentId",
      "type": "STRING"
    },
    {
      "description": "Student number",
      "mode": "NULLABLE",
      "name": "StudentNumber",
      "type": "INTEGER"
    },
    {
      "description": "Student ID",
      "mode": "NULLABLE",
      "name": "StudentId",
      "type": "INTEGER"
    },
    {
      "description": "Student Start Time",
      "mode": "NULLABLE",
      "name": "StudentStartTime",
      "type": "INTEGER"
    },
    {
      "description": "Full Date of Student",
      "mode": "NULLABLE",
      "name": "fullDate",
      "type": "DATE"
    }
]

      EOF
  }
]