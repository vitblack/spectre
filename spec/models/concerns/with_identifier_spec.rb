# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'WithIdentifier' do
  let(:model) { described_class.new }

  it 'generate Identifier on validation' do
    expect { model.valid? }.to change(model, :identifier).from(nil)
  end
end