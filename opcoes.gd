extends Control

@onready var botao_tutorial: TextureButton = $BotaoTutorial

func _ready() -> void:
	botao_tutorial.grab_focus()
	
	# Lista com os botões da cena que receberão os efeitos
	var botoes: Array[TextureButton] = [botao_tutorial]
	
	for botao in botoes:
		if botao.texture_normal != null:
			# 1. Cria a máscara (Hitbox) perfeita
			var mascara = BitMap.new()
			mascara.create_from_image_alpha(botao.texture_normal.get_image())
			botao.texture_click_mask = mascara
			
			# 2. Define o centro do botão para ampliar a partir do meio
			botao.pivot_offset = botao.size / 2.0
			
			# 3. Conecta os sinais de hover
			botao.mouse_entered.connect(_ao_passar_o_rato.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_rato.bind(botao))
			
			# 4. Conecta os sinais de clique
			botao.button_down.connect(_ao_pressionar_botao.bind(botao))
			botao.button_up.connect(_ao_soltar_botao.bind(botao))


# --- FUNÇÕES DE ANIMAÇÃO E INTERAÇÃO DOS BOTÕES ---

func _ao_passar_o_rato(botao_focado: TextureButton) -> void:
	botao_focado.scale = Vector2(1.1, 1.1)
	botao_focado.modulate = Color(0.8, 0.8, 0.8)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_rato(botao_focado: TextureButton) -> void:
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_ARROW

func _ao_pressionar_botao(botao_focado: TextureButton) -> void:
	botao_focado.scale = Vector2(0.95, 0.95)
	botao_focado.modulate = Color(0.65, 0.65, 0.65)

func _ao_soltar_botao(botao_focado: TextureButton) -> void:
	if botao_focado.is_hovered():
		botao_focado.scale = Vector2(1.1, 1.1)
		botao_focado.modulate = Color(0.8, 0.8, 0.8)
		botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		botao_focado.scale = Vector2(1.0, 1.0)
		botao_focado.modulate = Color(1.0, 1.0, 1.0)
		botao_focado.mouse_default_cursor_shape = Control.CURSOR_ARROW


# --- SINAIS DA CENA ---

func _on_botao_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl0.tscn")
