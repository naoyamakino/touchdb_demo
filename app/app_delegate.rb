class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    server = CouchTouchDBServer.sharedInstance
    raise "CouchTouchDBServer failed to start: #{server.error}" if server.error
    database =server.databaseNamed("my-database")
    error = Pointer.new(:object)
    unless database.ensureCreated(error)
      raise "database failed to be created"
    end
    true
  end
end
