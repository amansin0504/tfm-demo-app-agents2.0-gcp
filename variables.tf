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
    default= "https://tempbucketbyaman.s3.us-east-1.amazonaws.com/tetration_installer_xfd_enforcer_linux_tes.sh?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEKT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIQDSyCRSWbJJoE%2B1bTq%2FXrUi3FsWLfjm7wL6%2FIxE%2B9uZZQIgOZZh5CUX6XxY9hvdE%2BygRs1cfv8hKPsoqDYjDQ5tQJkqnQQITRAEGgw5Mzg5OTYxNjU2NTciDAl5%2FifZrR5e9lcCKCr6A6V%2FXjwDbIA%2BdLkF%2BFTIuI%2FO481hKBnHw2F%2BhT%2Fmv7B5%2BV9SJNCCjV7zKtJ4bTPe%2FYNPQWAiLOV%2Bjex5pl09U6NRt1gaG%2BrWNIBdIIfA6wNQU77FC3pWSirxC2W4WbO5J2BxsKIqtm1Nj5kHE2tFrSwP%2BJQatJtsPMkIuxFQtqNP52ryf%2BttNZ1O5e1p2eXEVhjL80FYD3PvkFqiCQqPUKo2hQRFaeOwCa%2FPUSFUM%2F%2FbSL1vmpZ8Hmsy06I%2BLNf8cq57Py9LmheT49R7MVfMH72jbx6dw4YVGxCCJVdzsicvoeKfpcpJN2vf6RIzMErBpnov6ET3Y0iMJZXzkXQ1BCO5Figt36P%2FQTUbVJK3EtrR86us8jh9lQRfvEuw2zwUl%2BFb4Yz7XnKgOAQqV7kgWmVhNmV6aZZPtlGdb66nII8fsQmoPr3mQFfg20uEeapIrolJXvTQei3f3X%2BuD%2FH3a7acbvTochW1VenK58hWqvrxVJbEn7rcLFytGyvXpAEsLlx4MrOVrlv4k5X26kQCz8zUnWYCpyPkvXpIdNoNL11bMZ43TZMBmZ6N4hGr36tssaYboxh7Mg9HhAXFYIWXNv%2By2nst%2B%2FoQeaDGcP2PcnGvlEmMt61pybPLX0oX94xF53UJCjAFwIZ64v8kAQgind0A1CE62PMtEEExMJLonboGOrUCScEUKBffrfcKzv4FYCGgeJRxAPapLyz8LQxylgXBe9ZvCwpaE6Apu8q%2BWgmVoMOfW2GvwR1M2yuxaxzF934D9k7696%2FAE%2BFH8TVJ%2BsBevJ1G%2FjBwRZoq10NffMRgzIH%2FZwylG1StJ%2Fjz0UGmC6HD6E7%2FiP2Rc23LmazeHzGBqCvJFiRs0qCzjU3cVsgd56i96zahtioQYgDG8osYeYjAwgxhsfEn41nXFS1nypE5c0IG0EClD8NjAONZm0I%2B4l1YYeugAo2k9MbmExlAWyeWMgQjO%2BFUY9jMfRvDEExjWRtk4FXoCdqs9Eyxhacz7hmuMidvxgE2uvYU644DzhEuTyhT6u1%2FctsS912iJCkWg7yQfxmWGz%2FWGBYgkWCz2ExRxESmO19uPpsN737q8Q2P17tFl6t1&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA5VIEINQMQK4X4C4O%2F20241127%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241127T193438Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=20bb9ac3add5d51e4efacdc939cd32747403bdd40d31678f26a8fb5d45a89da4"
    }