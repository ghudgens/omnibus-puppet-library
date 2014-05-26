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
name "nginx-files"

dependency "nginx"

files_dir = File.expand_path("files/nginx", Omnibus.project_root)
config_dir = "#{install_dir}/embedded/etc/nginx"
init_dir = "#{install_dir}/embedded/etc/init.d"

# Grab the ruby and passenger-gem components as we will be using them in the configure
ruby_cmpt = project.library.components.find { |c| c.name == 'ruby' }
pgem_cmpt = project.library.components.find { |c| c.name == 'passenger-gem' }

project_name = project.name

if platform == "debian"
  init_script = "nginx.init.deb.erb"
end

config_script = "nginx.conf.erb"

build do
  # Create directory structure.
  command "mkdir -p #{config_dir}/conf.d"
  command "mkdir -p #{init_dir}"

  # Create config files and init script
  command "cp -a #{files_dir}/mime.types #{config_dir}/"
  block do
    unless config_script.nil?
      template_file = File.open("#{files_dir}/#{config_script}", "r").read
      nginx_config = ERB.new(template_file)
      File.open("#{config_dir}/nginx.conf", "w") do |file|
        file.print(nginx_config.result(binding))
      end
    end

    unless init_script.nil?
      template_file = File.open("#{files_dir}/#{init_script}", "r").read
      nginx_init = ERB.new(template_file)
      File.open("#{init_dir}/nginx", "w") do |file|
        file.print(nginx_init.result(binding))
      end
      File.chmod(0755, "#{init_dir}/nginx")
    end
  end
end
