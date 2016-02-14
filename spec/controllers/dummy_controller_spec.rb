require 'spec_helper'
require 'ostruct'

class SingleParamsController < ActionController::Base
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

class MultipleParamsController < ActionController::Base
  helper_method :current_user

  def current_user
    OpenStruct.new(admin?: false, leader?: true)
  end

  include ActionBouncer

  allow :current_user, to: [:index, :new], if: [:admin?, :leader?]

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

describe SingleParamsController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'single_params#index'
      get '/new' => 'single_params#new'
    end
  end

  it { expect{ get :new }.to raise_error(ActionBouncer::Unauthorized) }
  it { expect{ get :index }.not_to raise_error }
end

describe MultipleParamsController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'multiple_params#index'
      get '/new' => 'multiple_params#new'
      get '/edit' => 'multiple_params#edit'
    end
  end

  it { expect{ get :edit }.to raise_error(ActionBouncer::Unauthorized) }
  it { expect{ get :index }.not_to raise_error }
  it { expect{ get :new }.not_to raise_error }
end
