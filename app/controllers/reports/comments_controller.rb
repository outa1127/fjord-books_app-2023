# frozen_string_literal: true

module Reports
  class CommentsController < CommentsController
    private

    def set_commentable
      @report = Report.find(params[:report_id])
      @commentable = @report
    end
  end
end
