# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  first_name                 :string
#  last_name                  :string
#  admin                      :boolean          default(FALSE)
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :inet
#  last_sign_in_ip            :inet
#  confirmation_token         :string
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  address                    :string
#  zip_code                   :string
#  cell_number                :string
#  home_number                :string
#  driver_license             :string
#  social_security            :string
#  four_digit_no              :string
#  date_of_birth              :date
#  profile_image_file_name    :string
#  profile_image_content_type :string
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#  state_issue                :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :registerable
         # , :confirmable

  has_many :payments

  validates_presence_of :address, :zip_code, :cell_number, :home_number, :date_of_birth, :first_name, :last_name, :address

  validate :validate_social_security

  validates_length_of :zip_code, :minimum => 5, :maximum => 5

  validates_length_of :social_security, :minimum => 9, :maximum => 9

  validates_length_of :cell_number, :home_number, :minimum => 10, :maximum => 10

  attr_accessor :password_validity
  after_initialize :disable_password_on_create
  after_create :generate_password

  has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "user-login.png"
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/

  def disable_password_on_create
  	self.password_validity = false
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if password_validity
  end

  def full_name
  	"#{first_name} #{last_name}"
  end

  def send_pwd_instructions(pwd)
    Checkout.pwd_instructions(self, pwd).deliver_now!
  end

  def generate_random_string
    alphabets = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    random_string = (0...8).map { alphabets[rand(alphabets.length)] }.join
    random_string
  end

  def validate_social_security
    if self.social_security.present? and self.driver_license.present?
      self.errors[:base] << "Please fill either License or Social Security Number."
    elsif self.social_security.blank? and self.driver_license.blank?
      self.errors[:base] << "Please fill either License or Social Security Number."
    end
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

    send_pwd_instructions(rand_string) #sending email to user with temp pwd
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
