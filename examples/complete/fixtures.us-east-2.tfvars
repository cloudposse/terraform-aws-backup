enabled = true

region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "backup"

schedule = "cron(0 12 * * ? *)"

start_window = 60

completion_window = 120

cold_storage_after = 30

delete_after = 180
