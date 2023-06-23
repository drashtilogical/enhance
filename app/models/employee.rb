class Employee < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :projects, through: :assignments
end
