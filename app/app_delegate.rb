class AppDelegate
  attr_accessor :menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    @menu = NSMenu.new

    @menu_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @menu_item.setMenu(@menu)
    @menu_item.setHighlightMode(true)
    @menu_item.setTitle(@app_name)

    @menu.addItem createMenuItem("Quit", 'terminate:')
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end
end