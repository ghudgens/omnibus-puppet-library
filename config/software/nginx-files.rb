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

nginx_config = ERB.new(File.read("#{files_dir}/nginx.conf.erb"))

if platform == "debian"
  init_script = "nginx.deb.init"
end

build do
  # Remove pre-generated nginx config files and replace them for puppet-library.
  command "mkdir -p #{config_dir}/sysconfig"
  command "rm -f #{config_dir}/nginx.conf"
  command "cp -a #{files_dir}/nginx.sysconfig #{config_dir}/sysconfig/nginx"
  command "cp -a #{files_dir}/nginx.conf #{config_dir}/nginx.conf"

  block do
    File.open("#{config_dir}/nginx.conf", "w") do |file|
      file.print(nginx_config)
    end
  end
  

  # TODO: turn this into an erb template
  # Generate init script if it does not exist.
  unless init_script.nil?
    command "mkdir -p #{init_dir}"
    command "rm -f #{init_dir}/nginx"
    command "cp -a #{files_dir}/#{init_script} #{init_dir}/nginx"
  end
end
