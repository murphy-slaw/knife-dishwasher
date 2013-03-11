#
# Author:: Kevin Murphy (<kevin@eorbit.net>)
# Copyright:: Copyright (c) 2013 Kevin Murphy
# License:: GPL
require 'chef/knife'

module KnifeDishwasher
  class Dishwasher < Chef::Knife

      deps do
        require 'chef/node'
        require 'chef/role'
        require 'chef/recipe'
        require 'chef/api_client'
        require 'chef/search/query'
      end

      banner "knife dishwasher {roles|cookbooks}"

      def run

        case @name_args[0]
        when "roles"
          find_unused_roles()
        when "cookbooks"
          find_unused_cookbooks()
        else
          ui.error "invalid subcommand"
          ui.msg opt_parser
          exit 1
        end

      end

      def find_unused_roles

        empties = []
        roles = Chef::Role.list(true)
        empty_role_search = Chef::Search::Query.new

        ui.msg "Checking #{roles.length} roles."

        roles.sort{|r1,r2| r1.first <=> r2.first}.each do |role|
          query = "roles:#{role[0]}"
          nodes = empty_role_search.search('node', query)
          if nodes.first.empty?
            empties << role
          end
        end

        if empties.empty?
          ui.msg "No empty roles."
        else
          ui.msg "#{empties.length} empty roles found:"

          empties.each do |role|
            ui.msg role[0]
          end
        end

      end

      def find_unused_cookbooks

        api_endpoint = "/cookbooks?num_versions=1"
        cookbook_versions = rest.get_rest(api_endpoint)
        cookbooks = cookbook_versions.collect{ |i| i[0] }.sort
        ui.msg "Checking #{cookbooks.length} cookbooks."

        empties = []
        empty_cookbook_search = Chef::Search::Query.new

        cookbooks.each do |cookbook|
          query = "recipes:#{cookbook} OR recipes:#{cookbook}\\:\\:*"
          nodes = empty_cookbook_search.search('node', query)
          if nodes.first.empty?
            empties << cookbook
          end
        end

        if empties.empty?
          ui.msg "No unused cookbooks"
        else
          ui.msg "#{empties.length} unused cookbooks found:"

          empties.each do |cookbook|
            ui.msg cookbook
          end
        end

      end

  end
end
