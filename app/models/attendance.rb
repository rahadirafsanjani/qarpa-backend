class Attendance < ApplicationRecord
  belongs_to :user

  def self.get_all_attendace params = {}
    attendances = Attendance.includes(:user).where(params)
    attendances.map do | attendance |
      attendance.history_response
    end
  end

  def history_response
    {
      "id": self.id,
      "user_id": self.user_id,
      "name": self.user.name,
      "latitude": self.latitude,
      "longitude": self.longitude,
      "check_in": self.check_in,
      "check_out": self.check_out,
      "duration": (self.check_out - self.check_in),
      "status": self.status
    }
  end
end
