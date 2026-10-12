extends Control

# Essa função roda automaticamente assim que a tela abre
func _ready():
	# 1. Colocamos os dois botões na nossa "caixa"
	# (Verifique se os nomes dos nós na sua árvore estão exatamente assim)
	var botoes = [$TextureRect/BotaoTenteNovamente, $TextureRect/BotaoMenuPrincipal]
	
	# 2. A linha de montagem que recorta a máscara de cada um
	for botao in botoes:
		if botao.texture_normal != null:
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara


func _on_botao_menu_principal_pressed():
	print("Voltando ao menu...")
	# Zera os pontos e acertos
	Global.pontos = 0
	Global.acertos = 0
	# Devolve as 3 vidas!
	Global.vidas = 3 
	
	# Volta para o menu principal (Ajuste o caminho se o seu menu estiver em outra pasta)
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")


func _on_botao_tente_novamente_pressed() -> void:
	print("Reiniciando o jogo...")
	# Zera os pontos e acertos
	Global.pontos = 0
	Global.acertos = 0
	# Devolve as 3 vidas para a nova partida!
	Global.vidas = 3 
	
	# Volta para a primeira conta (Ajuste o caminho se a sua fase estiver em outra pasta)
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1-conta2.tscn")
