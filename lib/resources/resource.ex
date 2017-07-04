defmodule PicoCD.Resource do
    @moduledoc """
    Defines the common behavior for all resources
    """

    defstruct name: '', params: %{}

    @callback init(String.t, %{required(atom) => String.t}) :: {atom, any}
end

defprotocol PicoCD.UseResource do
    def read(resource)
    def write(resource, object)
    def list(resource)
    def clear(resource)
    def close(resource)
end
