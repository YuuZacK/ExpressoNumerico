extends CanvasLayer

# 1. Conectando o código aos nós da tela
@onready var barra_tempo = $BarraDeTempo
@onready var texto_acertos = $TextoAcertos
@onready var texto_pontos = $TextoPontos

# Variáveis para controlar o cronômetro
var tempo_maximo = 100.0
var tempo_atual = 100.0

# 2. Essa função roda automaticamente quando a cena começa
func _ready():
	# Valores iniciais: zera os pontos e enche a barra
	atualizar_pontos(0)
	atualizar_acertos(0, 6)
	barra_tempo.max_value = tempo_maximo 
	atualizar_tempo(tempo_atual)

# 3. A função _process é o "coração" do jogo, rodando a cada frame
func _process(delta):
	# Se o tempo ainda não acabou...
	if tempo_atual > 0:
		# delta é o tempo real que passou. 
		# Multiplicamos por 10 só para a barra cair mais rápido no nosso teste!
		tempo_atual = tempo_atual - (delta * 10) 
		
		# Trava o tempo no zero para não ficar negativo
		if tempo_atual < 0:
			tempo_atual = 0
			
		atualizar_tempo(tempo_atual)

# 4. Funções corrigidas (apenas os números, sem sobrepor a arte!)
func atualizar_pontos(pontos: int):
	texto_pontos.text = str(pontos)

func atualizar_acertos(acertos: int, total: int):
	texto_acertos.text = str(acertos) + "/" + str(total)

func atualizar_tempo(tempo_novo: float):
	barra_tempo.value = tempo_novo
