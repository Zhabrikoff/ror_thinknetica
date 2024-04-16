module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, validation_class_type, params = nil)
      @validations ||= []
      @validations << { name: name, validation_class_type: validation_class_type, params: params }
    end

    def validations
      @validations || []
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        value = instance_variable_get(:"@#{validation[:name]}")
        send(validation[:validation_class_type], validation[:name], value, *validation[:params])
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def presence(attr_name, value)
      raise "#{attr_name} cannot be empty!" if value.nil? || value.empty?
    end

    def format(attr_name, value, regex)
      raise "#{attr_name} has an invalid format!" unless value =~ regex
    end

    def class_type(attr_name, value, attr_class)
      raise "#{attr_name} has the wrong type!" unless value.is_a?(attr_class)
    end
  end
end
