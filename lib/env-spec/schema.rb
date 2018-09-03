module EnvSpec
  class Schema
    class ValidationError < StandardError; end

    def initialize(path: nil)
      @config = YAML.load_file(path || Rails.root.join('config', 'env.yml')).with_indifferent_access
    end

    def validate!
      errors = @config[:variables].map { |k, v|
        variable = Variable.new(v.merge(key: k))
        variable.valid? ? nil : variable.error
      }.compact

      errors.each do |e|
        puts e.message
      end
      return unless errors.present? && raise_error?
      raise ValidationError.new('Violating env spec schema')
    end

    def raise_error?
      @config[:raise_error] != false
    end
  end
end
