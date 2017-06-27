defmodule PicoCD.Resource.Filesystem do
    @moduledoc """

    Represents a filesystem resource. It is able to write files from and into
    a given folder.

    Currently this resource only supports references to directories, which
    means all operations are done on a directory-basis. All files of a folder
    are copied to another supplied folder.

    ## Examples

        iex> PicoCD.Resource.Filesystem.init('a name', %{:path => '/usr/bin'})
        {:ok, %Filesystem{:name => 'a name', :path => '/usr/bin'}}

        iex> PicoCD.Resource.Filesystem.init('a name', %{:path => 'unr34l'})
        {:error, nil}
    """

    alias PicoCD.Resource, as: Resource
    alias PicoCD.Resource.Filesystem, as: Filesystem
    
    @behaviour Resource

    # Currently the only needed fields are the path to the folder. 
    defstruct name: nil, path: ''

    def init(name, %{:path => path}) do
        exists? = File.exists?(path)

        case exists? do
            true -> {:ok, %Filesystem{:name => name, :path => path}}
            _ -> {:error, nil}
        end
    end

    def read(%Filesystem{:path => path}) do
        {:ok, path}
    end

    def write(%Filesystem{:path => path}, object) do
        {:ok, {path, object}}
    end

    def close(_) do
        {:ok, true}
    end
end

defimpl PicoCD.UseResource, for: PicoCD.Resource.Filesystem do
    
    alias PicoCD.Resource.Filesystem, as: Filesystem

    def read(%Filesystem{:path => path}) do
        {:ok, path}
    end

    def write(%Filesystem{:path => path}, object) do
        {:ok, {path, object}}
    end
end

