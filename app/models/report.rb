# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioning_relationships, class_name: 'Mention',
                                      foreign_key: 'mentioning_id',
                                      dependent: :destroy,
                                      inverse_of: :mentioning
  has_many :mentioning_reports, through: :mentioning_relationships, source: :mentioned
  has_many :mentioned_relationships,  class_name: 'Mention',
                                      foreign_key: 'mentioned_id',
                                      dependent: :destroy,
                                      inverse_of: :mentioned
  has_many :mentioned_reports, through: :mentioned_relationships, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def execute_save_procedure
    transaction do
      save!
      refresh_mentions
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def execute_update_procedure(report_params)
    transaction do
      update!(report_params)
      refresh_mentions
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def collect_mentioned_report_ids
    content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq
  end

  def refresh_mentions
    mentioning_relationships.destroy_all
    collect_mentioned_report_ids.each do |mentioned_report_id|
      mentioning_relationships.create!(mentioned_id: mentioned_report_id)
    end
  end
end
