variable "do_token" {
    type = string
    # default = "deafult"
    sensitive = true
}

variable "cluster_name"{
    type = string
    default = "k8s-do-terraform"
}

variable "k8s_version" {
    type = string 
    default = "1.31.1-do.1"
}

variable "region"{
    type = string
    default = "sgp1"
}