class RepostsController < ApplicationController
  before_action :logged_in_user
  before_action :set_micropost

  def create
    repost = @micropost.reposts.build(repost_user_id: current_user.id, reposted_id: @micropost.id)
    if repost.save
      micropost = current_user.microposts.build(content: @micropost.content)
      if micropost.save
        flash[:success] = "Micropost reposted!"
      end
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    return redirect_to root_url if @micropost.reposted_id.nil? || !Micropost.exists?(@micropost.reposted_id)
    Micropost.find(@micropost.reposted_id).update_attribute(:repost_user_id, nil)
    @micropost.destroy
    flash[:success] = "Micropost unreposted"
    redirect_to request.referrer || root_url
  end

  private
  def set_repost
    if Micropost.exists?(:id => params[:id])
      @micropost = Micropost.find(params[:id])
    else
      redirect_to request.referrer || root_url
    end
  end
end
