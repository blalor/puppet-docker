# Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
# 
# Run a command in a new container
# 
#   -P=false: Publish all exposed ports to the host interfaces
#   -a=[]: Attach to stdin, stdout or stderr.
#   -c=0: CPU shares (relative weight)
#   -cidfile="": Write the container ID to the file
#   -d=false: Detached mode: Run container in the background, print new container id
#   -dns=[]: Set custom dns servers
#   -e=[]: Set environment variables
#   -entrypoint="": Overwrite the default entrypoint of the image
#   -expose=[]: Expose a port from the container without publishing it to your host
#   -h="": Container host name
#   -i=false: Keep stdin open even if not attached
#   -link=[]: Add link to another container (name:alias)
#   -lxc-conf=[]: Add custom lxc options -lxc-conf="lxc.cgroup.cpuset.cpus = 0,1"
#   -m="": Memory limit (format: <number><optional unit>, where unit = b, k, m or g)
#   -n=true: Enable networking for this container
#   -name="": Assign a name to the container
#   -p=[]: Publish a container's port to the host (format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort) (use 'docker port' to see the actual mapping)
#   -privileged=false: Give extended privileges to this container
#   -rm=false: Automatically remove the container when it exits (incompatible with -d)
#   -sig-proxy=true: Proxify all received signal to the process (even in non-tty mode)
#   -t=false: Allocate a pseudo-tty
#   -u="": Username or UID
#   -v=[]: Bind mount a volume (e.g. from the host: -v /host:/container, from docker: -v /container)
#   -volumes-from=[]: Mount volumes from the specified container(s)
#   -w="": Working directory inside the container

define docker::container(
    $image,
    $command = [],
    $env = {},
    $hostname = undef,
    $links = {},
    $ports = {},
    $volumes = {},
    $priority = 50,
) {
    include docker
    
    file {"${docker::containers_d}/${priority}-${name}.yaml":
        owner   => root,
        group   => root,
        mode    => '0600',
        content => template('docker/container.yaml.erb'),
        notify  => Exec['docker-sync'],
    }
}
