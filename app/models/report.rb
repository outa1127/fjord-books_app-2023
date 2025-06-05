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
    ActiveRecord::Base.transaction do
      save!
      create_mentions
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def create_mentions
    collect_mentioned_report_ids.each do |mentioned_report_id|
      mentioning_relationships.create!(mentioned_id: mentioned_report_id)
    end
  end

  def collect_mentioned_report_ids
    content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
  end

  def execute_update_procedure(report_params)
    ActiveRecord::Base.transaction do
      update!(report_params)
      update_mentions
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update_mentions
    old_mentioned_report_ids = mentioning_relationships.map(&:mentioned_id)
    new_mentioned_report_ids = collect_mentioned_report_ids

    added_mentioned_report_ids = new_mentioned_report_ids - old_mentioned_report_ids
    deleted_mentioned_report_ids = old_mentioned_report_ids - new_mentioned_report_ids

    added_mentioned_report_ids.each do |add_mentioned_report_id|
      mentioning_relationships.create!(mentioned_id: add_mentioned_report_id)
    end

    mentioning_relationships.where(mentioned_id: deleted_mentioned_report_ids).find_each(&:destroy!)
  end
end
