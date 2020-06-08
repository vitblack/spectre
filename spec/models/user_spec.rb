# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'WithIdentifier'
end
