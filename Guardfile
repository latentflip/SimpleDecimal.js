guard 'coffeescript', :output => 'spec/javascripts/generated/specs' do
  watch(/^spec\/javascripts\/coffee\/(.*)\.coffee/)
end

guard 'coffeescript', :output => 'lib/javascripts' do
  watch(/^src\/(.*)\.coffee/)
end

guard 'livereload', :apply_js_live => false do
  watch(/^spec\/javascripts\/.+\.js$/)
  watch(/^lib\/javascripts\/.+\.js$/)
end

