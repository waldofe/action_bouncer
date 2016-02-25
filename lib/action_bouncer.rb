require 'action_bouncer/allowance'

module ActionBouncer
  def self.included(klass)
    klass.class_eval do
      def self.allow(resource, options)
        @_allowance = Allowance.new(resource, options)
      end

      def self._allowance
        @_allowance
      end

      before_action { self.class._allowance.try(:authorize!, self) }
    end
  end
end
