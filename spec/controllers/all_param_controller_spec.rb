require 'spec_helper'

class AllParamController < ActionController::Base
  helper_method :current_user

  def current_user
    OpenStruct.new(admin?: true)
  end

  include ActionBouncer

  allow :current_user, to: :all, if: :admin?

  def index
    render nothing: true, status: :success
  end

  def new
    render nothing: true, status: :success
  end

  def edit
    render nothing: true, status: :success
  end
end

describe AllParamController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'all_param#index'
      get '/new' => 'all_param#new'
      get '/edit' => 'all_param#edit'
    end
  end

  it { expect{ get :edit }.not_to raise_error }
  it { expect{ get :index }.not_to raise_error }
  it { expect{ get :new }.not_to raise_error }
end

