extends Control

@onready var texto_pontuacao = $TextoPontuacao

func _ready():
	texto_pontuacao.text = str(Global.acertos) + "\n\n" + str(Global.pontos)

func _on_botao_voltar_pressed():
	print("O botao foi clicado com sucesso!")
	Global.pontos = 0
	Global.acertos = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")


func _on_botao_jogar_novamente_pressed() -> void:
	print("Botão Jogar Novamente clicado!")
	Global.pontos = 0
	Global.acertos = 0
	# Coloque aqui o caminho da fase do jogo ao invés do menu principal
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")


func _on_botao_jogar_novamente_mouse_entered() -> void:
	$BotaoJogarNovamente.modulate = Color(0.7, 0.7, 0.7)
	$BotaoJogarNovamente.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_botao_jogar_novamente_mouse_exited() -> void:
	$BotaoJogarNovamente.modulate = Color(1.0, 1.0, 1.0)
