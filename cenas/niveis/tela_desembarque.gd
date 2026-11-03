extends Control

func _ready():
	# Lista com os botões que terão a hitbox e a animação configuradas
	var botoes = [$BotaoMenuPrincipal, $BotaoJogarNovamente, $BotaoSoma]
	
	for botao in botoes:
		if botao != null and botao.texture_normal != null:
			# Cria a máscara de colisão perfeita baseada na transparência
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			# Define o centro do botão para que a ampliação aconteça a partir do meio
			botao.pivot_offset = botao.size / 2.0
			
			# Liga os sinais de passar o rato às funções de animação automaticamente
			botao.mouse_entered.connect(_ao_passar_o_mouse.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_mouse.bind(botao))

func _ao_passar_o_mouse(botao_focado):
	# Recalcula o pivot e aumenta o tamanho em 10%, aplica um ligeiro escurecimento e muda o cursor
	botao_focado.pivot_offset = botao_focado.size / 2.0
	botao_focado.scale = Vector2(1.1, 1.1)
	botao_focado.modulate = Color(0.8, 0.8, 0.8)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_mouse(botao_focado):
	# Devolve o botão ao tamanho e cor originais
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

# --- FUNÇÕES DE CLIQUE DOS BOTÕES ---

func _on_botao_menu_principal_pressed():
	print("Fim da jornada! A regressar ao menu principal...")
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_jogar_novamente_pressed():
	print("A reiniciar a jornada desde o início...")
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")

func _on_botao_soma_pressed() -> void:
	print("Botão Soma pressionado!")
	# Adicione aqui a lógica do que deve acontecer quando o BotaoSoma for clicado
