extends CanvasLayer

# 1. Criando o nosso Sinal customizado (o "alarme")
signal tempo_esgotado

# 2. Conectando o código aos nós do ecrã e do áudio
@onready var barra_tempo = $BarraDeTempo
@onready var texto_acertos = $TextoAcertos
@onready var texto_pontos = $TextoPontos
@onready var som_alarme = $SomAlarme 

# NOVAS VARIÁVEIS PARA AS VIDAS (buscando dentro da CaixaDeVidas):
@onready var vida1 = $CaixaDeVidas/Vida1
@onready var vida2 = $CaixaDeVidas/Vida2
@onready var vida3 = $CaixaDeVidas/Vida3

# Variáveis para controlar o cronómetro
var tempo_maximo = 100.0
var tempo_atual = 100.0

func _ready():
	# Valores iniciais: coloca os pontos a zero e enche a barra
	atualizar_pontos(0)
	atualizar_acertos(0, 6)
	barra_tempo.max_value = tempo_maximo 
	atualizar_tempo(tempo_atual)
	
	# Chama a função para ajustar os desenhos das vidas no ecrã
	atualizar_vidas()

func _process(delta):
	# Só calculamos a queda de tempo se ele ainda for maior que zero
	if tempo_atual > 0:
		tempo_atual = tempo_atual - (delta * 10) 
		
		# No exato momento em que o tempo chegar a zero (ou ficar negativo)...
		if tempo_atual <= 0:
			tempo_atual = 0 # Travamos no zero para a barra não quebrar
			
			# Disparamos o alarme para o jogo principal ouvir!
			tempo_esgotado.emit()
			
			# Toca o som de alarme!
			som_alarme.play()
			
			# Congela o ecrã por 1.5 segundos para ouvir o som de derrota
			await get_tree().create_timer(1.5).timeout 
			
			# --- LÓGICA DE VIDAS ---
			Global.vidas -= 1  # Retira 1 vida
			
			if Global.vidas > 0:
				# Se ainda tem vidas, recarrega a conta atual para tentar de novo
				get_tree().reload_current_scene()
			else:
				# Se as vidas chegaram a zero, chama o ecrã de Game Over
				get_tree().change_scene_to_file("res://tela_derrota.tscn")
			
		atualizar_tempo(tempo_atual)

# 3. Funções 
func atualizar_pontos(pontos: int):
	texto_pontos.text = str(pontos)

func atualizar_acertos(acertos: int, total: int):
	texto_acertos.text = str(acertos) + "/" + str(total)

func atualizar_tempo(tempo_novo: float):
	barra_tempo.value = tempo_novo
	
func atualizar_vidas():
	# Esconde todas primeiro por segurança
	vida1.hide()
	vida2.hide()
	vida3.hide()
	
	# Mostra apenas a quantidade correspondente às vidas globais
	if Global.vidas >= 1:
		vida1.show()
	if Global.vidas >= 2:
		vida2.show()
	if Global.vidas == 3:
		vida3.show()
