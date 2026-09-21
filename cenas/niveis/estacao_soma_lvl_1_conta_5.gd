extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta

var resposta_correta = "18"
var total_contas = 6

func _ready():
	hud.atualizar_pontos(Global.pontos)
	hud.atualizar_acertos(Global.acertos, total_contas)

func _on_caixa_de_resposta_text_changed(new_text: String):
	if not new_text.is_valid_int() and new_text != "":
		caixa_resposta.text = new_text.left(-1)
		caixa_resposta.caret_column = caixa_resposta.text.length()
	elif new_text == resposta_correta:
		Global.pontos += 10
		Global.acertos += 1
		get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1-conta6.tscn")
