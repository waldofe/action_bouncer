require 'spec_helper'

class MultipleAllowancesController < ActionController::Base
  helper_method :current_user

  include ActionBouncer

  allow :current_user, to: [:index, :new], if: [:leader?, :admin?]
  allow :current_user, to: :edit, if: :admin?

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

describe MultipleAllowancesController do
  before do
    Rails.application.routes.draw do
      get '/index' => 'multiple_allowances#index'
      get '/new' => 'multiple_allowances#new'
      get '/edit' => 'multiple_allowances#edit'
    end
  end

  context 'when authorized' do
    context 'as leader' do
      before do
        allow(subject).to receive(:current_user) { OpenStruct.new(leader?: true) }
      end

      it { expect{ get :index }.not_to raise_error }
      it { expect{ get :new }.not_to raise_error }
    end

    context 'as admin' do
      before do
        allow(subject).to receive(:current_user) { OpenStruct.new(admin?: true) }
      end

      it { expect{ get :index }.not_to raise_error }
      it { expect{ get :new }.not_to raise_error }
      it { expect{ get :edit }.not_to raise_error }
    end
  end

  context 'when not authorized' do
    context 'when leader' do
      before do
        allow(subject).to receive(:current_user) { OpenStruct.new(leader?: true) }
      end

      it { expect{ get :edit }.to raise_error{ ActionBouncer::Unauthorized } }
    end
  end
end

