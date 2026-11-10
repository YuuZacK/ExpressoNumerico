extends CanvasLayer

# Telas onde apertar P ou Esc NÃO deve pausar o jogo
const CENAS_SEM_PAUSA: Array[String] = [
	"TelaEmbarque",
	"TelaDesembarque",
	"TelaProximaFase",
	"TelaVitoria",
	"TelaDerrota"
]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		if _pode_pausar():
			toggle_pause()
			get_viewport().set_input_as_handled()

func _pode_pausar() -> bool:
	var cena_atual: Node = get_tree().current_scene
	if not cena_atual:
		return false
	return not (cena_atual.name in CENAS_SEM_PAUSA)

func toggle_pause() -> void:
	var should_pause: bool = not get_tree().paused
	get_tree().paused = should_pause
	visible = should_pause

# --- Sinais dos Botões ---

func _on_botao_voltarao_jogo_pressed() -> void:
	toggle_pause()

func _on_botao_reiniciar_pressed() -> void:
	toggle_pause()
	get_tree().reload_current_scene()

func _on_botao_opcoes_pressed() -> void:
	pass

func _on_botao_sair_pressed() -> void:
	toggle_pause()
	get_tree().change_scene_to_file("res://tela_embarque.tscn")
