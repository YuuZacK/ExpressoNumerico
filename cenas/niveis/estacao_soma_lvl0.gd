extends Node2D

@onready var hud: CanvasLayer = $HUD
@onready var layout_tutorial: TextureRect = $LayoutTutorial
@onready var botao_jogar: TextureButton = $"BotãoJogar"
@onready var caixa_resposta: LineEdit = $CaixaDeResposta

const RESPOSTA_CORRETA: String = "4"

func _ready() -> void:
	# 1. Garante a exibição do pop-up e do botão
	layout_tutorial.show()
	botao_jogar.show()
	caixa_resposta.release_focus()
	
	# 2. Congela o cronômetro da HUD antes de iniciar a partida
	hud.set_process(false)
	
	# 3. Configura a máscara de clique e a animação de hover
	configurar_animacao_botao()

func configurar_animacao_botao() -> void:
	if botao_jogar.texture_normal != null:
		# Cria a máscara (Hitbox) perfeita para ignorar áreas transparentes
		var mascara = BitMap.new()
		mascara.create_from_image_alpha(botao_jogar.texture_normal.get_image())
		botao_jogar.texture_click_mask = mascara
		
		# Define o centro para ampliar a partir do meio
		botao_jogar.pivot_offset = botao_jogar.texture_normal.get_size() / 2.0
		
		# Conecta os sinais de hover
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

# Função conectada ao clique do botão
func _on_botão_jogar_pressed() -> void:
	# 1. Some com a placa de instruções e com o botão de jogar
	layout_tutorial.hide()
	botao_jogar.hide()
	
	# 2. Inicia o cronômetro liberando o _process da HUD
	hud.set_process(true)
	
	# 3. Dá o foco na caixa de resposta com o cenário limpo
	caixa_resposta.grab_focus()

func _on_caixa_de_resposta_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == RESPOSTA_CORRETA:
		get_tree().change_scene_to_file("res://cenas/niveis/TelaProximaFase.tscn")
	else:
		caixa_resposta.clear()
		caixa_resposta.grab_focus()
