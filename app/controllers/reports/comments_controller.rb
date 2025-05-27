# frozen_string_literal: true

module Reports
  class CommentsController < CommentsController
    def create
      report = Report.find(params[:book_id])
      comment = report.comments.build(comment_params)

      if comment.save
        redirect_to report, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
      else
        render template: "#{report.class.model_name.plural}/show", status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body).merge(user_id: current_user.id)
    end
  end
end
