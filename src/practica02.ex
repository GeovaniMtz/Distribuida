defmodule Grafica do
  @moduledoc """
  Módulo para la representación de una gráfica de procesos y la elección de líder.

  Cada proceso tiene un estado que incluye:
    - `:id`: Identificador único del proceso.
    - `:lider_id`: Identificador del líder actual.
    - `:vecinos`: Lista de vecinos a los que puede enviar mensajes.
    - `:visitado`: Indica si el proceso ha sido visitado en la verificación de la conectividad.
  """

  @doc """
  Inicializa el proceso con el estado inicial.

  ## Parámetros
  - `estado_inicial`: Un mapa con los valores por defecto del estado del proceso.

  Por defecto, el estado incluye que el proceso no ha sido visitado, no tiene un líder
  asignado, y su lista de vecinos está vacía.
  """
  def inicia(estado_inicial \\ %{:visitado => false, :id => -1, :lider_id => nil, :vecinos => []}) do
    recibe_mensaje(estado_inicial)
  end

  @doc """
  Recibe y procesa los mensajes de forma indefinida.

  La función `receive` bloquea el proceso hasta que llega un mensaje.
  Dependiendo del tipo de mensaje, este se procesa y actualiza el estado del proceso.
  """
  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    end
  end

  @doc """
  Procesa los mensajes recibidos por el proceso.

  Dependiendo del contenido del mensaje, actualiza el estado del proceso.

  ## Tipos de mensajes:
    - `{:id, id}`: Asigna un identificador único al proceso.
    - `{:vecinos, vecinos}`: Asigna la lista de vecinos del proceso.
    - `{:inicia}`: Inicia el proceso de elección de líder.
    - `{:eleccion, lider_id}`: Propaga el nuevo líder en la gráfica.
    - `{:ya}`: Verifica si el proceso ha sido visitado y muestra el estado actual.
  """
  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    {:ok, estado}
  end

  def procesa_mensaje({:inicia}, estado) do
    %{:id => id} = estado
    IO.puts("Soy el proceso #{id} y comienzo la elección.")
    iniciar_eleccion(id, estado)  # Inicia la elección con el propio ID como líder
    {:ok, estado}
  end

  def procesa_mensaje({:eleccion, nuevo_lider_id}, estado) do
    %{:id => id, :lider_id => lider_id_viejo, :vecinos => vecinos} = estado

    cond do
      # Si no tiene líder o el nuevo líder es menor, lo actualiza
      lider_id_viejo == nil or nuevo_lider_id < lider_id_viejo ->
        IO.puts("Soy el proceso #{id} y acepto a #{nuevo_lider_id} como nuevo líder.")
        estado = Map.put(estado, :lider_id, nuevo_lider_id)

        # Propaga el nuevo líder a los vecinos
        Enum.each(vecinos, fn vecino ->
          send(vecino, {:eleccion, nuevo_lider_id})
        end)
        {:ok, estado}

      true ->
        # Si ya tiene un líder igual o menor, no hace nada
        {:ok, estado}
    end
  end

  def procesa_mensaje({:ya}, estado) do
    %{:id => id, :visitado => visitado, :lider_id => lider_id} = estado

    # Verifica si el proceso ha sido visitado en la verificación de la conectividad
    if visitado do
      IO.puts("Proceso #{id}: ya he sido visitado.")
    else
      IO.puts("Proceso #{id}: no he sido visitado. La gráfica no es conexa.")
    end

    # Muestra el líder actual del proceso
    if lider_id do
      IO.puts("Proceso #{id}: el líder actual es #{lider_id}.")
    else
      IO.puts("Proceso #{id}: aún no se ha determinado un líder.")
    end

    {:ok, estado}
  end

  @doc """
  Inicia el proceso de elección enviando un mensaje con su propio ID a los vecinos.

  ## Parámetros
    - `lider_id`: El ID del proceso que inicia la elección.
    - `estado`: El estado actual del proceso.

  Propaga el ID a sus vecinos, quienes continuarán propagando el mensaje.
  """
  def iniciar_eleccion(lider_id, estado) do
    %{:vecinos => vecinos} = estado
    Enum.each(vecinos, fn vecino ->
      send(vecino, {:eleccion, lider_id})
    end)
    {:ok, estado}
  end
end

# Creación de los procesos
q = spawn(Grafica, :inicia, [])
r = spawn(Grafica, :inicia, [])
s = spawn(Grafica, :inicia, [])
t = spawn(Grafica, :inicia, [])
u = spawn(Grafica, :inicia, [])
v = spawn(Grafica, :inicia, [])
w = spawn(Grafica, :inicia, [])
x = spawn(Grafica, :inicia, [])
y = spawn(Grafica, :inicia, [])
z = spawn(Grafica, :inicia, [])

# Asignación de IDs a los procesos
send(q, {:id, 17})
send(r, {:id, 18})
send(s, {:id, 19})
send(t, {:id, 20})
send(u, {:id, 21})
send(v, {:id, 22})
send(w, {:id, 23})
send(x, {:id, 24})
send(y, {:id, 25})
send(z, {:id, 26})

# Asignación de vecinos entre los procesos
send(q, {:vecinos, [s]})
send(r, {:vecinos, [s]})
send(s, {:vecinos, [q, r]})
send(t, {:vecinos, [w, x]})
send(u, {:vecinos, [y, z]})
send(v, {:vecinos, [x]})
send(w, {:vecinos, [t, x]})
send(x, {:vecinos, [t, v, w, y]})
send(y, {:vecinos, [u, x, z]})
send(z, {:vecinos, [y]})

# Inicia la elección desde el proceso 'q'
send(q, {:inicia})

# Pausa para permitir que los mensajes se propaguen
:timer.sleep(1000)

# Verificación de la conectividad de la gráfica y estado de los líderes
IO.puts("----------------------------------------------")
IO.puts("Verificando conexidad de la gráfica y elección de líder")
IO.puts("----------------------------------------------")
:timer.sleep(1000)

# Verificación de los procesos
send(q, {:ya})
:timer.sleep(1000)
send(r, {:ya})
:timer.sleep(1000)
send(s, {:ya})
:timer.sleep(1000)
send(t, {:ya})
:timer.sleep(1000)
send(u, {:ya})
:timer.sleep(1000)
send(v, {:ya})
:timer.sleep(1000)
send(w, {:ya})
:timer.sleep(1000)
send(x, {:ya})
:timer.sleep(1000)
send(y, {:ya})
:timer.sleep(1000)
send(z, {:ya})
