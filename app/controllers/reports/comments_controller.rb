# frozen_string_literal: true

module Reports
  class CommentsController < CommentsController
    def render_view_comment_error
      'reports/show'
    end

    def set_commentable
      @report = Report.find(params[:report_id])
      @commentable = @report
    end
  end
end
