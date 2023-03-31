# @summary Manage a gcloud component's installation status
#
# @example
#    gcloudsdk::component { 'bigtable':
#      ensure => 'installed',
#    }
#
# @param ensure
#   The ensure status of the component, either 'absent' or 'installed'
#
# @param component_id
#   The ID of the component to install
#
define gcloudsdk::component (
  String $component_id                = $name,
  Enum['absent', 'installed'] $ensure = 'installed',
) {
  include gcloudsdk

  if $ensure == 'installed' {
    # The below block of code installs a component if it isn't already installed.
    exec { "gcloudsdk_component_${component_id}_install":
      command => "gcloud components install ${component_id}",
      # Note: gcloud complains if component work happens within the gcloud directory
      cwd     => '/tmp',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', "${gcloudsdk::install_dir}/google-cloud-sdk/bin"],
      unless  => "gcloud components list --format='csv(ID,Status)' 2>/dev/null | grep -q '^${component_id},Installed'",
    }
  }

  if $ensure == 'absent' {
    # The below block of code remove a component if it is installed.
    exec { "gcloudsdk_component_${component_id}_remove":
      command => "gcloud components remove ${component_id}",
      # Note: gcloud complains if component work happens within the gcloud directory
      cwd     => '/tmp',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', "${gcloudsdk::install_dir}/google-cloud-sdk/bin"],
      unless  => "gcloud components list --format='csv(ID,Status)' 2>/dev/null | grep -q '^${component_id},Not Installed'",
    }
  }
}
