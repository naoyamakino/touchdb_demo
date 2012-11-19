# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'touchdb_demo'
  app.vendor_project('vendors/TouchDB.framework', :static,
                     :products => ['TouchDB'],
                     :headers_dir => 'Headers')
  app.vendor_project('vendors/CouchCocoa.framework', :static,
                     :products => ['CouchCocoa'],
                     :headers_dir => 'Headers')
  app.libs += %w(/usr/lib/libz.dylib /usr/lib/libsqlite3.dylib)
  app.frameworks += %w(CFNetwork SystemConfiguration MobileCoreServices Security)
end
