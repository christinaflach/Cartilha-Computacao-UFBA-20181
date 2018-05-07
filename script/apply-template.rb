def root_for(path)
  File.dirname(path.gsub(/^public\//, '')).split('/').map { |dir| dir == '.' ? dir : '..' }.join('/')
end

template = ARGV[0]
source = ARGV[1]
root = root_for(source)

template = File.read(template)
# insert the content in the template
template.gsub!('@@content@@', File.read(source))
# resolve references to the root directory
template.gsub!('@@root@@', root)

puts template

