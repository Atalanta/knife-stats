require 'yaml'

class Chef
  class Knife
    class CookbookStats < Chef::Knife
  
      banner "knife cookbook stats -E ENVIRONMENT [-r ROLE]"
  
      option :environment,
        :short => "-E ENVIRONMENT",
        :long => "--environment ENVIRONMENT",
        :require => true
    
      option :role,
        :short => "-r ROLE",
        :long => "--role ROLE"
  
      deps do
        require 'chef/shef/ext'
      end
  
      def run
        Shef::Extensions.extend_context_object(self)
        validate_options
  
        cookbook_hash = build_cookbook_hash
        cookbook_hash = filter_cookbook_hash(cookbook_hash) if config[:role]
        
        puts cookbook_hash.to_yaml
      end
  
      private
  
      def validate_options
        unless api.get("/environments").keys.include?(config[:environment])
          ui.fatal "Environment #{config[:environment]} not found."
          exit 1
        end
      
        if config[:role] && !api.get("/roles").keys.include?(config[:role])
          ui.fatal "Role #{config[:role]} not found."
          exit 1
        end
      end
  
      def filter_cookbook_hash(cookbook_hash)
        cookbooks_from_role = calculate_cookbooks_from_role
        selected_cookbooks = cookbooks_from_role & cookbook_hash.keys
        
        filtered_cookbook_hash = Hash.new	
        selected_cookbooks.each do |cb|
          filtered_cookbook_hash[cb] = cookbook_hash[cb]
        end
        filtered_cookbook_hash
      end
  
      def build_cookbook_hash
        node_names = search(:node, "chef_environment:#{config[:environment]}").map { |n| n.name }
        
        cookbook = Hash.new(0)
        node_names.each do |node|
          node_cookbooks = api.get("/nodes/#{node}/cookbooks").keys
          node_cookbooks.each { |cb| cookbook[cb] += 1 }
        end
        cookbook
      end
      
      def calculate_cookbooks_from_role
        rl = Chef::RunList.new("role[#{config[:role]}]")
        
        recipes = rl.expand(Chef::Environment.load(config[:environment])).recipes
        
        cookbooks = recipes.map do |recipe|
          Chef::Recipe.parse_recipe_name(recipe).first
        end
        cookbooks.uniq!.map { |c| c.to_s }
      end
    end
  end
end
