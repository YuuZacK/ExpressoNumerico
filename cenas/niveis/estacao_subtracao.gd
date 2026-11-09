extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta
@onready var caixa_calculo = $CaixaCalculo
@onready var som_erro = $SomErro       # Referência ao som de erro
@onready var timer_erro = $TimerErro   # Referência ao cronômetro de tolerância

@export var max_niveis: int = 6
@export var niveis: Array[Dictionary] = []

var indice_atual: int = 0
var nivel_atual: Dictionary = {}
var aguardando_transicao: bool = false

func _ready() -> void:
	# Zera as variáveis da fase atual
	Global.pontos_fase_atual = 0
	Global.acertos_fase_atual = 0
	Global.tempo_fase_atual = 0
	
	# Configura o Timer de Erro (1 segundo de espera, toca só uma vez)
	if timer_erro:
		timer_erro.wait_time = 1.0
		timer_erro.one_shot = true
		if not timer_erro.timeout.is_connected(_on_timer_erro_timeout):
			timer_erro.timeout.connect(_on_timer_erro_timeout)

	if caixa_resposta and not caixa_resposta.text_changed.is_connected(_on_caixa_de_resposta_text_changed):
		caixa_resposta.text_changed.connect(_on_caixa_de_resposta_text_changed)
	
	carregar_perguntas()
	carregar_nivel_atual()

func carregar_perguntas() -> void:
	for i in max_niveis:
		var valor1: int = randi_range(1, 10)
		var valor2: int = randi_range(0, valor1) # Garante que o resultado não seja negativo
		
		var texto_calculo: String = "{v1} - {v2}".format({"v1": valor1, "v2": valor2})
		var conta_resultado: int = valor1 - valor2
		
		niveis.append({
			"nivel": i + 1,
			"calculo": texto_calculo,
			"resultado": conta_resultado
		})
	print(niveis)

func carregar_nivel_atual() -> void:
	if indice_atual < niveis.size():
		nivel_atual = niveis[indice_atual]
		caixa_resposta.text = ""
		
		# Limpa a cor do texto para voltar ao padrão
		caixa_resposta.remove_theme_color_override("font_color")
		
		caixa_resposta.editable = true
		caixa_resposta.grab_focus()
		aguardando_transicao = false

		caixa_calculo.text = str(nivel_atual["calculo"])

		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())
	else:
		finalizar_fase()

func _on_caixa_de_resposta_text_changed(new_text: String) -> void:
	if aguardando_transicao:
		return

	# Sempre que digitar ou apagar, cancela o alarme e volta a cor normal
	if timer_erro:
		timer_erro.stop()
	caixa_resposta.remove_theme_color_override("font_color")

	if not new_text.is_valid_int() and new_text != "":
		caixa_resposta.text = new_text.left(-1)
		caixa_resposta.caret_column = caixa_resposta.text.length()
		return

	if new_text != "" and new_text.to_int() == int(nivel_atual["resultado"]):
		aguardando_transicao = true
		caixa_resposta.editable = false
		
		# Deixa o texto verde ao acertar
		caixa_resposta.add_theme_color_override("font_color", Color(0, 1, 0))

		# Soma os pontos Globais e os da Fase
		Global.pontos += 10
		Global.acertos += 1
		Global.pontos_fase_atual += 10
		Global.acertos_fase_atual += 1

		var tempo_usado = hud.tempo_maximo - hud.tempo_atual
		Global.tempo_gasto += int(tempo_usado)
		Global.tempo_fase_atual += int(tempo_usado)

		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())

		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return
			
		hud.tempo_atual = hud.tempo_maximo

		indice_atual += 1
		carregar_nivel_atual()
		
	elif new_text != "":
		# Dispara o relógio de erro
		if timer_erro:
			timer_erro.start()

func _on_timer_erro_timeout() -> void:
	if som_erro:
		som_erro.play()
	# Muda a cor da fonte para vermelho
	caixa_resposta.add_theme_color_override("font_color", Color(1, 0, 0))

func finalizar_fase() -> void:
	caixa_resposta.editable = false
	caixa_resposta.text = ""
	caixa_calculo.text = "Parabéns!!!"
	print("Fase de subtração concluída com sucesso!")
	
	# Prepara a rota para a Multiplicação
	Global.proxima_estacao = "res://cenas/niveis/estacao-multiplicacao.tscn"

	get_tree().change_scene_to_file("res://cenas/niveis/TelaProximaFase.tscn")
