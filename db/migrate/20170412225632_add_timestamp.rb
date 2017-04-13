class AddTimestamp < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :shortened_urls
  end
end
