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
	
	# 3. Calcula os erros: Se o jogador começou com 3 vidas, 
	# os erros são as vidas que ele perdeu (3 menos as vidas atuais)
	var erros_cometidos = 3 - Global.vidas
	valor_erros.text = str(erros_cometidos)
	
	# 4. Tempo Gasto (Vamos colocar um texto provisório por agora)
	valor_tempo.text = "??s"

# --- MANTENHA AS SUAS FUNÇÕES DOS BOTÕES ABAIXO DESTA LINHA ---
func _on_botao_jogar_novamente_pressed():
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	get_tree().change_scene_to_file("res://cenas/niveis/estacao_soma_lvl1.tscn")

func _on_botao_menu_principal_pressed():
	Global.pontos = 0
	Global.acertos = 0
	Global.vidas = 3
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")
