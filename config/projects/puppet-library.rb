
name 'puppet-library'
maintainer 'CHANGE ME'
homepage 'CHANGEME.com'

install_path    '/opt/puppet-library'
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency 'preparation'

# puppet-library dependencies/components
# dependency 'somedep'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
