# frozen_string_literal: true

class HomeService < ApplicationService
  include Interactor::Organizer

  delegate :user, to: :context

  organize Connections::ListService, Accounts::ListService
end
