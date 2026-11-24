extends Control

func _ready() -> void:
	var botoes = [$BotaoProximafase, $BotaoMenuPrincipal]
	
	for botao in botoes:
		if botao != null and botao.texture_normal != null:
			var imagem = botao.texture_normal.get_image()
			if imagem != null:
				var mascara = BitMap.new()
				mascara.create_from_image_alpha(imagem)
				botao.texture_click_mask = mascara
			
			botao.pivot_offset = botao.size / 2.0
			botao.mouse_entered.connect(_ao_passar_o_mouse.bind(botao))
			botao.mouse_exited.connect(_ao_tirar_o_mouse.bind(botao))

func _ao_passar_o_mouse(botao_focado) -> void:
	botao_focado.pivot_offset = botao_focado.size / 2.0
	botao_focado.scale = Vector2(1.1, 1.1)
	botao_focado.modulate = Color(0.85, 0.85, 0.85)
	botao_focado.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _ao_tirar_o_mouse(botao_focado) -> void:
	botao_focado.scale = Vector2(1.0, 1.0)
	botao_focado.modulate = Color(1.0, 1.0, 1.0)

func _on_botao_proximafase_pressed() -> void:
	if Global.proxima_estacao != "":
		get_tree().change_scene_to_file(Global.proxima_estacao)
	else:
		get_tree().change_scene_to_file("res://cenas/niveis/tela_desembarque.tscn")

func _on_botao_menu_principal_pressed() -> void:
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
