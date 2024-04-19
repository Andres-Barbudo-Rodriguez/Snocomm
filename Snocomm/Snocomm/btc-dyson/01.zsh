#!/bin/zsh

# Definir constantes
initial_reward=50 # Recompensa inicial por bloque (en bitcoins)
halving_interval=10080000 # Intervalo de bloques para halving

# Función para calcular la recompensa después de un número determinado de bloques
calculate_reward() {
    local blocks=$1 # Número de bloques
    local halvings # Número de halvings ocurridos
    local reward # Recompensa calculada

    # Calcular el número de halvings
    halvings=$((blocks / halving_interval))

    # Calcular la recompensa después de los halvings
    reward=$((initial_reward / (2 ** halvings)))

    echo "Recompensa después de $blocks bloques: $reward bitcoins"
}

calculate_reward 1
