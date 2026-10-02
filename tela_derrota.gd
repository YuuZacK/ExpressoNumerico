extends Control

func _on_botao_tentar_novamente_pressed():
	print("Reiniciando o jogo...")
	# Zera os pontos e acertos
	Global.pontos = 0
	Global.acertos = 0
	# Devolve as 3 vidas para a nova partida!
	Global.vidas = 3 
	
	# Volta para a primeira conta (Ajuste o caminho se a sua fase estiver em outra pasta)
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1-conta2.tscn")

func _on_botao_menu_principal_pressed():
	print("Voltando ao menu...")
	# Zera os pontos e acertos
	Global.pontos = 0
	Global.acertos = 0
	# Devolve as 3 vidas!
	Global.vidas = 3 
	
	# Volta para o menu principal (Ajuste o caminho se o seu menu estiver em outra pasta)
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
