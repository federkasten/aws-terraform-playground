resource "aws_batch_job_definition" "example" {
  name = "simple-job"
  type = "container"
  container_properties = file("./job/simple_job.json")
}
