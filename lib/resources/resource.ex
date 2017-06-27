defmodule PicoCD.Resource do
    @moduledoc """
    Defines the common behavior for all resources
    """

    defstruct name: '', params: %{}

    @callback init(String.t, %{required(atom) => String.t}) :: {atom, any}
    @callback read(any) :: {atom, any}
    @callback write(any, any) :: {atom, any}
    @callback close(any) :: {atom, any}
end

defprotocol PicoCD.UseResource do
    def init(name, params)
    def read(resource)
    def write(resource, object)
    def close(resource)
end