class ScreenChannel < ApplicationCable::Channel
  # def subscribed
  #   # stream_from "some_channel"
  # end
  def subscribed
    # params: { slug: "screen1" }
    slug = params[:slug]
    if slug.present?
      # stream_from "screen_#{slug}_channel"
      stream_from "screen_#{params[:slug]}"
    end
  end

  

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end


# class ScreenChannel < ApplicationCable::Channel
#   def subscribed
#     stream_from "screen_#{params[:slug]}"
#   end
# end
