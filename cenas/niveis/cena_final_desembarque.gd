extends Control

@onready var valor_tempo: Label = $ValorTempo
@onready var valor_somas: Label = $ValorSomas
@onready var valor_erros: Label = $ValorErros
@onready var valor_pontuacao: Label = $ValorPontuacao

func _ready() -> void:
	# 1. Exibe a soma de acertos de todas as estações
	valor_somas.text = str(Global.acertos_totais)
	
	# 2. Exibe a pontuação geral acumulada
	valor_pontuacao.text = str(Global.pontos_totais)
	
	# 3. Exibe o total acumulado de erros
	valor_erros.text = str(Global.erros_totais)
	
	# 4. Exibe o tempo total de jogo somado
	valor_tempo.text = "%.1fs" % Global.tempo_total

func _on_botao_reiniciar_jogo_pressed() -> void:
	# Reinicia o jogo completo a partir da primeira estação
	Global.resetar_jogo_completo()
	get_tree().change_scene_to_file("res://cenas/fases/estacao_adicao.tscn")

func _on_botao_menu_principal_pressed() -> void:
	# Limpa tudo e volta ao menu principal
	Global.resetar_jogo_completo()
	get_tree().change_scene_to_file("res://cenas/menu/menu_principal.tscn")

func _on_botao_voltar_pressed() -> void:
	pass # Replace with function body.


func _on_botao_jogar_novamente_pressed() -> void:
	pass # Replace with function body.
