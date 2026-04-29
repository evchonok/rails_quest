class Mission < ApplicationRecord
  belongs_to :agent

  validates :title, presence: true
  validates :status, presence: true
  validates :status, inclusion: { in: %w[assigned in_progress completed] }

  def status=(value)
    if value.present? && !%w[assigned in_progress completed].include?(value)
      raise ArgumentError, "Invalid status: #{value}"
    end
    super
  end
end
