class_name EstacaoTutorial
extends Node2D

# Variáveis estáticas persistem entre recarregamentos e trocas de cena
static var tutorial_visto: bool = false
static var tutorial_ativo: bool = false

@onready var hud: CanvasLayer = $HUD
@onready var layout_tutorial: TextureRect = $LayoutTutorial
@onready var botao_jogar: TextureButton = $"BotãoJogar"
@onready var caixa_resposta: LineEdit = $CaixaDeResposta

const RESPOSTA_CORRETA: String = "4"

func _ready() -> void:
	# 1. Ativa a flag informando que a partida atual é o tutorial
	tutorial_ativo = true
	
	# Se o tutorial já foi visto nesta sessão, mantém escondido e o jogo rodando
	if tutorial_visto:
		layout_tutorial.hide()
		botao_jogar.hide()
		hud.set_process(true)
		caixa_resposta.grab_focus()
		return
	
	# Caso seja a primeira vez que a fase carrega
	layout_tutorial.show()
	botao_jogar.show()
	caixa_resposta.release_focus()
	hud.set_process(false)
	
	configurar_animacao_botao()

func configurar_animacao_botao() -> void:
	if botao_jogar.texture_normal != null:
		var mascara = BitMap.new()
		mascara.create_from_image_alpha(botao_jogar.texture_normal.get_image())
		botao_jogar.texture_click_mask = mascara
		
		botao_jogar.pivot_offset = botao_jogar.texture_normal.get_size() / 2.0
		
		botao_jogar.mouse_entered.connect(_ao_passar_o_mouse)
		botao_jogar.mouse_exited.connect(_ao_tirar_o_mouse)

# --- ANIMAÇÕES DE HOVER ---

func _ao_passar_o_mouse() -> void:
	botao_jogar.scale = Vector2(1.1, 1.1)
	botao_jogar.modulate = Color(0.85, 0.85, 0.85)
	botao_jogar.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_mouse() -> void:
	botao_jogar.scale = Vector2(1.0, 1.0)
	botao_jogar.modulate = Color(1.0, 1.0, 1.0)

# --- FLUXO DO JOGO ---

func _on_botão_jogar_pressed() -> void:
	tutorial_visto = true
	
	layout_tutorial.hide()
	botao_jogar.hide()
	hud.set_process(true)
	caixa_resposta.grab_focus()

func _on_caixa_de_resposta_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == RESPOSTA_CORRETA:
		# Desativa as flags ao acertar e avançar de fase
		tutorial_ativo = false
		tutorial_visto = false
		get_tree().change_scene_to_file("res://cenas/niveis/tela_embarque.tscn")
	else:
		caixa_resposta.clear()
		caixa_resposta.grab_focus()
