class OpenStructFactory < Cyclone::Factory
  
  uses(OpenStruct)

  #before_build :set_custom_attrs
  after_build :set_custom_attrs

  def set_custom_attrs(attrs={})
    p attrs
    attrs[:foo] = 123
    attrs[:bar] = 'rainbow'
    attrs
  end

  # def verify_custom_attrs(struct=OpenStruct.new)
  #   raise 'foo not set' unless struct.foo == 123
  #   raise 'bar not set' unless struct.bar == 'rainbow'
  #   struct.valid = true
  #   struct
  # end

  # def preconstruct(open_struct=OpenStruct.new)
  #   open_struct.foo = 0
  #   open_struct 
  # end

  # def postconstruct(open_struct=OpenStruct.new)
  #   open_struct.bar = 0
  #   open_struct
  # end




end
