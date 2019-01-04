class GuidesController < ApplicationController
  layout 'guides'

  def tour
  end

  def label_stamps
    @parent_labels = Label.where(parent_id: nil).limit(2)
    @ad_label = Label.find_by(name: 'Ads')
    @analytics_label = Label.find_by(name: 'Analytics')
  end
end
