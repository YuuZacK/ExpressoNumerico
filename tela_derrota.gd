extends Control

# Importa o script do tutorial diretamente pelo caminho do arquivo:
const EstacaoTutorial = preload("res://cenas/niveis/estacao_soma_lvl0.gd")

# Essa função roda automaticamente assim que a tela abre
func _ready():
	# 1. Colocamos os dois botões na nossa "caixa" (certifique-se de movê-los na árvore para fora do TextureRect)
	var botoes = [$BotaoTenteNovamente, $BotaoMenuPrincipal]
	
	# 2. A linha de montagem que recorta a máscara e aplica os efeitos de mouse
	for botao in botoes:
		if botao != null and botao.texture_normal != null:
			# Criação da máscara baseada na transparência
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			# Define o centro do botão para que a ampliação aconteça a partir do meio
			botao.pivot_offset = botao.size / 2.0
			
			# Liga os sinais de passar o rato e tirar o rato
			botao.mouse_entered.connect(_ao_passar_o_mouse.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_mouse.bind(botao))

func _ao_passar_o_mouse(botao_focado):
	# Recalcula o pivot, aumenta o tamanho em 15%, aplica escurecimento leve e muda o cursor
	botao_focado.pivot_offset = botao_focado.size / 2.0
	botao_focado.scale = Vector2(1.15, 1.15)
	botao_focado.modulate = Color(0.85, 0.85, 0.85)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_mouse(botao_focado):
	# Devolve o botão ao tamanho e cor originais
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

func _on_botao_menu_principal_pressed():
	print("Voltando ao menu...")
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_tente_novamente_pressed() -> void:
	print("Reiniciando o jogo...")
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	
	# Se a derrota veio do tutorial, retorna para a cena do tutorial
	if EstacaoTutorial.tutorial_ativo:
		get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl0.tscn")
	else:
		get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")
