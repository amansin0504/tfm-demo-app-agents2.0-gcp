# Update before use

variable cec {
    default = "pod1-vmapp-aman"
}
variable region {
    default = "us-east1"
}
variable zone {
    default = "us-east1-b"
}

#if you change cidr block make sure you update addresses in python and shell scripts.
variable websubnet1 {
    type = string
    default = "10.120.211.0/24"
}
variable websubnet2 {
    type = string
    default = "10.120.212.0/24"
}
variable appsubnet1 {
    type = string
    default = "10.120.213.0/24"
}
variable appsubnet2 {
    type = string
    default = "10.120.214.0/24"
}
variable dbsubnet1 {
    type = string
    default = "10.120.215.0/24"
}
variable dbsubnet2 {
    type = string
    default = "10.120.216.0/24"
}

variable cswinstaller {
    type = string
    default= "https://tempbucketbyaman.s3.us-east-1.amazonaws.com/tetration_installer_xfd_enforcer_linux_tes.sh?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjELj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQD%2F93B2439PdwINwFQ07CYZe3K1eX4aVpa0b5pNFusiVQIhAMMxp0pYJSMDUnrg25RK4ATdpV5PPVBaEa5LK5mUY0UGKp0ECGEQBBoMOTM4OTk2MTY1NjU3IgxlFG4Uchmvx2wQJJQq%2BgPGAnllM2iXxZvpJ9yaFTsDt0rWuXM%2BuxvSDtTWVusf7yRyQP77YMNizcSzBHwaGd104xlWCFf3u32YIE3JKsHj0k939vbu%2BQHRryofu09eQDsv2Nlr35ZkPPT4DROuMC5jDq09kgMRxIOJCLqs%2B8xRgWIuxU6vCisgJaKUI9h5hLKSKDdZOn4VLH5kX%2B12WJ43Cx8TFnVFH3%2BddfyJgcgcEAOxmPHrYj42nC8gQj19uvKbpkLYLta%2Fq7vorFU5TUiO7NMmLwr3OCBdNWSlMKuFq5DH6OKdJL%2FGtDHuQPKkqajgLyloZ0m2z91S4FsLGjeYoNTdc8uCK7TXS0h0W%2BKbHqQErVBDigRtfNtny%2FwXqn43d0y7mxDAMsZQkElG06ZGQw6i%2FTABT3JfgCO3MiQ%2FoVH0hjnVEU0c2oHxTXEkUoICUCPJFpyTvpl%2Be8WaLOUUbiaHomRBmyEbg9DH%2F5pv4l2fxsHc%2F4bv5a5siYtgNB6P%2FFHL%2FlKX0aAARNRrka7H1aKD6HYLEXxNoSBES01LvHI9ir76EQwIfFqJ1pAd0B6x%2BWiO9eCli31TIOBdvsMFtNQbTM%2B40ghZuHM9EpA0VgK5pnAFb1SAX0FDxM6QEwA4cDHeBJbimPoLXdRTD0NT83IEZyekiYr217RTSBh%2F9VU7K39XUyWTKDD7p6K6Bjq0Ag74E25jpqIv3PicYlwNd3pJUj1NeOuL2ANNkoONUp0UjHYHw6qc6iQcj8ZgS6ILUVm5P45FBGoWL39Sbawb3OIYge3GQj50%2BSmGgwQCefLTKCutrG07mlqMuekNLNgfmoRJdqBShld0bDI%2B7K2tyA4Nr0d5CVtxLkpTHT4%2FoQECpCNp8RRpJ%2BVpwbxb4CBxbPsYcHcZ4CXSxQQJKlA3Bo4M1ZAxGAkk%2FFFtm5S8rzp9R9c42HmhcobL3rpLrHupTPM%2BWG%2FLF3lptq5Dcy4KSKv2xEQIUpkNk8%2FhHP2AfNiopi9T%2BtbAkQ3j4rsfStXMGDHPTJZ9ifVcCxPBEjn4Zo7aA1rxgPYfjoH0w8OAEwxjLDzDWGfIBd2kfIXJiNul8XO%2BOGbPn4k8NOPNrYfSjyvBP5Nu&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA5VIEINQMZJO3RGUJ%2F20241128%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241128T160235Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=b59766cfa52650545a863bfb0dea185fd00738ea4f2bcdb7feba8420d4d6ddb9"
}