module Stamps
  class FlagsController < ApplicationController
    def new
      # needs a default for prompt_group checkboxes
      @stamp = Stamp::Flag.new(prompt: true)
      @stamp.stampable = load_stampable
      @stamp.comments.build

      authorize @stamp
    end

    def create
      @stamp = Stamp::Flag.new(stamp_params)
      @stamp.stampable = load_stampable
      @stamp.creator = current_user
      authorize @stamp

      if @stamp.save
        redirect_to(flag_stamp_path(@stamp.id), flash: { success: 'Stamp created successfully' })
      else
        render 'new'
      end
    end

    def show
      @commentable = @votable = @stamp = Stamp::Flag.find(params[:id])
      @comments = @commentable.comments
      @comment = Comment.new

      authorize @stamp
    end

    def index; end

    private

    def stamp_params
      params.require(:flag_stamp)
            .permit(
              :internet,
              :lan,
              :localhost,
              :p2p,
              :server
            )
            .merge("#{params[:stamp][:prompt_group]}": true)
    end

    def load_stampable
      App.find(params[:app_id] || params[:flag_stamp][:app_id])
    end
  end
end
