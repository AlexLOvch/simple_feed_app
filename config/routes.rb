# frozen_string_literal: true

Rails.application.routes.draw do
  get '/feed', to: 'apartments#index'
  root 'apartments#index'
end
