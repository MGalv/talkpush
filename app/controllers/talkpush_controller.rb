class TalkpushController < ApplicationController

  def load_candidates
    begin
      TalkpushUpdater.update_candidates_list
      flash[:success] = "Excellent news, your candidates list has been updated!"
    rescue => _e
        flash[:danger] = "Sad news, your candidates couldn't be updated. Please, try again."
    end
    redirect_to root_path
  end
end