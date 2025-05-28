# frozen_string_literal: true

module Reports
  class CommentsController < CommentsController
    def set_commentable
      @commentable = Report.find(params[:report_id])
    end
  end
end
