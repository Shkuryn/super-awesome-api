module Api
  module V1
    class CommentsController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :authenticate, only: [:create, :destroy]
      
      def index
        @comments = if params[:post_id]
                      Comment.with_post(params[:post_id])
                    else
                      Comment.all
                    end
        render json: @comments
      end

      def create
        @comment = @post.comments.new(comment_params)
        @comment.user_id = @user.id
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment = Comment.where('post_id = ?', params[:id]).where('user_id = ?', @user.id)
        if @comment.count > 0
            @comment.each {|com| com.destroy} 
        else
          render json: {comment: "not found"}, status: :not_found
        end 
      end

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          @user = User.find_by(token: token)
          @post = Post.find_by(id: params[:post_id])
        end
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:body, :post_id)
      end
    end
  end
end
