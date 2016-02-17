require 'spec_helper'

class ArrayParamsController < ActionController::Base
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

describe ArrayParamsController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'array_params#index'
      get '/new' => 'array_params#new'
      get '/edit' => 'array_params#edit'
    end
  end

  it { expect{ get :edit }.to raise_error(ActionBouncer::Unauthorized) }
  it { expect{ get :index }.not_to raise_error }
  it { expect{ get :new }.not_to raise_error }
end
