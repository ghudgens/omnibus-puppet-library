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
name "ruby"
default_version "2.0.0-p451"

dependency "zlib"
dependency "ncurses"
dependency "libedit"
dependency "openssl"
dependency "libyaml"
dependency "libiconv"
dependency "gdbm"

version "2.0.0-p451" do
  source md5: "9227787a9636551f1749ee8394b5ffe5"
end

source url: "http://ftp.ruby-lang.org/pub/ruby/#{version.match(/^(\d+\.\d+)/)[0]}/ruby-#{version}.tar.gz"

relative_path "ruby-#{version}"

env = { "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include  -O3 -g -pipe"}

build do
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded",
                       "--with-out-ext=fiddle,dbm",
                       "--enable-shared",
                       "--enable-libedit",
                       "--with-ext=psych",
                       "--disable-install-doc"]

  command configure_command.join(" "), :env => env
  
  command "make", :env => env
  command "make install", :env => env
end