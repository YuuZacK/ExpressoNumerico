extends Node2D

@onready var layout_tutorial: TextureRect = $LayoutTutorial
@onready var caixa_resposta: LineEdit = $CaixaDeResposta
@onready var botao_menu_principal: BaseButton = $BotaoMenuPrincipal

const RESPOSTA_CORRETA: String = "4"

func _ready() -> void:
	layout_tutorial.visible = true
	caixa_resposta.grab_focus()

func _on_caixa_de_resposta_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == RESPOSTA_CORRETA:
		get_tree().change_scene_to_file("res://cenas/niveis/tela_vitoria.tscn")
	else:
		caixa_resposta.clear()
		caixa_resposta.grab_focus()


func _on_botao_menu_principal_pressed() -> void:
	pass # Replace with function body.
