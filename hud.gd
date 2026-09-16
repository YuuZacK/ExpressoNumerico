extends CanvasLayer

# 1. Criando o nosso Sinal customizado (o "alarme")
signal tempo_esgotado

# 2. Conectando o código aos nós da tela e do áudio
@onready var barra_tempo = $BarraDeTempo
@onready var texto_acertos = $TextoAcertos
@onready var texto_pontos = $TextoPontos
@onready var som_alarme = $SomAlarme 

# Variáveis para controlar o cronômetro
var tempo_maximo = 100.0
var tempo_atual = 100.0

func _ready():
	# Valores iniciais: zera os pontos e enche a barra
	atualizar_pontos(0)
	atualizar_acertos(0, 6)
	barra_tempo.max_value = tempo_maximo 
	atualizar_tempo(tempo_atual)

func _process(delta):
	# Só calculamos a queda de tempo se ele ainda for maior que zero
	if tempo_atual > 0:
		tempo_atual = tempo_atual - (delta * 10) 
		
		# No exato momento em que o tempo zerar (ou ficar negativo)...
		if tempo_atual <= 0:
			tempo_atual = 0 # Travamos no zero para a barra não quebrar
			
			# Disparamos o alarme para o jogo principal ouvir!
			tempo_esgotado.emit()
			
			# Imprime uma mensagem de teste no terminal do Godot
			print("Sinal emitido: O tempo acabou!") 
			
			# Toca o som de alarme!
			som_alarme.play()
			
		atualizar_tempo(tempo_atual)

# 3. Funções corrigidas (apenas os números, sem sobrepor a arte)
func atualizar_pontos(pontos: int):
	texto_pontos.text = str(pontos)

func atualizar_acertos(acertos: int, total: int):
	texto_acertos.text = str(acertos) + "/" + str(total)

func atualizar_tempo(tempo_novo: float):
	barra_tempo.value = tempo_novo
