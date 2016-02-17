require 'action_bouncer/authorization'

module ActionBouncer
  class Unauthorized < StandardError; end

  def self.included(klass)
    klass.class_eval do
      def self.allow(resource, options)
        @_authorization = Authorization.new(resource, options)
      end

      def self._authorization
        @_authorization
      end

      before_action { self.class._authorization.try(:authorize!, self) }
    end
  end
end
