defmodule PicoCD.Task do

    defstruct name: '', params: %{}
    
    @callback init(String.t, %{required(atom) => String.t}) :: {atom, any}
    @callback run(any, any) :: {atom, any}
end