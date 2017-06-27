defmodule PicoCD.Task do

    defstruct name: '', params: %{}
    
    @callback init(String.t, %{required(atom) => String.t}) :: {atom, any}
end

defprotocol PicoCD.UseTask do
    def run(task, name)
end