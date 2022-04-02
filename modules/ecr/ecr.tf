resource "aws_ecr_repository" "rust_practice" {
  name                 = "rust-practice"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}