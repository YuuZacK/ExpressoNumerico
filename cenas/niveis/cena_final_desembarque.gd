extends Control

@onready var valor_tempo = $ValorTempo
@onready var valor_somas = $ValorSomas
@onready var valor_erros = $ValorErros
@onready var valor_pontuacao = $ValorPontuacao

func _ready() -> void:
	# Localiza os nós mesmo se estiverem dentro de containers/painéis na árvore
	_garantir_referencias_ui()
	
	# 1. Total de acertos
	if valor_somas:
		valor_somas.text = str(Global.acertos)
	
	# 2. Pontuação geral
	if valor_pontuacao:
		valor_pontuacao.text = str(Global.pontos)
	
	# 3. Calcula os erros com base nas vidas restantes
	if valor_erros:
		var erros_cometidos = max(0, 3 - Global.vidas)
		valor_erros.text = str(erros_cometidos)
	
	# 4. Tempo formatado
	if valor_tempo:
		var tempo: float = float(Global.tempo_gasto)
		var minutos: int = int(tempo) / 60
		var segundos: float = fmod(tempo, 60.0)
		
		if minutos > 0:
			valor_tempo.text = "%02d:%04.1fs" % [minutos, segundos]
		else:
			valor_tempo.text = "%.1fs" % tempo

func _garantir_referencias_ui() -> void:
	if valor_somas == null:
		valor_somas = find_child("ValorSomas", true, false)
	if valor_pontuacao == null:
		valor_pontuacao = find_child("ValorPontuacao", true, false)
	if valor_erros == null:
		valor_erros = find_child("ValorErros", true, false)
	if valor_tempo == null:
		valor_tempo = find_child("ValorTempo", true, false)

func _resetar_dados_globais() -> void:
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	Global.proxima_estacao = ""

# --- AÇÕES DOS BOTÕES ---

func _on_botao_reiniciar_jogo_pressed() -> void:
	_resetar_dados_globais()
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl0.tscn")

func _on_botao_jogar_novamente_pressed() -> void:
	_on_botao_reiniciar_jogo_pressed()

func _on_botao_menu_principal_pressed() -> void:
	_resetar_dados_globais()
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_voltar_pressed() -> void:
	_on_botao_menu_principal_pressed()
