extends Control

@onready var texto_pontuacao = $TextoPontuacao

func _ready():
	texto_pontuacao.text = str(Global.acertos) + "\n\n" + str(Global.pontos)

func _on_botao_voltar_pressed():
	print("O botao foi clicado com sucesso!")
	Global.pontos = 0
	Global.acertos = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
