class_name Game
extends Node2D

@onready var player:Sprite2D = $"bar/player"
@onready var fish:Sprite2D = $"bar/fish"
@onready var progress_bar:ProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel
