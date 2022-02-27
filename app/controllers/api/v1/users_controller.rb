module Api
  module V1
      class UsersController < ApplicationController

        def create
          @user = User.new(user_params)
          if @user.save
            render status: :created
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
        def index
          render json:  User.all
        end
       
        private
       
        def user_params
          params.require(:user).permit(:name, :email, :password)
        end
      end
  end
end
