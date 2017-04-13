require 'securerandom'

class ShortenedUrl < ActiveRecord::Base

  validates :long_url, :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  validate :no_spamming
  validate :nonpriminum_max

  def self.random_code
    taken = true
    while taken
      taken = false
      code = SecureRandom.urlsafe_base64
      taken = true if ShortenedUrl.exists?(short_url: code)
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(user_id: user.id, short_url: short_url, long_url: long_url)
  end

  def self.prune(n)
    delete_links = ShortenedUrl.joins(:visits)
                    .where("visits.created_at < ?", n.minutes.ago)
                    # .having("COUNT(*) = 0")
                    # .group("shortened_urls.id")

    # delete_links = Visit.all.where("created_at > ?", n.minutes.ago)
    #            .joins(:shortened_urls)
    #            .having("COUNT(*) = 0")
    #            .group("shortened_url_id")
    # destroy_all("", n.minutes.ago)
    delete_links.each do |link|
      link.destroy
    end
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  has_many :taggings,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Tagging

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.select(:user_id).count
  end

  def num_recent_uniques
    self.visitors.select(:user_id).where("visits.created_at > ?", 1.minutes.ago).count
  end

  def no_spamming
    linkes_count = ShortenedUrl
            .where(user_id: submitter.id)
            .where("created_at > ?", 1.minutes.ago).count
    if linkes_count >= 5
      errors.add(:links, "are too many")
    end
  end

  def nonpriminum_max
    return if submitter.premium
    linkes_count = ShortenedUrl
            .where(user_id: submitter.id).count
    if linkes_count >= 5
      errors.add(:Max, "amount of non-premium links is 5")
    end
  end
end
