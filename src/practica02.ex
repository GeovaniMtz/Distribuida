defmodule Grafica do
  @moduledoc """
  Módulo para la representación de una gráfica mediante procesos.
  Cada proceso tiene un estado con su identificador, vecinos y si ha sido visitado.
  La gráfica se puede iniciar desde un nodo raíz y los mensajes se propagan a través de los vecinos.
  """

  @doc """
  Inicializa un proceso con un estado inicial.

  El estado tiene las claves:
  - `:id`: El identificador del proceso (por defecto `-1`).
  - `:visitado`: Un booleano que indica si el proceso ha sido visitado.
  - `:raiz`: Un booleano que indica si el proceso es la raíz.

  Luego, el proceso comienza a recibir mensajes.
  """
  def inicia(estado_inicial \\ %{:visitado => false, :raiz => false, :id => -1}) do
    recibe_mensaje(estado_inicial)
  end

  @doc """
  Recibe y procesa mensajes indefinidamente.

  Espera mensajes y los procesa de acuerdo a su tipo.
  Después de procesar un mensaje, vuelve a esperar más mensajes.
  """
  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    end
  end

  @doc """
  Procesa los mensajes recibidos según su tipo.

  Los mensajes pueden ser de los siguientes tipos:

  - `{:id, id}`: Asigna un identificador `id` al proceso.
  - `{:vecinos, vecinos}`: Asigna los procesos vecinos al proceso actual.
  - `{:mensaje, n_id}`: Mensaje de conexión, propagado desde el proceso padre (vecino).
  - `{:inicia}`: Inicia la propagación del mensaje desde el nodo raíz.
  - `{:ya}`: Verifica si el proceso ha sido visitado, lo que indica si la gráfica es conexa.
  """
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

  def procesa_mensaje({:inicia}, estado) do
    estado = Map.put(estado, :raiz, true)
    estado = conexion(estado)
    {:ok, estado}
  end

  def procesa_mensaje({:ya}, estado) do
    %{:id => id, :visitado => visitado} = estado
    if visitado do
      IO.puts("Soy el proceso #{id} y ya me visitaron")
    else
      IO.puts("Soy el proceso #{id} y no me visitaron, la gráfica no es conexa")
    end
    {:ok, estado}
  end

  @doc """
  Función encargada de manejar la propagación de mensajes entre los procesos vecinos.

  Si el proceso es la raíz y no ha sido visitado, envía el mensaje a todos sus vecinos.
  Si el proceso no ha sido visitado pero recibe un mensaje de su padre, también propaga el mensaje a sus vecinos.
  """
  def conexion(estado, n_id \\ nil) do
    %{:id => id, :vecinos => vecinos, :visitado => visitado, :raiz => raiz} = estado

    if raiz and not visitado do
      IO.puts("Soy el proceso inicial (#{id})")
      Enum.map(vecinos, fn vecino -> send(vecino, {:mensaje, id}) end)
      Map.put(estado, :visitado, true)
    else
      if n_id != nil and not visitado do
        IO.puts("Soy el proceso #{id} y mi padre es #{n_id}")
        Enum.map(vecinos, fn vecino -> send(vecino, {:mensaje, id}) end)
        Map.put(estado, :visitado, true)
      else
        estado
      end
    end
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

# Inicia la propagación desde el proceso raíz
send(v, {:inicia})

# Pausa para permitir que los mensajes se propaguen
:timer.sleep(1000)

# Comprobación de si la gráfica es conexa
IO.puts("----------------------------------------------")
IO.puts("Verificando conexidad de la grafica")
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
