class Numeric
  # http://pullmonkey.com/2008/01/31/rounding-to-the-nearest-number-in-ruby/
  def roundup(nearest=10)
    self % nearest == 0 ? self : self + nearest - (self % nearest)
  end

  def rounddown(nearest=10)
    self % nearest == 0 ? self : self - (self % nearest)
  end
end
