class Hash
  # Accepts a block which acts like Array.map but avoids creating a new Array
  # object. It should map the data to key/value pair arrays.
  def self.from_array(data)
    result = {}
    data.each do |*args|
      k, v = yield *args
      result[k] = v
    end
    result
  end
end

x = [[1,2], [3,4]]
p Hash.from_array(x) {|a,b| [a, b*2] }
Hash[ x.map{|a,b| [a, b*2] } ]
data.inject({}){|h,v| h.merge() }
