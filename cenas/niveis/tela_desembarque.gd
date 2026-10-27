extends Control

func _ready():
	# Lista com o(s) botão(ões) da tela de desembarque
	# (Verifica se o nome do nó na árvore corresponde a este)
	var botoes = [$BotaoMenuPrincipal]
	
	for botao in botoes:
		if botao != null and botao.texture_normal != null:
			# Cria a máscara de colisão perfeita baseada na transparência
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			# Define o centro do botão para que a ampliação aconteça a partir do meio
			botao.pivot_offset = botao.size / 2.0
			
			# Liga os sinais de passar o rato às funções de animação automaticamente
			botao.mouse_entered.connect(_ao_passar_o_rato.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_rato.bind(botao))

func _ao_passar_o_rato(botao_focado):
	# Aumenta o tamanho em 10%, aplica um ligeiro escurecimento e muda o cursor
	botao_focado.scale = Vector2(1.1, 1.1)
	botao_focado.modulate = Color(0.8, 0.8, 0.8)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_rato(botao_focado):
	# Devolve o botão ao tamanho e cor originais
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

# --- FUNÇÃO DE CLIQUE DO BOTÃO ---

func _on_botao_menu_principal_pressed():
	print("Fim da jornada! A regressar ao menu principal...")
	
	# Zera todo o progresso global, uma vez que o jogo foi concluído
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	
	# Redireciona para a cena do menu principal
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
