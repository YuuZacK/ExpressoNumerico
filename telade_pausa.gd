extends Control


func _ready() -> void:
	# Permite que este nó e seus filhos processem mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	# Escuta a tecla de pausa (usando 'ui_cancel' padrão ou uma ação 'pause' mapeada)
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func toggle_pause() -> void:
	var should_pause: bool = not get_tree().paused
	get_tree().paused = should_pause
	visible = should_pause


# Conecte o sinal 'pressed' do botão de Continuar/Voltar aqui
func _on_resume_button_pressed() -> void:
	toggle_pause()


# Conecte o sinal 'pressed' do botão de Reiniciar Fase aqui
func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


# Conecte o sinal 'pressed' do botão de Sair / Menu Principal aqui
func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	# Altere para a cena inicial/estação do jogo ou chame get_tree().quit()
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
