extends Control

@onready var texto_pontuacao = $TextoPontuacao

func _ready():
	texto_pontuacao.text = "Você acertou " + str(Global.acertos) + " de 6 contas!\nPontuação Final: " + str(Global.pontos)

func _on_botao_voltar_pressed():
	Global.pontos = 0
	Global.acertos = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
