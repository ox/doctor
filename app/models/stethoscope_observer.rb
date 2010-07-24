class StethoscopeObserver < ActiveRecord::Observer
  def after_save(stethoscope)
    stethoscope.get_status
  end
end
