extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta

var resposta_correta = "4"
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
		
		# Calcula o tempo usado nesta conta e soma no valor global
		var tempo_usado = hud.tempo_maximo - hud.tempo_atual
		Global.tempo_gasto += int(tempo_usado)
		
		# Faz o código "esperar" 1 segundo para a criança ver o número
		await get_tree().create_timer(1.0).timeout
		
		get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1-conta2.tscn")
