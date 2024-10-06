variable "do_token" {
    type = string
    default = "dop_v1_bf490fcfb5ff4b9fbd681ca61e16e6d638d33c9f55fb7609a4a58d351874e3e5"
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



