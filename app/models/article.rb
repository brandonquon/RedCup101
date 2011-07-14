class Article < ActiveRecord::Base
  acts_as_voteable
  validates :title, :presence => true
  validates :body, :presence => true
  default_scope order('created_at DESC')
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments
  has_many :comments, :order => "created_at DESC" 
  scope :published, where("articles.published_at IS NOT NULL")
  scope :draft, where("articles.published_at IS NULL")
  scope :recent, lambda { published.where("articles.published_at > ?", 1.week.ago.to_date)}
  scope :where_title, lambda { |term| where("articles.title LIKE ?", "%#{term}%") }
 
  def long_title
    "#{title} - #{published_at}"
  end
  
  def published?
    published_at.present?
  end
  
  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
