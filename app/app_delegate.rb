class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @server = CouchTouchDBServer.sharedInstance
    raise "CouchTouchDBServer failed to start: #{@server.error}" if @server.error
    @database = @server.databaseNamed("my-database")
    error = Pointer.new(:object)
    unless @database.ensureCreated(error)
      raise "database failed to be created"
    end

    true
  end

  #TODO how to make it run the operation asynchronously?
  def createDocument(content)
    doc = @database.untitledDocument
    op = doc.putProperties(content)
    if !op.wait
      raise "couldn't save the new item"
    else
      puts "#{content.inspect} has been saved."
    end
  end
end
