require 'yaml'

module Atalanta
  class EnvironmentStats < Chef::Knife

    banner "knife environment stats"

    deps do
      require 'chef/shef/ext'
    end

    def run
      Shef::Extensions.extend_context_object(self)

      environment_names = api.get("/environments").keys
      
      environment = Hash.new
      environment_names.sort.each do |env|
        environment[env] = search(:node, "chef_environment:#{env}").size
      end
      
      puts environment.to_yaml
    end
  end
end
