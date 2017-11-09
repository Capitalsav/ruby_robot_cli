class FieldDrawer
  def self.draw(array)
    puts 'NORTH ->'
    array.each { |a| a.each { |x| print x }; puts }
  end
end
