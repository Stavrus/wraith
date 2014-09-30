class CreateAntiviri
  include Wisper::Publisher

  def call(quantity, match)

    # Verify we were given non-null required parameters
    if quantity.nil?
      publish(:create_antiviri_failed, ['No given quantity for creating antiviri.'])
      return
    end

    if match.nil?
      publish(:create_antiviri_failed, ['Cannot create antiviri without an active match.'])
      return
    end

    # Verify we were given an integer param
    if !quantity.is_a? Integer
      publish(:create_antiviri_failed, ['Quantity parameter is not an integer.'])
      return
    end

    avs = []
    ActiveRecord::Base.transaction do
      quantity.times do
        avs << Antivirus.create({:match => match})
      end
    end

    publish(:create_antiviri_successful, avs)
  end

end