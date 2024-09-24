defmodule Grafica do

  # Estado inicial simplificado
  def inicia(estado_inicial \\ %{:visitado => false, :raiz => false, :id => -1}) do
    recibe_mensaje(estado_inicial)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    end
  end

  # Procesa los mensajes con patrones flexibles
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

  # Lógica simplificada para manejar la conexión y la propagación de mensajes
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

# Crear procesos y asignarles IDs
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

# Asignar IDs a los procesos
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

# Asignar vecinos después de la creación
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

# Iniciar la propagación desde el proceso raíz
send(s, {:inicia})

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
