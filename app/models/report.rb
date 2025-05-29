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

  def create_mentions
    return unless content.include?('http://localhost:3000/reports')

    mentioned_report_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
    mentioned_report_ids.each do |mentioned_report_id|
      mentioning_relationships.create(mentioned_id: mentioned_report_id)
    end
  end

  def update_mentions(mentioned_report_ids)
    new_mentioned_report_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)

    add_mentioned_report_ids = new_mentioned_report_ids - mentioned_report_ids
    delete_mentioned_report_ids = mentioned_report_ids - new_mentioned_report_ids

    add_mentioned_report_ids.each do |add_mentioned_report_id|
      mentioning_relationships.create(mentioned_id: add_mentioned_report_id)
    end

    mentioning_relationships.where(mentioned_id: delete_mentioned_report_ids).destroy_all
  end
end
