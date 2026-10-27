extends Control

# Ligando os textos da tela ao código
@onready var valor_tempo = $ValorTempo
@onready var valor_somas = $ValorSomas
@onready var valor_erros = $ValorErros
@onready var valor_pontuacao = $ValorPontuacao

func _ready():
	# 1. Mostra os acertos totais
	valor_somas.text = str(Global.acertos)
	
	# 2. Mostra a pontuação total
	valor_pontuacao.text = str(Global.pontos)
	
	# 3. Calcula os erros baseados nas vidas
	var erros_cometidos = 3 - Global.vidas
	valor_erros.text = str(erros_cometidos)
	
	# 4. Mostra o tempo real gasto em segundos
	valor_tempo.text = str(Global.tempo_gasto) + "s"

	# --- CONFIGURAÇÃO DE HITBOX E ANIMAÇÃO DOS BOTÕES ---
	# Certifique-se de que os dois botões abaixo são do tipo TextureButton
	var botoes = [$BotaoJogarNovamente, $BotaoMenuPrincipal]
	
	for botao in botoes:
		if botao != null and botao.texture_normal != null:
			# Cria a hitbox perfeita baseada na transparência da imagem
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			# Define o ponto de articulação no centro (para ampliar a partir do meio)
			botao.pivot_offset = botao.size / 2.0
			
			# Liga os sinais de passar o mouse às funções de animação
			botao.mouse_entered.connect(_ao_passar_o_mouse.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_mouse.bind(botao))

# --- FUNÇÕES DE ANIMAÇÃO DE MOUSE ---

func _ao_passar_o_mouse(botao_focado):
	# Aumenta 10% e escurece levemente
	botao_focado.scale = Vector2(1.1, 1.1)
	botao_focado.modulate = Color(0.8, 0.8, 0.8)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_mouse(botao_focado):
	# Retorna ao tamanho e cor originais
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

# --- FUNÇÕES ORIGINAIS DE CLIQUE ---

func _on_botao_jogar_novamente_pressed():
	# Verifica se existe um trilho salvo para a próxima fase
	if Global.proxima_estacao != "":
		get_tree().change_scene_to_file(Global.proxima_estacao)
	else:
		# Se não houver próxima estação, volta ao menu e limpa o progresso
		Global.pontos = 0
		Global.acertos = 0
		Global.vidas = 3
		Global.tempo_gasto = 0
		get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_menu_principal_pressed():
	# Zera tudo ao abandonar a partida pelo menu
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
