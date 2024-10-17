# Update before use

variable cec {
    default = "amansin3-vmapp"
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
    default= "https://tempbucketbyaman.s3.amazonaws.com/tetration_installer_xfd_enforcer_linux_tes.sh?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEM3%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQDQD2eCLk%2BEBTxFUDfLvbCJipKOHFWbm8UbHtWfZyOGoAIhAJqdNZfuKJdaMEPMfcZeQjcDw9J2WCqhTE%2FQoOaniSjBKp0ECDYQBBoMOTM4OTk2MTY1NjU3IgzKCINHoTs4ojLzEZAq%2BgPP%2B1RX2OrA%2Bnd4UpD6Q2xq%2BY3D0b7q609pdUeWBtj3Tm2xHJ6jVm2xFbZCmMlmnt%2FI%2BhQ%2FWKB%2BA98XCIZoJn6%2BxvQqSX0jqMxOr00meWVpy%2BaHNWNpO1d8t1gkEGcyqjSDgsuXcgHBYZtwu8K0AhavPo28Sui2Rp5DZTpud1hZ4s2ls5hfMXJQx9UvOCW3v7XxYl3w1gdgKT3KfVFkU1Kiyx6hYeaJjzpQu6RNY8Ht6pSTLv8Ks1Gd9qM7slq74QBS2bmvImr82NpFu2AX6ZdVV3IKaAvl7v%2FMB1N%2FrK3w2x%2Bu5%2BDF5Z6BWTk0VrQre0%2FSPekgoEjvHvkCqoetCZJ%2Fsr5CkGiExeYPrcPsxZokO3I%2BwBg94KhppbSkuiGyJqznHonrTa4E3dh0AnkhEOYgewEniHx5K7LfVIQoYf%2BUAdlkOJWuWmeiTwEVzxUhy5VS7bFQOIaCJe4zfhW7WU14hkI6RpKDB3GWLQOxqRkEcFbRoIvUmnsvhiwGFqS0NrFRApnGdTiYjaNyGCYFlw1h4kNMeHIMEpr%2BO0r4zi3A5GC0PGs2kCN%2BYi%2FPUIntzdRoqZPVI4kTPNUilFH1opINQtvDolYTNRf6Bm6kAxOZIZX%2BluzjCKq13nSxQc2L8QhjGMw%2FdlFfGWnlwYfujHqnXJpNuzYEZHoJ2zDc9MW4Bjq0Amlua3057LoGa22KIfqRYG1bO0aRUWZArPheiSZmKonQxn%2F5mQAC4o%2FvbBlTuqYSpbFG28sgnmpiqDC8nyHzU6NuofP2YNYaxXRWNVcNc7HERVXyHKTcfCmVZZ%2FXk%2B0ZqzLMGqmtuuKi7FfwXrmd2zYgDVn8FLjsR7fmhKkv3ewRqg3ststzZV9%2B%2BeEFVXQWB2ETag8QUwEr3q6KnouqDkW816i8D9eHwJejuih33v%2FMALa1x2B0H7biLyOliHppmKrq8NVbgdrz8YsPoiVGC4D5cWAZuBuKnZlNBkA%2FfwoBccI8qlFpVsZFaWzPqMHGzJHw33vZxkohBep69GRpZEgVTZzoo7bZKO%2B4zWZjO9dEBJrEEO6WYzSncpQDCklwKPwyvNXkd9z6ZkzpA%2BFd%2BFMxb33l&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA5VIEINQM5IKYQBTO%2F20241017%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241017T210024Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=d879c8b29e575c8ea97fedd8a537ee272a31719d5ce9e339edad698d4c1c96fb"
}