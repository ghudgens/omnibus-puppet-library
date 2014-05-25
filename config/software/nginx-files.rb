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

if platform == "debian"
  init_script = "nginx.init.deb.erb"
end

config_script = "nginx.conf.erb"

build do
  # Create directory structure.
  command "mkdir -p #{config_dir}/sysconfig"
  command "mkdir -p #{init_dir}"

  # Create config file and init script
  block do
    project_name = project.name

    unless init_script.nil?
      template_file = File.open("#{files_dir}/#{config_script}", "r").read
      nginx_config = ERB.new(template_file)
      File.open("#{config_dir}/nginx.conf", "w") do |file|
        file.print(nginx_config.result(binding))
      end
    end

    unless init_script.nil?
      command "rm -f #{init_dir}/nginx"
      nginx_init = ERB.new(File.read("#{files_dir}/#{init_script}"))
      File.open("#{init_dir}/nginx", "w") do |file|
        file.print(nginx_init)
      end
    end
  end
end
