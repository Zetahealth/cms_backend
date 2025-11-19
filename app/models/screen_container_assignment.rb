class ScreenContainerAssignment < ApplicationRecord
  belongs_to :screen_container
  belongs_to :screen
  after_create :update_live_screen
  
  private

  def update_live_screen
    puts "Screen Container Assignment created--------------------------: #{self.id}"
    screen_container = ScreenContainer.find(self.screen_container_id)
    ScreenBroadcaster.container_refresh(screen_container)
  end



end


  