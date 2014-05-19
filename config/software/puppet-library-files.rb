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
name "puppet-library-files"

dependency "puppet-library-gem"

files_path = File.expand_path("files/puppet-library", Omnibus.project_root)

webapp_dir = "#{install_dir}/embedded/share/puppet-library"
init_dir = "#{install_dir}/embedded/etc/init.d"

build do
  # Generate webapp directory and copy over config.
  command "mkdir -p #{webapp_dir}"
  command "rm -f #{webapp_dir}/*"
  command "cp -a #{files_path}/config.ru #{webapp_dir}/config.ru"

  # Generate Rack directory structure.
  command "mkdir -p #{webapp_dir}/public"
  command "mkdir -p #{webapp_dir}/tmp"

  # Generate init script if it does not exist.
  command "mkdir -p #{init_dir}"
  command "rm -f #{init_dir}/puppet"
  command "cp -a #{files_path}/puppet-library.init #{init_dir}/puppet-library"
end
