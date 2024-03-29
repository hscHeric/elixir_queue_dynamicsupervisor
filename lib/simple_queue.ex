defmodule SimpleQueue do 
  use GenServer

  def init(state), do: {:ok, state}

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def handle_call(:dequeue, _from, [value | state]) do
    {:reply, value, state}
  end
  
  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}

  def handle_call(:queue, _from, state), do: {:reply, state, state}

  def handle_cast({:enqueue, value}, state) when is_list(value) do
    {:noreply, state ++ value}
  end

  def handle_cast({:enqueue, value}, state) do 
    {:noreply, state ++ [value]}
  end

  #Interface cliente / helpers
  def queue, do: GenServer.call(__MODULE__, :queue)
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
  def enqueue(value), do: GenServer.cast(__MODULE__, {:enqueue, value})

  def child_spec(opts) do
    %{
      id: SimpleQueue,
      start: {__MODULE__, :start_link, [opts]},
      shutdown: 5_000,
      restart: :permanent,
      type: :worker
    }
  end

end

