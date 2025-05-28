# frozen_string_literal: true

module Books
  class CommentsController < CommentsController
    def create
      book = Book.find(params[:book_id])
      comment = book.comments.build(comment_params)

      if comment.save
        redirect_to book, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
      else
        render template: "#{book.class.model_name.plural}/show", status: :unprocessable_entity
      end
    end
  end
end
