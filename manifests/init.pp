## installs docker, manages service, provides infrastructure for containers
class docker (
    $docker_version = 'installed',
    $docker_sync_version = 'installed',
    $dockerd_other_args = '',
) {
    package {'docker-io':
        ensure => $docker_version,
    }
    
    package {'python-docker-sync':
        ensure => $docker_sync_version
    }
    
    ## ensure docker daemon is listening on LOCAL port, plus unix sock
    file {'/etc/sysconfig/docker':
        content => template('docker/docker.sysconfig.erb'),
        require => Package['docker-io'],
        notify  => Service['docker'],
    }
    
    service {'docker':
        ensure    => running,
        enable    => true,
        subscribe => Package['docker-io'],
    }
    
    file {'/etc/docker.d':
        ensure  => directory,
    }
    
    ## purge unmanaged containers
    file {'/etc/docker.d/containers':
        ensure  => directory,
        purge   => true,
        recurse => true,
    }
    
    ## downloads images; could take a while, so disabling timeout
    ## gets notified by files created in docker::container
    exec {'docker-sync':
        command => '/usr/bin/docker-sync /etc/docker.d/containers',
        timeout => 0,
        require => Service['docker'],
    }
}
