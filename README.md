# gcloudsdk #

### Table of Contents

1. [Overview][overview]
2. [Module Description][module-description]
3. [Usage][usage]
4. [Authors][authors]
5. [Development][development]

### Overview

Download and Install Google Cloud Sdk.

### Module Description

Google Cloud SDK is a set of tools that you can use to manage resources and applications hosted on Google Cloud Platform.

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

### Usage

If you just want a Google Cloud SDK installation with the default options you can run :

By default, Install Latest Version of SDK with following tools:

- gcloud
- gsutil
- core
- bq


```
include gcloudsdk
```

If you need to customize ```version``` and ```install_dir``` configuration option you need to do the following:

```
class { 'gcloudsdk':
     version   => '108.0.0',
     install_dir = '/opt'
}
```

If you need to customize ```tools``` installation option you need to do the following:

```
class { 'gcloudsdk':
     is_install_gcloud => true
     is_install_gsutil => true
     is_install_core => true
     is_install_bq => true
     is_install_kubectl => false
     is_install_app_engine_python => true
     is_install_app_engine_java => true
     is_install_beta => false
     is_install_alpha => false
     is_install_pubsub_emulator => false
     is_install_gcd_emulator => false
}
```

Restart the shell or terminal after gsutil package is installed. This will set the path of gsutil in the default environment path variable.

Alternatively, you can source install_gsutil.sh shell script by executing the following command or export the path to configure gsutil to work without restarting the shell.

  ```sh
        source /etc/profile.d/gcloud_path.sh
  ```

  ```sh
        export PATH=$PATH:${install_dir}/google-cloud-sdk/bin
  ```

### Authors
This module is based on work by Ranjith Kumar.

### Development
Interested contributors can touch base with Ranjith (kumar.sree45@gmail.com)

[overview]: https://github.com/RanjthKumar45/puppet-gcloudsdk#overview
[module-description]: https://github.com/RanjthKumar45/puppet-gcloudsdk#module-description
[usage]: https://github.com/RanjthKumar45/puppet-gcloudsdk#usage
[authors]: https://github.com/RanjthKumar45/puppet-gcloudsdk#authors
[development]: https://github.com/RanjthKumar45/puppet-gcloudsdk#development
