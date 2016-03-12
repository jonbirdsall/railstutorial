# app/controllers/users_controller.rb
# Author: Jon Birdsall
# Desc: Handles users aspect of the app


class UsersController < ApplicationController
  # make sure the user is logged in before trying to do udate or edit actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  
  # make sure the correct user is loged in before trying to do update or edit actions
  before_action :correct_user, only: [:edit, :update]
  
  # make sure only admins can delete users
  before_action :admin_user, only: [:destroy]
  
  
  # list all users in the database
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # renders users/new.html.erb user form view
  # Rt: GET /users/new
  # C.r.u.d
  def new
    # give form access to model methods
    @user = User.new
  end
  
  # save new user to db based on params entered in new user form
  # Rt: POST /users
  # C.r.u.d
  def create
    # @user holds values from submitted form
    @user = User.new(user_params)
    
    # attempt to save the new user, log the user in if successful and redirect
    # to user details page
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      # something went wrong, re-render the new user form with previously entered
      # information, errors will be displayed above form
      render 'new'
    end # if
  end # create
  
  # render users/show.html.erb view of user with id in url params
  # Rt: GET /users/:id
  # c.R.u.d
  def show
    # find the user by the user id in the route params
    # (this will likely be moved to its own before method)
    @user = User.find(params[:id])
    
    @microposts = @user.microposts.paginate(page: params[:page])
  end # show
  
  # render users/edit.html.erb
  # Rt: GET users/:id/edit
  # c.r.U.d
  def edit
    # find the user by the user id in the route params
    # (this will likely be moved to its own before method)
    @user = User.find(params[:id])
  end # edit
  
  # handle submission of edit user form
  # Rt: PATCH users/:id
  # c.r.U.d
  def update
    # find the user by the user id in the route params
    # (this will likely be moved to its own before method)
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # something went wrong, go back to the edit form with existing user info
      render 'edit'
    end # if
  end # update
  
  # delete user from the database
  # Rt: DELETE /users/:id
  # c.r.u.D
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end # destroy
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end # following
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end # followers
  
  private
    
    # define set of params available to class
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end
    
    # Before filters
    

    
    # confirms the correct user is logged in
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # confirms the user is an admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
