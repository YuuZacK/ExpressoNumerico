extends Control

func _ready():
	# Configurações iniciais ao abrir o menu
	pass

func _on_botao_jogar_pressed():
	print("Iniciando o jogo principal...")
	# get_tree().change_scene_to_file("res://cenas/niveis/seu_nivel_principal.tscn")

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
