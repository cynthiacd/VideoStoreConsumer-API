class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  # validates :movie, uniqueness: { scope: :customer }
  validates :due_date, presence: true
  validate :due_date_in_future, on: :create
  validate :check_inventory, on: :create

  after_initialize :set_checkout_date

  def check_inventory
    if self.movie.available_inventory < 1
      errors.add(:inventory, "There is not enough inventory to check out this movie")
    end
  end

  def self.first_outstanding(movie, customer)
    self.where(movie: movie, customer: customer, returned: false).order(:due_date).first
  end

  def self.overdue
    self.where(returned: false).where("due_date < ?", Date.today)
  end

private
  def due_date_in_future
    return unless self.due_date
    unless due_date > self.checkout_date
      errors.add(:due_date, "Must be in the future")
    end
  end

  def set_checkout_date
    self.checkout_date ||= Date.today
  end
end
