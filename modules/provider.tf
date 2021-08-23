provider "aws" {
  profile    = "default"
  region     = var.region

}

provider "aws" {
  alias  = "backup_region"
  #region = var.s3_remote_backup_region
  region = "us-west-1"
}
