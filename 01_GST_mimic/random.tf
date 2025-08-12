# Random suffix for resource names
resource "random_id" "suffix" {
  byte_length = 4
}