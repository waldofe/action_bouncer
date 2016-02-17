require 'spec_helper'

class NoSetupController < ActionController::Base
  helper_method :current_user

  include ActionBouncer

  def index
    render nothing: true, status: :success
  end
end

describe NoSetupController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'no_setup#index'
    end
  end

  it { expect{ get :index }.not_to raise_error }
end

