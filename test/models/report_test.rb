# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @alice_report = reports(:alice_report)
    @mentioned_report = reports(:mentioned_report)
  end
  test 'editable?' do
    assert_equal true, @alice_report.editable?(@alice)
  end

  test 'not_editable?' do
    assert_equal false, @alice_report.editable?(@bob)
  end

  test 'created_on' do
    assert_equal Date.parse('2023-10-01 12:00:00'), @alice_report.created_on
  end

  test 'create report and check mentionn reflected' do
    content_with_mention = "この日報が素晴らしかったです: http://localhost:3000/reports/#{@mentioned_report.id}"
    report = Report.create!(
      user: @alice,
      title: 'test report',
      content: content_with_mention
    )
    assert_includes report.reload.mentioning_reports, @mentioned_report
  end
end
