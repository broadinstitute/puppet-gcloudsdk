# @summary Manage a gcloud SDK installation installed directly from Google
#
# @example
#    class { 'gcloudsdk':
#      autoupdate       => true,
#      bash_completion  => true,
#      extra_components => {
#        bigtable => {
#          ensure => 'installed',
#        },
#      },
#    }
#
# @param autoupdate
#   Boolean value to determine whether every Puppet run should try to update the
#   components of the gcloud SDK.
#
# @param bash_completion
#   Boolean value to determine whether bash completions are enabled.
#
# @param extra_components
#   A hash of additional components in gcloud to install.
#   See gcloud::component for example.
#
# @param install_dir
#   The directory to which the SDK will be installed.
#
# @param version
#   The initial version of the SDK to download from Google.
#
# @param zsh_completion
#   Boolean value to determine whether zsh completions are enabled.
#
class gcloudsdk (
  Boolean $autoupdate,
  Boolean $bash_completion,
  Hash $extra_components,
  Stdlib::Absolutepath $install_dir,
  String $version,
  Boolean $zsh_completion,
){
  # Check the Architecture of Node to form the download URL
  if ($::architecture == 'amd64') or ($::architecture == 'x86_64') {
    $arch = 'x86_64'
  } else {
    $arch = 'x86'
  }

  # gcloud SDK filename
  $download_file_name = "google-cloud-sdk-${version}-linux-${arch}"

  # gcloud SDK download URL
  $download_source = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${download_file_name}.tar.gz"
  $download_file_path = "/tmp/${download_file_name}.tar.gz"
  $install_path = "${install_dir}/google-cloud-sdk"

  # The below block of code downloads the google-cloud-sdk archive file.
  archive { $download_file_path:
    cleanup      => true,
    creates      => $install_path,
    extract      => true,
    extract_path => $install_dir,
    source       => $download_source,
  }

  # The below block of code installs the google-cloud-sdk archive file.
  exec { 'gcloudsdk_install':
    command     => '/bin/echo "yes" | ./install.sh --usage-reporting false --disable-installation-options --bash-completion false',
    creates     => "${install_path}/bin/gcloud",
    cwd         => "${install_dir}/google-cloud-sdk",
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    refreshonly => true,
    subscribe   => Archive[$download_file_path],
  }

  # The below code will set the google-cloud-sdk path inside the PATH env variable.
  file { '/etc/profile.d/gcloud.bash.sh':
    ensure  => file,
    content => epp('gcloudsdk/gcloud.bash.epp', {
      bash_completion => $bash_completion,
      install_path    => $install_path,
    }),
    mode    => '0644',
    require => Archive[$download_file_path],
  }

  # The below code will set the google-cloud-sdk path inside the PATH env variable.
  file { '/etc/profile.d/gcloud.zsh.sh':
    ensure  => file,
    content => epp('gcloudsdk/gcloud.zsh.epp', {
      zsh_completion => $zsh_completion,
      install_path   => $install_path,
    }),
    mode    => '0644',
    require => Archive[$download_file_path],
  }

  # Only run updates if autoupdate is true, and also only if updates are available
  if $autoupdate {
    exec { 'gcloudsdk_autoupdate':
      command => 'echo "Y" | gcloud components update',
      # Note: gcloud complains if component work happens within the gcloud directory
      cwd     => '/tmp',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', "${gcloudsdk::install_dir}/google-cloud-sdk/bin"],
      onlyif  => "gcloud components list --format='csv(ID,Status)' 2>/dev/null | grep -q 'Update Available'"
    }
  }

  create_resources(gcloudsdk::component, $extra_components)
}
