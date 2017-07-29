defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  
  match "/classes/*path" do
    Proxy.forward conn, path, "http://resource/classes/"
  end
  
  match "/training-examples/*path" do
    Proxy.forward conn, path, "http://resource/training-examples/"
  end
  
  match "/files/*path" do
    Proxy.forward conn, path, "http://resource/files"
  end
  
  match "/upload/*path" do
    Proxy.forward conn, path, "http://uploader/files"
  end
  
  match "/classify/*path" do
    Proxy.forward conn, path, "http://classifier:5000/classify/"
  end
  
  match "/retrain/*path" do
    Proxy.forward conn, path, "http://classifier:5000/retrain"
  end
  
  match "/add-training-example/*path" do
    Proxy.forward conn, path, "http://classifier:5000/add-training-example/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
