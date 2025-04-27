variable subnet_ids {
    type = list(string)
    default = []
    description = "List of subnet IDs to launch the EKS cluster in."

}
variable vpc_id {
    type = string
    default = ""
    description = "VPC ID where the EKS cluster will be created."
}
variable cluster_name {
    type = string
    default = "eks-cluster"
    description = "Name of the EKS cluster."
}