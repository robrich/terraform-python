Terraform can't resolve Python
==============================

I've hit a snag. Is my `PATH` messed up? Is Python not installed correctly?

Problem: Terraform `data "external"` can't resolve `python.exe`, but running `python.exe some-file.py` works just fine.

Repro steps:

0. Running on Windows 11 through PowerShell terminal.  Terraform is downloaded and put into a convenient directory in PATH.  Python 3.10 is downloaded through Windows Store, and thus in C:\Users\{me}\AppData\Local\Microsoft\WindowsApps which is also in the PATH.

1. Change `main.tf` to comment out the python line and uncomment the node line.

2. `terraform init && terraform plan`  This succeeds with this output:

   ```
   > terraform init && terraform plan
   data.external.archive_prepare: Reading...
   data.external.archive_prepare: Read complete after 1s [id=-]

   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
   following symbols:
     + create

   Terraform will perform the following actions:

     # aws_s3_bucket.history will be created
     + resource "aws_s3_bucket" "history" {
         + acceleration_status         = (known after apply)
         + acl                         = (known after apply)
         + arn                         = (known after apply)
         + bucket                      = "terraform-test-bucket"
         + bucket_domain_name          = (known after apply)
         + bucket_prefix               = (known after apply)
         + bucket_regional_domain_name = (known after apply)
         + ... snip ...
         + website_endpoint            = (known after apply)
       }

   Plan: 1 to add, 0 to change, 0 to destroy.

   ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

   Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
   you run "terraform apply" now.
   ```

3. run `python.exe hello.py` and note that it succeeds with this output:

   ```
   > python.exe hello.py
   {"bucket":"terraform-test-bucket"}
   ```

4. Change `main.tf` to comment out the node line and uncomment the python line.

5. `terraform init && terraform plan`  This fails with this output:

   ```
   > terraform init && terraform plan
   data.external.archive_prepare: Reading...
   
   Planning failed. Terraform encountered an error while generating this plan.
   
   ╷
   │ Error: External Program Lookup Failed
   │
   │   with data.external.archive_prepare,
   │   on main.tf line 6, in data "external" "archive_prepare":
   │    6:   program = ["python.exe", "${path.module}/hello.py"]
   │
   │ The data source received an unexpected error while attempting to parse the query. The data source received an
   │ unexpected error while attempting to find the program.
   │
   │ The program must be accessible according to the platform where Terraform is running.
   │
   │ If the expected program should be automatically found on the platform where Terraform is running, ensure that the
   │ program is in an expected directory. On Unix-based platforms, these directories are typically searched based on the
   │ '$PATH' environment variable. On Windows-based platforms, these directories are typically searched based on the
   │ '%PATH%' environment variable.
   │
   │ If the expected program is relative to the Terraform configuration, it is recommended that the program name includes
   │ the interpolated value of 'path.module' before the program name to ensure that it is compatible with varying module
   │ usage. For example: "${path.module}/my-program"
   │
   │ The program must also be executable according to the platform where Terraform is running. On Unix-based platforms,
   │ the file on the filesystem must have the executable bit set. On Windows-based platforms, no action is typically
   │ necessary.
   │
   │ Platform: windows
   │ Program: "python.exe"
   │ Error: exec: "python.exe": executable file not found in %PATH%
   ╵
   ```

6. Expected results: `terraform plan` works identically for both node and python dependencies.
