class RotaryWheelController < UIViewController

  def viewDidLoad
    @wheel = RotaryWheel.alloc.initWithFrame(CGRectMake(0, 0, 200, 200), withDelegate: self, withSections: 4)
    view.addSubview(@wheel)
  end

end