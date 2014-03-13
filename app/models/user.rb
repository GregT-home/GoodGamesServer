class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

# not generated by devise, but mentioned in the RailsCast, episode 209
#attr_accessible :email, :password, :password_confirmation
end