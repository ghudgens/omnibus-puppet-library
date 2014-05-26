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
dependency "nginx-files"

files_dir = File.expand_path("files/puppet-library", Omnibus.project_root)
webapp_dir = "#{install_dir}/embedded/share/puppet-library"
config_dir = "#{install_dir}/embedded/etc/puppet-library"

# Grab the ruby and passenger-gem components as we will be using them in the configure
ruby_cmpt = project.library.components.find { |c| c.name == 'ruby' }
pgem_cmpt = project.library.components.find { |c| c.name == 'passenger-gem' }

project_name = project.name

build do
  # Create puppet-library config directory.
  command "mkdir -p #{config_dir}"

  # Generate webapp directory and copy over config.
  command "mkdir -p #{webapp_dir}"
  command "rm -f #{webapp_dir}/*"
  command "cp -a #{files_dir}/config.ru #{webapp_dir}/"

  # Generate Rack directory structure.
  command "mkdir -p #{webapp_dir}/public"
  command "mkdir -p #{webapp_dir}/tmp"

  block do
    template_file = File.open("#{files_dir}/puppet-library.conf.nginx.erb", "r").read
    nginx_config = ERB.new(template_file)
    File.open("#{install_dir}/embedded/etc/nginx/conf.d/puppet-library.conf", "w") do |file|
      file.print(nginx_config.result(binding))
    end
  end
end
