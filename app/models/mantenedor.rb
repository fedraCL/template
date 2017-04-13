class Mantenedor < ActiveRecord::Base
  def self.navieras
    Mantenedor.where(:tipo => :naviera).order(:id)
  end
end
