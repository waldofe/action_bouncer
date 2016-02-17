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

      private

      before_action :authorize_resource

      def authorize_resource
        fail Unauthorized if resource.present? && !authorized?
      end

      def authorized?
        authorized_action? && matches_resource_condition?
      end

      def authorized_action?
        allowed_actions.include?(params[:action].to_sym) ||
          allowed_actions.include?(:all)
      end

      def matches_resource_condition?
        conditions.any? { |condition| resource.send(condition).present? }
      end

      def resource
        send(self.class._authorization.send(:resource))
      end

      def conditions
        self.class._authorization.conditions
      end

      def allowed_actions
        self.class._authorization.allowed_actions
      end
    end
  end
end
