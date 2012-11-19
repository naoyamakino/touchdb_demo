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

  def createDocument(content)
    doc = @database.untitledDocument
    op = doc.putProperties(content)
    op.onCompletion(onCompletion(op, content))
    op.start
  end

  def onCompletion(op, content)
    if op.error
      raise "couldn't save the new item"
    else
      puts "#{content.inspect} has been saved."
    end
  end
end
