# taken from forrager source code

class Address < ActiveRecord::Base
  acts_as_mappable({
    :default_units       => :miles,
    :default_formula     => :sphere,
    :distance_field_name => :distance,
    :lat_column_name     => :lat,
    :lng_column_name     => :lng
  })

  has_many :line_items
  has_many :carrier_service_rates
  has_many :shipping_options
  has_many :delivery_options
  has_many :pickup_options
  belongs_to :user

  validates :name, {
    :presence => {
      :message => _("Name cannot be blank. I'm a new phrase.")
    }
  }

  validates :address_1, {
    :presence => true
  }

  validates :city, {
    :presence => {
      :message => _("City cannot be blank.")
    }
  }

  validates :state, {
    :presence => {
      :message => _("State cannot be blank.")
    },
    :length => {
      :is => 2,
      :message => _("State must be two letters long.")
    },
    :inclusion => {
      :in => ApplicationHelper::STATES,
      :message => _("State must be a valid United State.")
    }
  }

  validates :zip, {
    :presence => {
      :message => _("Zip code cannot be blank.")
    },
    :numericality => {
      :message => _("Zip code must be a number.")
    },
    :length => {
      :is => 5,
      :message => _("Zip code must be 5 characters long.")
    }
  }

  after_create :geocode

  def to_s
    "#{self.address_1} #{self.address_2} #{self.city}, #{self.state} #{self.zip}"
  end

  def to_short_s
    "#{self.city}, #{self.state}"
  end

  # active shipping location
  def location
    ActiveMerchant::Shipping::Location.new(
      :country => 'US',  # will probably change in the future
      :state => self.state,
      :city => self.city,
      :zip => self.zip
    )
  end

  def self.get_default_for_user_id(user_id)
    Address.where(:user_id => user_id).order("default DESC").limit(1).first
  end

  def to_lat_lng
    Geokit::LatLng.new(self.lat, self.lng)
  end

  def geocode
    result = Geokit::Geocoders::MultiGeocoder.geocode(self.to_s)
    raise "Unable to geocode" unless result.success?
    self.lat = result.lat
    self.lng = result.lng
    self.save!
  end

  handle_asynchronously :geocode
end
