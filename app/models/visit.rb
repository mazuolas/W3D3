class Visit < ActiveRecord::Base
  validates :user_id, :shortened_url_id, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :short_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :ShortenedUrl

  def self.record_visit!(user, shortened_url)
    shortened_url_id = ShortenedUrl.find_by(short_url: shortened_url).id
    Visit.create!(user_id: user.id, shortened_url_id: shortened_url_id)
  end
end
