#
# Copyright:: Copyright (c) 2014 Grant Hudgens.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
name 'puppet-library'
maintainer 'drrb'
homepage 'https://github.com/drrb/puppet-library'

#Package attributes
install_path    '/opt/puppet-library'
build_version   '0.13.0'
build_iteration 0

# Specify dependency versions to embed
override :'ruby', version: "2.0.0-p451"
override :'passenger-gem', version: "4.0.42"
override :'nginx', version: "1.6.0"
override :'puppet-library-gem', version: "#{build_version}"

#Creates required build directories
dependency 'preparation'

# Puppet Library dependencies/components
dependency 'puppet-library-gem'
dependency 'passenger-gem'
dependency 'nginx'

#Puppet Library and its dependencies' configuration/misc files

#Version manifest file
dependency 'version-manifest'

#Ignore git crap
exclude '\.git*'
exclude 'bundler\/git'
