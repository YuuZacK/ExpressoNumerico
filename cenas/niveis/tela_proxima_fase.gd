extends Control

# Referências aos nós de fundo
@onready var fundo: TextureRect = $Fundo
@onready var fundo_fase_multiplicacao: TextureRect = $FundoFaseMultiplicacao
@onready var fundo_fase_subtracao: TextureRect = $FundoFaseSubtracao

# Referências aos botões
@onready var botao_menu_principal: TextureButton = $BotaoMenuPrincipal
@onready var botao_proxima_fase: TextureButton = $BotaoProximaFase

# Caminho para o menu principal
@export_file("*.tscn") var cena_menu_principal: String = "res://cenas/menu_principal.tscn"

func _ready() -> void:
	definir_fundo_visivel()

func definir_fundo_visivel() -> void:
	# 1. Esconde todos os fundos
	fundo.visible = false
	fundo_fase_multiplicacao.visible = false
	fundo_fase_subtracao.visible = false
	
	var destino: String = Global.proxima_estacao.to_lower()
	print("--- TRANSIÇÃO DE FASE ---")
	print("Destino registrado em Global.proxima_estacao: '", destino, "'")
	
	# 2. Exibe o fundo correspondente à próxima estação
	if "subtra" in destino:
		fundo_fase_subtracao.visible = true
	elif "multi" in destino or "mult" in destino:
		fundo_fase_multiplicacao.visible = true
	elif "divis" in destino:
		fundo.visible = true
	else:
		push_warning("Destino não identificado ('" + destino + "'). Exibindo Multiplicação por padrão.")
		fundo_fase_multiplicacao.visible = true

func _on_botao_proxima_fase_pressed() -> void:
	print("Botão Próxima Fase clicado. Indo para: ", Global.proxima_estacao)
	if Global.proxima_estacao != "":
		get_tree().change_scene_to_file(Global.proxima_estacao)
	else:
		push_warning("Aviso: Global.proxima_estacao está vazio!")

func _on_botao_menu_principal_pressed() -> void:
	print("Botão Menu Principal clicado.")
	if cena_menu_principal != "":
		get_tree().change_scene_to_file(cena_menu_principal)
	else:
		push_warning("Aviso: cena_menu_principal não está definida!")
