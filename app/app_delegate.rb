class AppDelegate
  attr_accessor :menu

  @@start_work_time = 0

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    @menu = NSMenu.new

    @menu_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @menu_item.setMenu(@menu)
    @menu_item.setHighlightMode(true)
    @menu_item.setTitle(@app_name)

    @menu.addItem createMenuItem("Start Work", 'startWork')
    @menu.addItem createMenuItem("Quit", 'terminate:')

    self.performSelectorInBackground('checkWork', withObject: nil)
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def startWork
    @@start_work_time = Time.now
  end

  def elapsedTime
    (Time.now - @@start_work_time).to_i
  end

  def working?
    elapsed_time = elapsedTime + 5
    (elapsed_time - ((elapsed_time / 30) * 30)) >= 5
  end

  def statusInWords
    working? ? "Working" : "Resting"
  end

  def checkWork
    while true
      if @@start_work_time > 0
        @menu_item.setTitle(statusInWords)
      end
    end
  end
end