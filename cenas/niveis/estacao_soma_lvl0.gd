class_name EstacaoTutorial
extends Node2D

# Variáveis estáticas persistem entre recarregamentos e trocas de cena
static var tutorial_visto: bool = false
static var tutorial_ativo: bool = false

@onready var hud: CanvasLayer = $HUD
@onready var layout_tutorial: TextureRect = $LayoutTutorial
@onready var botao_jogar: TextureButton = $"BotãoJogar"
@onready var caixa_resposta: LineEdit = $CaixaDeResposta
@onready var som_erro = $SomErro       # Referência ao som de erro
@onready var timer_erro = $TimerErro   # Referência ao cronômetro de tolerância

const RESPOSTA_CORRETA: String = "4"

var aguardando_transicao: bool = false

func _ready() -> void:
	# 1. Ativa a flag informando que a partida atual é o tutorial
	tutorial_ativo = true
	
	# 2. Configura o Timer de Erro (1 segundo de tolerância, disparo único)
	if timer_erro:
		timer_erro.wait_time = 1.0
		timer_erro.one_shot = true
		if not timer_erro.timeout.is_connected(_on_timer_erro_timeout):
			timer_erro.timeout.connect(_on_timer_erro_timeout)

	# 3. Conecta a validação em tempo real da resposta (mesmo padrão da Estação Soma)
	if caixa_resposta and not caixa_resposta.text_changed.is_connected(_on_caixa_de_resposta_text_changed):
		caixa_resposta.text_changed.connect(_on_caixa_de_resposta_text_changed)
	
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

func _on_caixa_de_resposta_text_changed(new_text: String) -> void:
	if aguardando_transicao:
		return

	# Cancela o alarme e reseta a cor sempre que a criança altera o texto
	if timer_erro:
		timer_erro.stop()
	caixa_resposta.remove_theme_color_override("font_color")

	# Impede caracteres não numéricos
	if not new_text.is_valid_int() and new_text != "":
		caixa_resposta.text = new_text.left(-1)
		caixa_resposta.caret_column = caixa_resposta.text.length()
		return

	# Verificação da resposta
	if new_text != "" and new_text.strip_edges() == RESPOSTA_CORRETA:
		aguardando_transicao = true
		caixa_resposta.editable = false
		caixa_resposta.add_theme_color_override("font_color", Color(0, 1, 0)) # Verde no acerto

		tutorial_ativo = false
		tutorial_visto = false

		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return

		get_tree().change_scene_to_file("res://cenas/niveis/tela_embarque.tscn")
	elif new_text != "":
		# Inicia a contagem de 1 segundo se digitou um valor incorreto
		if timer_erro:
			timer_erro.start()

func _on_timer_erro_timeout() -> void:
	if som_erro:
		som_erro.play()
	# Destaca o texto em vermelho informando o erro
	caixa_resposta.add_theme_color_override("font_color", Color(1, 0, 0))

# Mantido caso o jogador confirme pressionando Enter no teclado
func _on_caixa_de_resposta_text_submitted(new_text: String) -> void:
	if aguardando_transicao:
		return

	if new_text.strip_edges() == RESPOSTA_CORRETA:
		aguardando_transicao = true
		caixa_resposta.editable = false
		caixa_resposta.add_theme_color_override("font_color", Color(0, 1, 0))
		tutorial_ativo = false
		tutorial_visto = false
		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return
		get_tree().change_scene_to_file("res://cenas/niveis/tela_embarque.tscn")
	else:
		if timer_erro:
			timer_erro.stop()
		_on_timer_erro_timeout()
