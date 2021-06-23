
def put_in!(hash, keys, value)
  if keys.size < 1
    raise ArgumentError, 'Need at least 1 key'
  end
  nested_hash = hash
  keys[0..-2].each do |key|
    nested_hash = (nested_hash[key] ||= {})
  end
  nested_hash[keys.last] = value
  hash
end

def put_in!(hash, keys, value)
  if keys.size < 1
    raise ArgumentError, 'Need at least 1 key'
  end
  result, nested_hash = keys[0..-2].reduce([hash, hash]) do |(hash, nested_hash), key|
    [hash, nested_hash[key] ||= {}]
  end
  nested_hash[keys.last] = value
  result
end

def put_in!(hash, keys, value)
  if keys.size == 1
    hash[keys.first] = value
  elsif keys.size > 1
    put_in!(hash[keys.first] ||= {}, keys[1..-1], value)
  end
  hash
end

# def put_in!(hash, keys, value)
#   if keys.size == 1
#     hash.merge!(keys.first => value)
#   elsif keys.size > 1
#     hash.merge!(keys.first => put_in!({}, keys[1, keys.size], value))
#   else
#     hash
#   end
# end

def put_in!(hash, keys, value)
  keys.reverse.reduce(value) do |this_hash, key|
    new_hash = {}
    new_hash[key] = this_hash
    new_hash
  end
end

begin
  p put_in!({}, [], 5)
rescue => e
  p e
end
# p put_in!({}, ['a'], 5)
# p put_in!({}, ['a', :b], 5)
p put_in!({'a' => {'x' => 3}}, ['a', 'b', 'c'], 5)

