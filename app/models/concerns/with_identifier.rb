# frozen_string_literal: true

module WithIdentifier
  extend ActiveSupport::Concern

  included do
    before_validation :generate_identifier

    def generate_identifier
      loop do
        self.identifier = SecureRandom.hex
        break unless self.class.exists?(identifier: identifier)
      end
    end
  end
end
