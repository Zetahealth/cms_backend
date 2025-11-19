class ContainerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "container_#{params[:slug]}"
  end
end
