
variable "dockerhub" {
 type = object({
   docker_user = string
   docker_password = string
 })
 sensitive = true
 default = {
   docker_user = ""
   docker_password = ""
 }
}
