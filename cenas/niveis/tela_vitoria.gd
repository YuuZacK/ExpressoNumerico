extends Control

# Ligando os textos da tela ao código
@onready var valor_tempo = $ValorTempo
@onready var valor_somas = $ValorSomas
@onready var valor_erros = $ValorErros
@onready var valor_pontuacao = $ValorPontuacao

func _ready():
	# 1. Mostra os acertos totais
	valor_somas.text = str(Global.acertos)
	
	# 2. Mostra a pontuação total
	valor_pontuacao.text = str(Global.pontos)
	
	# 3. Calcula os erros baseados nas vidas
	var erros_cometidos = 3 - Global.vidas
	valor_erros.text = str(erros_cometidos)
	
	# 4. Mostra o tempo real gasto em segundos
	valor_tempo.text = str(Global.tempo_gasto) + "s"

func _on_botao_jogar_novamente_pressed():
	# Verifica se existe um trilho salvo para a próxima fase
	if Global.proxima_estacao != "":
		get_tree().change_scene_to_file(Global.proxima_estacao)
	else:
		# Se não houver próxima estação, volta ao menu e limpa o progresso
		Global.pontos = 0
		Global.acertos = 0
		Global.vidas = 3
		Global.tempo_gasto = 0
		get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_menu_principal_pressed():
	# Zera tudo ao abandonar a partida pelo menu
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	Global.tempo_gasto = 0
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
