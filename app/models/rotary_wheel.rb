class RotaryWheel < UIControl

  attr_accessor :delegate, :number_of_sections, :delta_angle, :container, :start_transform, :sectors, :current_sector

  def initWithFrame(frame, withDelegate: del, withSections: sections_number)

    if super
      self.number_of_sections = sections_number
      self.delegate           = self
      self.draw_wheel
    end

    self
  end

  def draw_wheel
    self.container = UIView.alloc.initWithFrame(self.frame)
    angle_size     = 2 * Math::PI / self.number_of_sections

    self.number_of_sections.times.each do |i|
      im                   = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 100, 40))
      im.backgroundColor   = UIColor.redColor
      im.text              = i.to_s
      im.layer.anchorPoint = CGPointMake(1.0, 0.5);
      im.layer.position    = CGPointMake(self.container.bounds.size.width/2.0, self.container.bounds.size.height/2.0)
      im.transform         = CGAffineTransformMakeRotation(angle_size * i)
      im.tag               = i
      self.container.addSubview(im)
    end

    self.container.userInteractionEnabled = false
    self.addSubview(self.container)

    self.sectors = []
    if number_of_sections % 2 == 0
      build_sectors_even
    else
      build_sectors_odd
    end
  end

  def build_sectors_odd
    fan_width = Math::PI * 2 / number_of_sections
    mid       = 0

    number_of_sections.times.each do |i|
      sector           = Sector.new
      sector.mid_value = mid
      sector.min_value = mid - (fan_width / 2)
      sector.max_value = mid + (fan_width / 2)
      sector.sector    = i
      mid              -= fan_width

      if (sector.min_value < - Math::PI)
        mid = -mid
        mid -= fan_width
      end

      self.sectors << sector
      NSLog("cl is #{sector.inspect}")
    end
  end

  def build_sectors_even
    fan_width = Math::PI * 2 / number_of_sections
    mid       = 0

    number_of_sections.times.each do |i|
      sector           = Sector.new
      sector.mid_value = mid
      sector.min_value = mid - (fan_width / 2)
      sector.max_value = mid + (fan_width / 2)
      sector.sector    = i

      if sector.max_value - fan_width < -Math::PI
        mid = Math::PI
        sector.mid_value = mid;
        sector.min_value = sector.max_value.abs
      end
      mid -= fan_width

      self.sectors << sector
      NSLog("cl is #{sector.inspect}")
    end
  end

  def beginTrackingWithTouch(touch, withEvent: event)
    touch_point = touch.locationInView(self)
    dist        = self.calculateDistanceFromCenter(touch_point)

    if (dist < 40 || dist > 100)
      return false
    end

    dx                   = touch_point.x - self.container.center.x
    dy                   = touch_point.y - self.container.center.y
    self.delta_angle     = Math.atan2(dy, dx)
    self.start_transform = self.container.transform
    true
  end

  def continueTrackingWithTouch(touch, withEvent: event)
    pt      = touch.locationInView(self)
    radians = Math.atan2(self.container.transform.b, self.container.transform.a)

    # if (dist < 40 || dist > 100)
      # here you might want to implement your solution when the drag
      # is too close to the center
      # You might go back to the clove previously selected
      # or you might calculate the clove corresponding to
      # the "exit point" of the drag.
    # end

    dx                       = pt.x - self.container.center.x
    dy                       = pt.y - self.container.center.y
    ang                      = Math.atan2(dy,dx)
    angle_difference         = self.delta_angle - ang
    self.container.transform = CGAffineTransformRotate(self.start_transform, -angle_difference)
    true
  end

  def endTrackingWithTouch(touch, withEvent: event)
    radians = Math.atan2(self.container.transform.b, self.container.transform.a)
    new_val = 0.0

    self.sectors.each do |s|
      if s.min_value > 0 && s.max_value < 0
        if s.max_value > radians || s.min_value < radians
          if radians > 0
            new_val = radians - Math::PI
          else
            new_val = Math::PI + radians
          end
          current_sector = s.sector
        end
      elsif radians > s.min_value && radians < s.max_value
        new_val        = radians - s.mid_value
        current_sector = s.sector
      end
    end

    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.2)
    t = CGAffineTransformRotate(self.container.transform, -new_val)
    self.container.transform = t
    UIView.commitAnimations
  end

  def calculateDistanceFromCenter(point)
    center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
    dx     = point.x - center.x
    dy     = point.y - center.y
    Math.sqrt(dx**2 + dy**2)
  end
end