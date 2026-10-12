extends Control

func _ready():
	# 1. Coloca aqui o nome exato dos teus nós de botão conforme estão na árvore de cena
	# Se os nomes forem com letra minúscula (ex: $botao_jogar), altera aqui na lista.
	var botoes = [$BotaoJogar, $BotaoTutorial, $BotaoOpcoes, $BotaoSobre, $BotaoSair]
	
	# 2. O laço 'for' vai passar por cada botão da lista
	for botao in botoes:
		# Verifica se o botão tem uma imagem (texture_normal) para evitar erros
		if botao.texture_normal != null:
			var mascara = BitMap.new()
			# Cria a máscara perfeita ignorando a parte transparente (alpha)
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara

func _on_botao_jogar_pressed():
	print("Iniciando o jogo principal...")
	# Caminho ajustado para a primeira conta selecionada
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")

func _on_botao_tutorial_pressed():
	print("Carregando o tutorial...")
	# Redirecionando para a cena que já existe no repositório
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl0.tscn")

func _on_botao_opcoes_pressed():
	print("Abrindo menu de opções...")

func _on_botao_sobre_pressed():
	print("Abrindo créditos...")

func _on_botao_sair_pressed():
	print("Fechando o jogo...")
	get_tree().quit()
