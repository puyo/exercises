#include <cstring>
#include <nanomsg/nn.h>
#include <nanomsg/pair.h>
#include <msgpack.hpp>
#include <iostream>

int main()
{
  int s = nn_socket(AF_SP, NN_PAIR);
  nn_bind(s, "ipc:///tmp/test.ipc");
  void* buf = NULL;
  int count;
  while((count = nn_recv(s, &buf, NN_MSG, 0)) != -1) {
    uint8_t type = 0;
    std::memcpy(&type, buf, 1);
    std::cout << "type is: " << (int)type << "\n";

    if(type == 42) break;

    msgpack::object_handle oh = msgpack::unpack((const char*)buf+1, count-1);
    msgpack::object deserialized = oh.get();
    std::cout << deserialized << "\n";
    nn_freemsg(buf);
    std::cout << std::flush;
  }
  nn_close(s);
  return 0;
}
