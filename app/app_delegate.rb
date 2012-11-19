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

  def defineViewByFirstName
    doc = @database.untitledDocument #I don't know how to get a proper document
    #according to https://github.com/couchbaselabs/TouchDB-iOS/wiki/Guide%3A-Views
    #mapBlock takes two argument, doc which is An NSDictionary -- this is the contents of the document being indexed.
    #and emit function. but right now I am passing untitledDocument, which has nothing to being indexed.
    #Do I have to iterate all documents (i.e from getAllDocuments) and call defineViewNamed:mapBlock:version for each document?
    @design.defineViewNamed("by_first_name", mapBlock:lambda do |doc, emit|
      emit('', doc)
    end, version:"1.0")
  end
  def query_by_first_name
    query = @design.queryViewNamed("by_first_name")
    query.rows.each do |row|
      puts "#{row.documentProperties.inspect}"
    end
  end
end
