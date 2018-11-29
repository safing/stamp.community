module Stamps
  class LabelsController < ApplicationController
    def new
      @stamp = Stamp::Label.new
      @stamp.stampable = load_domain
      @stamp.comments.build

      load_labels
      authorize @stamp
    end

    def create
      @stamp = Stamp::Label.new(stamp_params)
      @stamp.stampable = load_domain
      @stamp.creator = @stamp.comments.first.user = current_user
      authorize @stamp

      if @stamp.save
        redirect_to(label_stamp_path(@stamp.id), flash: { success: 'Stamp created successfully' })
      else
        load_labels
        render 'new'
      end
    end

    def show
      @commentable = @votable = @stamp = Stamp::Label.find(params[:id])
      @comments = @commentable.comments
      @comment = Comment.new

      authorize @stamp
    end

    def index
      @stamp = Stamp::Flag.first
    end

    private

    def stamp_params
      params.require(:label_stamp)
            .permit(
              :label_id,
              :percentage,
              comments_attributes: [:content]
            )
    end

    def load_domain
      Domain.find_by(name: params[:domain_name] || params[:label_stamp][:domain])
    end

    def load_labels
      @labels = Label.order(Arel.sql('LOWER(name) ASC'))
    end
  end
end
