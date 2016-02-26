require 'action_bouncer/allowance'
require 'action_bouncer/authorization'

module ActionBouncer
  def self.included(klass)
    klass.class_eval do
      def self.allow(resource, options)
        @_allowances ||= []
        @_allowances << Allowance.new(resource, options)
      end

      def self._authorization
        Authorization.new(@_allowances)
      end

      before_action { self.class._authorization.try(:authorize!, self) }
    end
  end
end
