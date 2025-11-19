class ScreenBroadcaster
  def self.refresh(screen)
    ActionCable.server.broadcast("screen_#{screen.id}", {
      action: "refresh"
    })
  end

  def self.container_refresh(container)
    ActionCable.server.broadcast("container_#{container.id}", {
      action: "refresh"
    })
  end

end
