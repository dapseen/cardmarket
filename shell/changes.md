## Script Update

- change from single qoute to double qoute too allow parsing off variables 
- Logfiles variable not matching
- Added SH Bang to make it executable


## Script use case

An intending use case will be log rotation from all container pods, and this can be used with a sidecar or an init container, this use case is ideal for production setup.

Another angle is to use the `var/log/container` file in the node, which is basically done by most log rotating service like fluentd

To use it directly, we will have to nodify the code a bit to allow `pip`

`k logs <container_name> | script.sh`




