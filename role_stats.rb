require 'yaml'

module Atalanta
  class RoleStats < Chef::Knife

    banner "knife role stats [-E ENVIRONMENT]"

    option :environment,
      :short => "-E ENVIRONMENT",
      :long => "--environment ENVIRONMENT"
  
    deps do
      require 'chef/shef/ext'
    end

    def run
      Shef::Extensions.extend_context_object(self)
      validate_options

      role_names = api.get("/roles").keys
      
      role = Hash.new
      role_names.sort.each do |r|
        query = "roles:#{r}#{environment_query}"
        role[r] = search(:node, query).size
      end
      
      puts role.reject! { |k,v| v == 0 }.to_yaml
    end

    private

    def validate_options
      if config[:environment] && !api.get("/environments").keys.include?(config[:environment])
        ui.fatal "Environment #{config[:environment]} not found."
        exit 1
      end
    end

    def environment_query
      if config[:environment]
        " AND chef_environment:#{config[:environment]}"
      else
        ""
      end
    end
  end
end
