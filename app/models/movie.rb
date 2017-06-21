class Movie < ApplicationRecord

  # validates :release_date, uniqueness: true
  # validates :external_id, uniqueness: true, on: :create

  has_many :rentals
  has_many :customers, through: :rentals
  validates :release_date, presence: true, uniqueness: true

  def available_inventory
    self.inventory - Rental.where(movie: self, returned: false).length
  end

  def image_url
    orig_value = read_attribute :image_url
    if !orig_value
      MovieWrapper::DEFAULT_IMG_URL
    else
      MovieWrapper.construct_image_url(orig_value)
    end
  end
end
