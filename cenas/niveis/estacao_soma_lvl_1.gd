extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta

var resposta_correta = "4"
var acertos_atuais = 0
var total_contas = 6
var pontos_atuais = 0

func _on_caixa_de_resposta_text_changed(new_text: String):
	if not new_text.is_valid_int() and new_text != "":
		caixa_resposta.text = new_text.left(-1)
		caixa_resposta.caret_column = caixa_resposta.text.length()
	elif new_text == resposta_correta:
		print("Acertou!")
		pontos_atuais += 10
		hud.atualizar_pontos(pontos_atuais)
		acertos_atuais += 1
		hud.atualizar_acertos(acertos_atuais, total_contas)
	
