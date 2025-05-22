# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: 'Report', inverse_of: :mentioned_relationships
  belongs_to :mentioning, class_name: 'Report', inverse_of: :mentioning_relationships
end
