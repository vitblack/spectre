# frozen_string_literal: true

module Customer
  class CreateService < ApplicationService
    include Interactor::Organizer

    delegate :user, to: :context

    organize RequestService, AttachToUserService
  end
end
