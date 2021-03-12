class Skill < ApplicationRecord
	validates :label, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
end
