require "rubygems"
require "puppet_library"

# NB: this config API is not yet stable, and may change without notice.
# The format shown is valid from Puppet Library v0.11.0
server = PuppetLibrary::Server.configure do
    # Serve our private modules out of a directory on disk
    forge :directory do
        path = "/var/lib/modules"
    end

    # Download all other modules from the Puppet Forge
    forge :proxy do
        url "http://forge.puppetlabs.com"
    end
end

run server