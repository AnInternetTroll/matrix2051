defmodule Matrix2051.IrcConn.Supervisor do
  @moduledoc """
    Supervises the connection with a single IRC client: Matrix2051.IrcConn.State
    to store its state, and Matrix2051.IrcConn.Writer and Matrix2051.IrcConn.Reader
    to interact with it.
  """

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  @impl true
  def init(args) do
    {sock} = args
    children = [
      {Matrix2051.IrcConn.State, {self()}},
      {Matrix2051.IrcConn.Writer, {self(), sock}},
      {Matrix2051.IrcConn.Reader, {self(), sock}},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc "Returns the pid of the Matrix2051.IrcConn.State child."
  def state(sup) do
    {_, pid, _, _} = List.keyfind(Supervisor.which_children(sup), Matrix2051.IrcConn.State, 0)
    pid
  end

  @doc "Returns the pid of the Matrix2051.IrcConn.Reader child."
  def reader(sup) do
    {_, pid, _, _} = List.keyfind(Supervisor.which_children(sup), Matrix2051.IrcConn.Reader, 0)
    pid
  end

  @doc "Returns the pid of the Matrix2051.IrcConn.Writer child."
  def writer(sup) do
    {_, pid, _, _} = List.keyfind(Supervisor.which_children(sup), Matrix2051.IrcConn.Writer, 0)
    pid
  end
end
