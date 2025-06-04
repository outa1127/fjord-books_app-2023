# frozen_string_literal: true

require 'application_system_test_case'
require 'test_helper'

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  def setup
    @report = reports(:alice_report)

    visit root_url
    @user = users(:alice)
    sign_in(@user)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'p', text: @report.content
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'テスト日報'
    fill_in '内容', with: 'テストです'
    click_on '登録する'

    assert_text '日報が作成されました'
    assert_text 'テスト日報'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'タイトル(編集済み)'
    fill_in '内容', with: '本文(編集済み)'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'タイトル(編集済み)'
  end

  test 'should destroy Report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'テスト日報'
    fill_in '内容', with: 'テスト'
    click_on '登録する'

    assert_text 'テスト日報'

    click_on 'この日報を削除'

    assert_text '日報が削除されました。'

    assert_no_text 'テスト日報'
  end
end
