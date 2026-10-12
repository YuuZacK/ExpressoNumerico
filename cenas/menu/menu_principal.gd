extends Control

func _ready():
	var botoes = [$BotaoJogar, $BotaoTutorial, $BotaoOpcoes, $BotaoSobre, $BotaoSair]
	
	for botao in botoes:
		if botao.texture_normal != null:
			# 1. Cria a máscara (Hitbox) perfeita
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			# 2. Define o centro do botão para que ele amplie a partir do meio
			botao.pivot_offset = botao.size / 2.0
			
			# 3. Liga os sinais de passar o rato automaticamente
			# O ".bind(botao)" diz à função qual é o botão que está a sofrer a ação
			botao.mouse_entered.connect(_ao_passar_o_rato.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_rato.bind(botao))

# --- FUNÇÕES DE ANIMAÇÃO DOS BOTÕES ---

func _ao_passar_o_rato(botao_focado):
	# Aumenta o tamanho do botão em 10%
	botao_focado.scale = Vector2(1.1, 1.1)
	
	# Aplica o escurecimento e muda o cursor para a "mãozinha"
	botao_focado.modulate = Color(0.8, 0.8, 0.8)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_rato(botao_focado):
	# Devolve o botão ao tamanho original
	botao_focado.scale = Vector2(1.0, 1.0)
	
	# Devolve a cor original
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

# --- FUNÇÕES DE CLIQUE (MANTIDAS COMO ESTAVAM) ---

func _on_botao_jogar_pressed():
	print("Iniciando o jogo principal...")
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")

func _on_botao_tutorial_pressed():
	print("Carregando o tutorial...")
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl0.tscn")

func _on_botao_opcoes_pressed():
	print("Abrindo menu de opções...")

func _on_botao_sobre_pressed():
	print("Abrindo créditos...")

func _on_botao_sair_pressed():
	print("Fechando o jogo...")
	get_tree().quit()
