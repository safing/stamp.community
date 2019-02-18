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
        @stamp.create_activity(
          key: @stamp.key_for(action: :create),
          owner: current_user,
          recipient: @stamp.stampable
        )
        redirect_to(flag_stamp_path(@stamp.id), flash: { success: 'Stamp created successfully' })
      else
        render 'new'
      end
    end

    def show
      @commentable = @votable = @stamp = Stamp::Flag.find(params[:id])
      @comments = @commentable.comments.order(:created_at)
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
            .merge("#{params[:flag_stamp][:prompt_group]}": true)
    end

    def load_stampable
      App.find(params[:app_id] || params[:flag_stamp][:app_id])
    end
  end
end
