module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = :"@#{name}"
        history_var_name = :"@#{name}_history"

        define_method(name) { instance_variable_get(var_name) }
        define_method(:"#{name}=") do |value|
          instance_variable_set(var_name, value)
          instance_variable_set(history_var_name, []) unless instance_variable_defined?(history_var_name)
          instance_variable_get(history_var_name) << value
        end

        define_method(:"#{name}_history") { instance_variable_get(history_var_name) }
      end
    end

    def strong_attr_accessor(name, type)
      define_method(name) { instance_variable_get(:"@#{name}") }
      define_method(:"#{name}=") do |value|
        raise ArgumentError, 'Invalid type!' unless value.is_a?(type)

        instance_variable_set(:"@#{name}", value)
      end
    end
  end

  module InstanceMethods
  end
end
