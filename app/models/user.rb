# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  admin                  :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  address                :string
#  zip_code               :string
#  cell_number            :string
#  home_number            :string
#  driver_license         :string
#  social_security        :string
#  four_digit_no          :string
#  date_of_birth          :date
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         # , :registerable, :confirmable

  has_many :payments

  validates_presence_of :address, :zip_code, :cell_number, :home_number, :date_of_birth, :first_name, :last_name, :address

  attr_accessor :password_validity
  after_initialize :disable_password
  after_create :generate_password

  has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "user-login.png"
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/

  def disable_password
  	self.password_validity = false
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if password_validity
  end

  def full_name
  	"#{first_name} #{last_name}"
  end

  def pwd_instructions(pwd)
    Checkout.pwd_instructions(self, pwd).deliver_now!
  end

  def generate_random_string
    alphabets = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    random_string = (0...8).map { alphabets[rand(alphabets.length)] }.join
    random_string
  end

  def generate_password
    rand_string = generate_random_string

    attributes = {
      :password => rand_string, 
      :password_confirmation => rand_string
    }

    self.password = attributes[:password]
    self.password_confirmation = attributes[:password_confirmation]
    self.save

    pwd_instructions(rand_string)
  end

  def card_number
    payments.last.card_last4.split(//).first(4).join
  end

  def card_expiry
    "#{payments.last.card_exp_month}-#{payments.last.card_exp_year}"
  end

  def orders
    payments.joins(:package).includes(:package)
  end
end
