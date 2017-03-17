
 var DOT  = '.'.charCodeAt(0),
     BANG = '!'.charCodeAt(0)

process.stdin.on('data', function(buff) {
  buff.forEach(function(item, index) {
    if (item === 46) { item = 33 }
    buff[index] = item
    //buff.writeInt8(item, index)
  })
  console.log(buff)
  //process.stdout.write(buff)
})
