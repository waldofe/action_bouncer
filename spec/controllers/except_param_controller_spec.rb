require 'spec_helper'

class ExceptParamController < ActionController::Base
  helper_method :current_user

  include ActionBouncer

  allow :current_user,
    to: [:index, :new],
    except: :edit,
    if: :admin?

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

describe ExceptParamController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'except_param#index'
      get '/new' => 'except_param#new'
      get '/edit' => 'except_param#edit'
    end
  end

  context 'when authorized' do
    before do
      allow(subject).to receive(:current_user) { OpenStruct.new(admin?: true) }
    end

    it { expect{ get :edit }.not_to raise_error }
    it { expect{ get :index }.not_to raise_error }
    it { expect{ get :new }.not_to raise_error }
  end

  context 'when not authorized' do
    before do
      allow(subject).to receive(:current_user) { OpenStruct.new(admin?: false) }
    end

    it { expect{ get :edit }.not_to raise_error }
    it { expect{ get :index }.to raise_error{ ActionBouncer::Unauthorized } }
    it { expect{ get :new }.to raise_error{ ActionBouncer::Unauthorized } }
  end
end

