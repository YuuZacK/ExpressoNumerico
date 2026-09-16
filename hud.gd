extends CanvasLayer

# 1. Conectando o código aos nós da tela
@onready var barra_tempo = $BarraDeTempo
@onready var texto_acertos = $TextoAcertos
@onready var texto_pontos = $TextoPontos

# 2. Essa função roda automaticamente quando a cena começa
func _ready():
	# Valores de teste para ver se a tela atualiza sozinha!
	atualizar_pontos(50)
	atualizar_acertos(3, 6)
	atualizar_tempo(75.0)

# 3. Funções que o jogo vai chamar depois para atualizar a interface
func atualizar_pontos(pontos: int):
	texto_pontos.text = str(pontos)

func atualizar_acertos(acertos: int, total: int):
	texto_acertos.text = str(acertos) + "/" + str(total)

func atualizar_tempo(tempo_atual: float):
	barra_tempo.value = tempo_atual
