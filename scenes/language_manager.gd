extends Node

signal language_changed(new_lang)

var current_language = "en"  # Default to English
var supported_languages = ["en", "th"]

func change_language(lang_code):
	if lang_code in supported_languages:
		current_language = lang_code
		TranslationServer.set_locale(lang_code)
		emit_signal("language_changed", lang_code)

func toggle_language():
	var new_lang = "th" if current_language == "en" else "en"
	change_language(new_lang)

func get_current_language():
	return current_language
