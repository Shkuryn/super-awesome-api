module Api
  module V1
      class PostsController < ApplicationController
        include ActionController::HttpAuthentication::Token::ControllerMethods
        before_action :authenticate, only: [:create, :destroy]
        def index
          @posts = Post.all
          render json: @posts
        end
        def create
         # debugger
          @post = @user.posts.new(post_params)
          if @post.save
              render json: @post, status: :created
          else
              render json: @post.errors, status: :unprocessable_entity
          end
        end
   
        private
      
        def authenticate
          authenticate_or_request_with_http_token do |token, options|
          @user = User.find_by(token: token)
          #sign_in(@user)
         end
        end
        def post_params
          params.require(:post).permit(:title, :body)
        end   


      end
        
  end
end