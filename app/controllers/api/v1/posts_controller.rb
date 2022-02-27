module Api
  module V1
      class PostsController < ApplicationController
        include ActionController::HttpAuthentication::Token::ControllerMethods
        before_action :authenticate, only: [:create, :destroy]
        
        def index
          
          @par = {}
          @par.store('user_id', params[:user_id].to_i) if params[:user_id]
          @par.store('category', params[:category]) if params[:category]
          if @par.size.zero?
            @posts = Post.find_by_sql(get_query_text)
          else
            @posts = Post.filter(@par)
          end
          render json: @posts
        end

        def show
          @posts = Post.by_post_id(params[:id]).first
          render json: @posts
        end

        def create
      
          @post = @user.posts.new(post_params)
          if @post.save
              render json: @post, status: :created
          else
              render json: @post.errors, status: :unprocessable_entity
          end
        end
     
        def destroy
          
          @post = @user.posts.find_by(id: params[:id])
          if @post
            @post.destroy
          else
            render json: {post: "not found"}, status: :not_found
          end
                
        end
   
        private
      
        def authenticate
          authenticate_or_request_with_http_token do |token, options|
          @user = User.find_by(token: token)
          
         end
        end
        def post_params
          params.require(:post).permit(:title, :body, :user_id)
        end  
        
       
        def set_post
          @post = Post.find(params[:id])
        end
  
        # # Only allow a list of trusted parameters through.
        # def post_params
        #   params.fetch(:article, {})
        # end
  
        def get_query_text
          sql =
            "SELECT posts.id,
            posts.title,
            posts.user_id,
            CASE
   WHEN Bit_length(posts.body) > 500 THEN Substring(posts.body FROM 1
   FOR 500)
   || '...'
   ELSE posts.body
 end           AS body,
                  posts.created_at,
                  Count(c.body) AS comments_count
 FROM   posts
 LEFT JOIN comments c
 ON posts.id = c.post_id
 GROUP  BY posts.id
 ORDER  BY created_at DESC"
        end


      end
        
  end
end