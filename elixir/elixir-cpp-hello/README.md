# Elixir / C++ socket comms

From https://www.wisol.ch/w/articles/2015-06-19-elixir-to-cpp-messaging/

## Dependencies

OSX:

    brew install msgpack nanomsg

## Compilation

    make
    cd enano
    mix deps.get

## Usage

    ./cnano
    
At another command prompt:

    cd enano
    iex -S mix

    iex> {:ok, data} = Msgpax.pack(["Greetings", 300, "Spartans"])
    iex> {:ok, s} = :enm.pair
    iex> :enm.connect(s, "ipc:///tmp/test.ipc")
    iex> :enm.send(s, [<<2>>|data])
    iex> :enm.send(s, <<42>>)
