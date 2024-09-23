defmodule Grafica do
  @moduledoc """
  Módulo que representa gráficas con un sistema de mensajes entre procesadores
  """

  def inicia(estado_inicial \\ %{:visitado => false, :raiz => false, :id => -1, :lider => nil}) do
    recibe_mensaje(estado_inicial)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    after
      5000 -> # Timeout para recibir mensajes
        IO.puts("Proceso #{estado.id} ha excedido el tiempo de espera. Terminando.")
        {:stop, estado}
    end
  end

  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    {:ok, estado}
  end

  def procesa_mensaje({:mensaje, n_id}, estado) do
    estado = conexion(estado, n_id)
    {:ok, estado}
  end

  def procesa_mensaje(:inicia, estado) do
    estado = Map.put(estado, :raiz, true)
    estado = conexion(estado)
    {:ok, estado}
  end

  def procesa_mensaje(:ya, estado) do
    %{:id => id, :visitado => visitado, :lider => lider} = estado
    if visitado do
      IO.puts("Soy el proceso #{id} y ya he sido visitado")
    else
      IO.puts("Soy el proceso #{id} y no he sido visitado, la gráfica no es conexa")
    end

    if lider do
      IO.puts("El líder actual es el proceso #{lider}")
    else
      IO.puts("No se ha determinado un líder aún.")
    end

    {:ok, estado}
  end

  def procesa_mensaje({:lider, id}, estado) do
    %{:id => mi_id, :lider => lider} = estado

    # Si el id recibido es menor que el líder actual o si no hay líder
    if lider == nil or id < lider do
      IO.puts("Proceso #{mi_id} ha actualizado su líder a #{id}")
      estado = Map.put(estado, :lider, id)

      # Notificar a los vecinos sobre el nuevo líder
      Enum.each(estado.vecinos, fn vecino ->
        send(vecino, {:lider, id})
      end)
    end

    {:ok, estado}
  end

  def procesa_mensaje(:terminar, estado) do
    IO.puts("Proceso #{estado.id} ha terminado.")
    {:stop, estado}
  end

  def conexion(estado, n_id \\ nil) do
    %{:id => id, :vecinos => vecinos, :visitado => visitado, :raiz => raiz} = estado
    cond do
      raiz and not visitado ->
        IO.puts("Proceso inicial (#{id})")
        Enum.each(vecinos, fn vecino ->
          send(vecino, {:mensaje, id})
        end)
        Map.put(estado, :visitado, true)

      n_id != nil and not visitado ->
        IO.puts("Soy el proceso #{id} y mi padre es #{n_id}")
        Enum.each(vecinos, fn vecino ->
          if Process.alive?(vecino) do
            send(vecino, {:mensaje, id})
          else
            IO.puts("Vecino #{vecino} no está disponible.")
          end
        end)
        Map.put(estado, :visitado, true)

      true ->
        estado
    end
  end
end

# Creación de procesos para cada nodo de la gráfica
v = spawn(Grafica, :inicia, [])
t = spawn(Grafica, :inicia, [])
x = spawn(Grafica, :inicia, [])
y = spawn(Grafica, :inicia, [])
w = spawn(Grafica, :inicia, [])
u = spawn(Grafica, :inicia, [])
z = spawn(Grafica, :inicia, [])
s = spawn(Grafica, :inicia, [])
r = spawn(Grafica, :inicia, [])
q = spawn(Grafica, :inicia, [])

# Asignación de IDs a cada proceso
send(v, {:id, 22})
send(t, {:id, 20})
send(x, {:id, 24})
send(y, {:id, 25})
send(w, {:id, 23})
send(u, {:id, 21})
send(z, {:id, 26})
send(s, {:id, 19})
send(r, {:id, 18})
send(q, {:id, 17})

# Definición de los vecinos de cada proceso
send(v, {:vecinos, [x]})
send(t, {:vecinos, [x]})
send(x, {:vecinos, [v, t, y, w]})
send(y, {:vecinos, [x, z, u]})
send(w, {:vecinos, [x]})
send(u, {:vecinos, [y]})
send(z, {:vecinos, [y]})
send(s, {:vecinos, [r, q]})
send(r, {:vecinos, [s]})
send(q, {:vecinos, [s]})

# Iniciar el proceso raíz
send(r, :inicia)  # También se puede iniciar en otros nodos, como x, y, etc.
