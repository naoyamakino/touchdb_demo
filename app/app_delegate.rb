class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @server = CouchTouchDBServer.sharedInstance
    raise "CouchTouchDBServer failed to start: #{@server.error}" if @server.error
    @database = @server.databaseNamed("my-database")
    @design = @database.designDocumentWithName("my-design")
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

  def getAllDocuments(option = {})
    query = @database.getAllDocuments
    query.limit = option[:limit] unless option[:limit].nil?
    query.descending = option[:descending] unless option[:descending].nil?
    query.rows.each do |row|
      puts "#{row.documentProperties.inspect}"
    end
  end

  def mapBlock
    return lambda { |doc, emit| emit(1, doc) }
  end

  def defineViewByFirstName
    @design.defineViewNamed("first_name", mapBlock:mapBlock, version:"1.0")
  end
  def query_by_first_name
    query = @design.queryViewNamed("first_name")
  end

end
