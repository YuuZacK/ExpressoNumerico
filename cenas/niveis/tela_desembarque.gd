extends Control

func _ready():
	# Lista com os dois botões da tela de desembarque
	var botoes = [$BotaoMenuPrincipal, $BotaoJogarNovamente]
	
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
	# Aumenta o tamanho em 10%, aplica um ligeiro escurecimento e muda o cursor
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
	
	# Zera todo o progresso global, uma vez que o jogo foi concluído
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	
	# Redireciona para a cena do menu principal
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_jogar_novamente_pressed():
	print("A reiniciar a jornada desde o início...")
	
	# Zera o progresso para recomeçar o jogo do zero
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	
	# Redireciona para a primeira fase do jogo (ajuste o caminho se necessário)
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")
