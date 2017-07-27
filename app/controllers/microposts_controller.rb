class MicropostsController < ApplicationController
  before_action :set_micropost, only: :destroy
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)

    respond_to do |format|
      if @micropost.save
        flash[:success] = 'Post created.'
        format.html { redirect_to root_url }
        format.json { render :show, status: :created, location: @micropost }
      else
        # if user creates invalid micropost,
        @feed_items = []

        format.html { render 'static_pages/home' }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      flash[:success] = 'Post deleted.'
      format.html { redirect_back(fallback_location: root_url) }
      format.json { head :no_content }
    end
  end

  private
    def set_micropost
      @micropost = current_user.microposts.find_by(id: params[:id]) if logged_in?
    end

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      redirect_to root_url if @micropost.nil?
    end
end
