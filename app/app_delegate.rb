class AppDelegate
  attr_accessor :menu

  @@start_work_time = 0
  @@work_time = 25
  @@resting_time = 5
  @@period_time = @@work_time + @@resting_time

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    @menu = NSMenu.new

    @menu_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @menu_item.setMenu(@menu)
    @menu_item.setHighlightMode(true)
    @menu_item.setImage(NSImage.imageNamed("icon"))

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
    elapsed_time = elapsedTime + @@resting_time
    (elapsed_time - ((elapsed_time / @@period_time) * @@period_time)) >= @@resting_time
  end

  def statusText(working)
    working ? "Working" : "Resting"
  end

  def notificationText(working)
    working ? "Get back to work" : "Time to rest"
  end

  def showNotification
    notification = NSUserNotification.alloc.init
    notification.title = "Pomidoro"
    notification.informativeText = notificationText(working?)
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.defaultUserNotificationCenter.scheduleNotification(notification)
  end

  def checkWork
    last_status_check ||= false
    while true
      if @@start_work_time > 0
        @menu_item.setTitle statusText(working?)
        showNotification if last_status_check != working?
        last_status_check = working?
      end
      sleep 1
    end
  end
end