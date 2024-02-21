resource "aws_efs_file_system" "lls_files" {
  encrypted = true
  tags = {
    Name = "ECS-EFS-FS"
  }
}

resource "aws_efs_mount_target" "mount" {
  count           = length(local.subnets)
  file_system_id = aws_efs_file_system.lls_files.id
  subnet_id      = tolist(local.subnets)[count.index]

}

resource "aws_efs_access_point" "assets_access_point" {
  file_system_id = aws_efs_file_system.lls_files.id

  root_directory {
    path = "/sample/data"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = "755"
    }
  }
}