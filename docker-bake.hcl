target "docker-metadata-action" {}

target "default" {
  inherits = ["docker-metadata-action"]
  args = {
    NONROOT_USER: "ubuntu",
    NONROOT_GROUP: "ubuntu",
    NONROOT_UID: "1000",
    NONROOT_GID: "1000",
    NODEJS_VERSION: "latest",
    PYTHON_VERSION: "latest",
  }
}
