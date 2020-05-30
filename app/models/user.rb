# frozen_string_literal: true

class User < ApplicationRecord
  include WithIdentifier

  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :trackable

  validates :identifier, uniqueness: true
  validates :customer_id, uniqueness: true, allow_nil: true
end
