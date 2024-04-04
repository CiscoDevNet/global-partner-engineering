# Create CDO users
resource "cdo_user" "user1" {
  name             = "test1@example.com"
  role             = "ROLE_SUPER_ADMIN"
  is_api_only_user = false
}

resource "cdo_user" "user2" {
  name             = "test2@example.com"
  role             = "ROLE_READ_ONLY"
  is_api_only_user = false
}

resource "cdo_user" "user3" {
  name             = "test3@example.com"
  role             = "ROLE_ADMIN"
  is_api_only_user = false
}


