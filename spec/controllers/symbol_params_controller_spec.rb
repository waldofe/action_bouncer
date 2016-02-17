require 'spec_helper'

class SymbolParamsController < ActionController::Base
  helper_method :current_user

  def current_user
    OpenStruct.new(admin?: true)
  end

  include ActionBouncer

  allow :current_user, to: :index, if: :admin?

  def index
    render nothing: true, status: :success
  end

  def new
    render nothing: true, status: :success
  end
end

describe SymbolParamsController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'symbol_params#index'
      get '/new' => 'symbol_params#new'
    end
  end

  it { expect{ get :new }.to raise_error(ActionBouncer::Unauthorized) }
  it { expect{ get :index }.not_to raise_error }
end

