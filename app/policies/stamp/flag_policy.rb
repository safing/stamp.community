class Stamp::FlagPolicy < StampPolicy
  def create?
    access_flag_stamps?
  end

  def show?
    access_flag_stamps?
  end

  def update?
    false
  end
end
