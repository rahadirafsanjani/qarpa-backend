class Attendance < ApplicationRecord
  belongs_to :user

  def self.get_all_attendace params = {}
    attendances = Attendance.includes(:user).where(params).where(status: nil)
    attendances.map do | attendance |
      attendance.history_response
    end
  end

  def show_attribute
    {
      "id": self.id,
      "status": self.status,
      "checkin_at": self.date_formater(self.check_in)
    }
  end

  def history_response
    {
      "id": self.id,
      "user_id": self.user_id,
      "name": self.user.name,
      "latitude": self.latitude,
      "longitude": self.longitude,
      "check_in": self.date_formater(self.check_in),
      "check_out": self.date_formater(self.check_out),
      "duration": (self.check_out - self.check_in),
      "status": self.status
    }
  end

  def date_formater date 
    date.strftime("%d-%m-%Y %H:%M") if date.present?
  end
end
