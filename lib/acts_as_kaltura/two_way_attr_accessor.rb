require 'active_support/concern'

module ActsAsKaltura
  module TwoWayAttrAccessor
    extend ActiveSupport::Concern

    module ClassMethods
      def dual_attr_accessor(*var_names)
        var_names.each do |m|
          m           = m.to_s
          setter_proc = lambda do |value|
            self.instance_variable_set :"@#{m.underscore}", value
          end
          self.send :define_method, :"#{m}=", setter_proc
          self.send :define_method, :"#{m.underscore}=", setter_proc

          getter_proc = lambda { self.instance_variable_get :"@#{m.underscore}" }
          self.send :define_method, m.to_sym, getter_proc
          self.send :define_method, :"#{m.underscore}", getter_proc
        end
      end
    end
  end
end

class Object
  include ActsAsKaltura::TwoWayAttrAccessor
end