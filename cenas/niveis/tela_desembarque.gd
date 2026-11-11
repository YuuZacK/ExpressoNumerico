extends Control

@onready var valor_tempo = $ValorTempo
@onready var valor_somas = $ValorSomas
@onready var valor_erros = $ValorErros
@onready var valor_pontuacao = $ValorPontuacao

func _ready() -> void:
	# 1. Total de acertos
	if valor_somas:
		valor_somas.text = str(Global.acertos)
	
	# 2. Pontuação geral
	if valor_pontuacao:
		valor_pontuacao.text = str(Global.pontos)
	
	# 3. Calcula os erros focado APENAS nas contas matemáticas erradas/puladas
	if valor_erros:
		var contas_erradas = 24 - Global.acertos
		valor_erros.text = str(contas_erradas)
	
	# 4. Formata o tempo de jogo
	if valor_tempo:
		var tempo: float = float(Global.tempo_gasto)
		var minutos: int = int(tempo) / 60
		var segundos: float = fmod(tempo, 60.0)
		
		if minutos > 0:
			valor_tempo.text = "%02d:%04.1fs" % [minutos, segundos]
		else:
			valor_tempo.text = "%.1fs" % tempo

	# Configura apenas os botões existentes na tela de desembarque
	_configurar_botoes()

func _configurar_botoes() -> void:
	# Lista somente os botões cabíveis ao desembarque final
	var botoes = [
		get_node_or_null("BotaoReiniciarJogo"),
		get_node_or_null("BotaoJogarNovamente"),
		get_node_or_null("BotaoMenuPrincipal"),
		get_node_or_null("BotaoVoltar")
	]
	
	for botao in botoes:
		# Filtro estrito: só executa se o nó existir, for TextureButton e tiver textura
		if botao is TextureButton and botao.texture_normal != null:
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			botao.pivot_offset = botao.size / 2.0
			botao.mouse_entered.connect(_ao_passar_o_mouse.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_mouse.bind(botao))

# --- ANIMAÇÕES DE MOUSE ---

func _ao_passar_o_mouse(botao_focado: Control) -> void:
	botao_focado.scale = Vector2(1.1, 1.1)
	botao_focado.modulate = Color(0.8, 0.8, 0.8)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_mouse(botao_focado: Control) -> void:
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

# --- AÇÕES DOS BOTÕES E RESET ---

func _resetar_dados_globais() -> void:
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	Global.proxima_estacao = ""

func _on_botao_reiniciar_jogo_pressed() -> void:
	_resetar_dados_globais()
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")

func _on_botao_jogar_novamente_pressed() -> void:
	_on_botao_reiniciar_jogo_pressed()

func _on_botao_menu_principal_pressed() -> void:
	_resetar_dados_globais()
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_voltar_pressed() -> void:
	_on_botao_menu_principal_pressed()
