# This file checks for operating system is based on linux Kernel
# If its linux Kernel, it assigns the google cloud sdk package from google storage
# as download_source parameter for init puppet file
class gcloudsdk::params {
  # Checks for linux Kernel
  case $::kernel {
    'linux' : {
      $version = 'LATEST'
      $is_install_gcloud = true
      $is_install_gsutil = true
      $is_install_core = true
      $is_install_bq = true
      $is_install_kubectl = false
      $is_install_app_engine_python = false
      $is_install_app_engine_java = false
      $is_install_beta = false
      $is_install_alpha = false
      $is_install_pubsub_emulator = false
      $is_install_gcd_emulator = false
      $install_dir = '/opt'
    }
    # Throws failure message for any other operating system
    default : {
      fail("Kernel ${::kernel} not supported by module!")
    }
  }
}
