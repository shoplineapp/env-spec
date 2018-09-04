require 'rails/generators/base'

module EnvSpec
  module Generators
    class CreateConfigFileGenerator < Rails::Generators::Base
      desc "Creates a Mongoid configuration file at config/mongoid.yml"

      def self.source_root
        File.expand_path("templates", __dir__)
      end

      def create_config_file
        cmd = "grep -rnE \"(ENV\\\.fetch)|(ENV\\\[)\" #{Rails.root.join('app')} #{Rails.root.join('config')} #{Rails.root.join('lib')}"
        grep = `#{cmd}`
        variable_keys = grep.scan(/ENV\[['"]([a-zA-Z0-9_]+)['"]\]|ENV\.fetch[\ \(]?['"]([a-zA-Z0-9_]+)/)
                            .flatten(1)
                            .compact
                            .uniq
                            .sort
        content = ERB.new(IO.read(File.join(source_paths, 'env.yml.erb')))
                     .result(binding.tap { |b| b.local_variable_set(:variable_keys, variable_keys) })
        create_file 'config/env.yml', content
      end
    end
  end
end
