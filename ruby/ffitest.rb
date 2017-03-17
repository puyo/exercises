require 'rubygems' rescue nil
require 'ffi'

module UID
  extend FFI::Library
  attach_function :getuid, [], :uint
end
puts UID.getuid
