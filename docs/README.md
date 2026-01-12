# gcloudsdk

## Table of Contents

1. [Overview][overview]
2. [Module Description][module-description]
3. [Usage][usage]
4. [Authors][authors]
5. [Development][development]

## Overview

Download and Install Google Cloud Sdk.

## Module Description

Google Cloud SDK is a set of tools that you can use to manage resources and
applications hosted on Google Cloud Platform.

These tools include:

- gcloud
- gsutil
- core
- bq
- kubectl
- app-engine-python
- app-engine-java
- beta
- alpha
- pubsub-emulator
- gcd-emulator

## Usage

If you just want a Google Cloud SDK installation with the default options you
can run :

By default, Install Latest Version of SDK with following tools:

- gcloud
- gsutil
- core
- bq

```puppet
include gcloudsdk
```

If you need to customize `version` and `install_dir` configuration options, you
need to do the following:

```puppet
class { 'gcloudsdk':
  install_dir => '/opt',
  version     => '108.0.0',
}
```

You can also choose to turn on bash or zsh autocompletion in profile scripts:

```puppet
class { 'gcloudsdk':
  bash_completion => true,
  zsh_completion  => true,
}
```

If you need to add any additional gcloud components, you can do this with the
`gcloudsdk::component` defined type using the component's ID:

```puppet
gcloudsdk::component { 'bigtable':
  ensure => 'installed',
}
gcloudsdk::component { 'minikube':
  ensure => 'installed',
}
```

Components can also be added directly throug a call to the `gcloudsk` class:

```puppet
class { 'gcloudsdk':
  extra_components => {
    bigtable => {
      ensure => 'installed',
    },
  },
  install_dir      => '/opt',
  version          => '108.0.0',
}
```

This can also all be done from Hiera as well:

```yaml
gcloudsdk:
    extra_components:
        bigtable:
            ensure: "installed"
    install_dir: "/opt"
    version: "108.0.0"
```

Restart the shell or terminal after gsutil package is installed. This will set
the path of gsutil in the default environment path variable.

Alternatively, you can source install_gsutil.sh shell script by executing the
following command or export the path to configure gsutil to work without
restarting the shell.

```sh
source /etc/profile.d/gcloud_path.sh
```

```sh
export PATH=$PATH:${install_dir}/google-cloud-sdk/bin
```

## Authors

The original module is based on work by Ranjith Kumar.

## Development

PRs with improvements are always welcome.

[overview]: https://github.com/broadinstitute/puppet-gcloudsdk#overview
[module-description]:
    https://github.com/broadinstitute/puppet-gcloudsdk#module-description
[usage]: https://github.com/broadinstitute/puppet-gcloudsdk#usage
[authors]: https://github.com/broadinstitute/puppet-gcloudsdk#authors
[development]: https://github.com/broadinstitute/puppet-gcloudsdk#development
