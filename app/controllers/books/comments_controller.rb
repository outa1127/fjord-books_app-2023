# frozen_string_literal: true

module Books
  class CommentsController < CommentsController
    def render_view_comment_error
      'books/show'
    end

    def set_commentable
      @book = Book.find(params[:book_id])
      @commentable = @book
    end
  end
end
