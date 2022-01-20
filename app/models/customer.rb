class Customer < ApplicationRecord
    # Include default devise modules.
    #  Others available are:
    #   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :lockable,
            :recoverable, :trackable, :validatable
    include DeviseTokenAuth::Concerns::User
end
