extends Control
# Inkplay Studios — The Killer's Diary 2D Build 1
# A playable investigation vertical slice; dialogue text is provisional.
const SAVE_PATH = "user://killers_diary_build1.json"
const LOCATIONS = [
 ["Detective Apartment","location_detective_apartment.jpg"],
 ["Apartment Corridor","location_apartment_corridor.jpg"],
 ["South Greyhaven","location_south_greyhaven.jpg"],
 ["Town Library","location_town_library.jpg"],
 ["Raven Hotel","location_raven_hotel.jpg"],
 ["Room Seven","location_room_seven.jpg"],
 ["Police Archive","location_police_archive.jpg"],
 ["Wren Residence","location_wren_residence.jpg"],
 ["St. Marlow Church","location_st_marlow_church.jpg"],
 ["Greyhaven Diner","location_greyhaven_diner.jpg"],
 ["Hospital","location_greyhaven_hospital.jpg"],
 ["Darkroom","location_darkroom.jpg"],
 ["Lake and Park","location_lake_and_park.jpg"]
]
const EVIDENCE = {
 "Detective Apartment":[["Sealed Parcel","prop_sealed_parcel.png","A parcel with no return address."],["Diary","prop_diary_closed.png","The diary's pages may hold an answer."],["Telephone","prop_rotary_telephone.png","The line crackles, then falls silent."]],
 "Town Library":[["Unsent Letters","evidence_unsent_letters.png","These letters were never delivered."]],
 "Raven Hotel":[["Room Seven Ledger","evidence_room_seven_ledger.png","The ledger references Room Seven."]],
 "Police Archive":[["Wren Report","evidence_wren_report.png","An archived report bearing Dr. Wren's name."]],
 "Wren Residence":[["Silver Cufflink","evidence_silver_cufflink.png","A cufflink left behind."]],
 "Darkroom":[["Red Binding Thread","evidence_red_binding_thread.png","A length of red thread."]]
}
const PEOPLE = {
 "South Greyhaven":[["Nora Bell","portrait_nora_bell.jpg","Detective Bell: \"Follow the evidence. Don't assume you know the ending.\""]],
 "Town Library":[["Elias Crowe","portrait_elias_crowe.jpg","Elias Crowe: \"The Bellweather Archive holds records people overlook.\""]],
 "Apartment Corridor":[["Landlord","portrait_landlord.jpg","The landlord watches the corridor without volunteering much."]],
 "Lake and Park":[["Observer","portrait_observer.jpg","A hooded figure stands at a distance, then disappears."]],
 "Police Archive":[["Dr. Sel Wren (archive)","portrait_dr_sel_wren.jpg","An archival portrait of the late Dr. Sel Wren."]],
 "Room Seven":[["Mara Vale (record)","portrait_mara_vale.jpg","A photograph of the missing Mara Vale."]]
}
var current_location = 0
var inventory:Array = []
var visited:Array = []
var diary_open = false
var menu:PanelContainer
var bg:TextureRect
var title_label:Label
var message:RichTextLabel
var object_strip:HBoxContainer
var location_list:ItemList
var inventory_list:ItemList
var portrait:TextureRect
var overlay:PanelContainer
var overlay_text:RichTextLabel
var overlay_image:TextureRect
var status:Label
var paused_by_user = false
var fullscreen_button:Button
var pause_button:Button
var current_focus_index = 0

func _ready() -> void:
 _build_ui()
 _show_menu()
 get_viewport().size_changed.connect(_adapt_layout)
 _adapt_layout()

func _texture(file:String) -> Texture2D:
 var path = "res://assets/" + file
 if ResourceLoader.exists(path):
  return load(path)
 return null

func _button(label:String, callback:Callable, parent:Node) -> Button:
 var b = Button.new()
 b.text = label
 b.custom_minimum_size = Vector2(125,39)
 b.pressed.connect(callback)
 parent.add_child(b)
 b.add_to_group("kd_buttons")
 b.focus_mode = Control.FOCUS_ALL
 return b

func _build_ui() -> void:
 var backdrop = ColorRect.new()
 backdrop.color = Color("#090e16")
 backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(backdrop)
 var layout = VBoxContainer.new()
 layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 layout.add_theme_constant_override("separation",6)
 add_child(layout)
 var top = HBoxContainer.new()
 layout.add_child(top)
 title_label = Label.new()
 title_label.text = "THE KILLER'S DIARY  •  2D BUILD 1"
 title_label.add_theme_font_size_override("font_size",21)
 title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 top.add_child(title_label)
 _button("Save",_save,top)
 _button("Load",_load,top)
 _button("Menu",_show_menu,top)
 pause_button = _button("Pause",_toggle_pause,top)
 fullscreen_button = _button("Fullscreen",_toggle_fullscreen,top)
 var middle = HBoxContainer.new()
 middle.size_flags_vertical = Control.SIZE_EXPAND_FILL
 layout.add_child(middle)
 var left = VBoxContainer.new()
 left.custom_minimum_size = Vector2(215,0)
 middle.add_child(left)
 var travel = Label.new()
 travel.text = "LOCATIONS (select to travel)"
 left.add_child(travel)
 location_list = ItemList.new()
 location_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
 location_list.item_selected.connect(func(index:int): _go(index))
 left.add_child(location_list)
 for place in LOCATIONS:
  location_list.add_item(place[0])
 var center = VBoxContainer.new()
 center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 middle.add_child(center)
 bg = TextureRect.new()
 bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 bg.size_flags_vertical = Control.SIZE_EXPAND_FILL
 bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
 center.add_child(bg)
 object_strip = HBoxContainer.new()
 object_strip.alignment = BoxContainer.ALIGNMENT_CENTER
 center.add_child(object_strip)
 message = RichTextLabel.new()
 message.custom_minimum_size = Vector2(0,90)
 message.bbcode_enabled = true
 center.add_child(message)
 var right = VBoxContainer.new()
 right.custom_minimum_size = Vector2(220,0)
 middle.add_child(right)
 portrait = TextureRect.new()
 portrait.custom_minimum_size = Vector2(190,190)
 portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 right.add_child(portrait)
 var inv_label = Label.new()
 inv_label.text = "EVIDENCE INVENTORY"
 right.add_child(inv_label)
 inventory_list = ItemList.new()
 inventory_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
 inventory_list.item_selected.connect(_inspect_inventory)
 right.add_child(inventory_list)
 _button("Read Diary",_open_diary,right)
 _button("Unstuck",_unstuck,right)
 _button("Case Notes",_case_notes,right)
 status = Label.new()
 status.text = "Investigate objects • speak with people • collect clues"
 layout.add_child(status)
 overlay = PanelContainer.new()
 overlay.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
 overlay.custom_minimum_size = Vector2(570,410)
 overlay.visible = false
 add_child(overlay)
 var overlay_box = VBoxContainer.new()
 overlay.add_child(overlay_box)
 overlay_image = TextureRect.new()
 overlay_image.custom_minimum_size = Vector2(500,220)
 overlay_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 overlay_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 overlay_box.add_child(overlay_image)
 overlay_text = RichTextLabel.new()
 overlay_text.bbcode_enabled = true
 overlay_text.custom_minimum_size = Vector2(500,110)
 overlay_box.add_child(overlay_text)
 _button("Close",func(): overlay.hide(),overlay_box)
 menu = PanelContainer.new()
 menu.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
 menu.custom_minimum_size = Vector2(470,320)
 add_child(menu)
 var menu_box = VBoxContainer.new()
 menu_box.alignment = BoxContainer.ALIGNMENT_CENTER
 menu.add_child(menu_box)
 var heading = Label.new()
 heading.text = "THE KILLER'S DIARY\n2D INVESTIGATION — BUILD 1"
 heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 heading.add_theme_font_size_override("font_size",26)
 menu_box.add_child(heading)
 _button("New Game",_new_game,menu_box)
 _button("Continue",_load,menu_box)
 _button("Controls & About",_about,menu_box)
 _button("Quit",func(): get_tree().quit(),menu_box)
 var start_button:Button = menu_box.get_child(1) as Button
 start_button.grab_focus.call_deferred()

func _show_menu() -> void:
 overlay.hide()
 menu.show()
 if menu.get_child_count() > 0:
  var first = menu.get_child(0).get_child(1)
  if first is Control: first.grab_focus.call_deferred()

func _new_game() -> void:
 current_location = 0
 inventory.clear()
 visited.clear()
 _refresh_inventory()
 menu.hide()
 _go(0)
 _say("A rain-soaked city. A missing person. A diary waiting to be opened.\nInvestigate the apartment to begin.")

func _go(index:int) -> void:
 current_location = index
 if not visited.has(index):
  visited.append(index)
 menu.hide()
 overlay.hide()
 var place = LOCATIONS[index][0]
 title_label.text = "THE KILLER'S DIARY  /  " + place
 bg.texture = _texture(LOCATIONS[index][1])
 location_list.select(index)
 portrait.texture = null
 for child in object_strip.get_children():
  child.queue_free()
 for clue in EVIDENCE.get(place,[]):
  _button("🔎 " + clue[0],func(c=clue): _discover(c),object_strip)
 for person in PEOPLE.get(place,[]):
  _button("Talk: " + person[0],func(p=person): _talk(p),object_strip)
 _say("Location: " + place + ". Explore the highlighted clues and encounters.")
 if object_strip.get_child_count() > 0:
  object_strip.get_child(0).grab_focus.call_deferred()
 status.text = "Visited: %d/%d  |  Evidence: %d" % [visited.size(),LOCATIONS.size(),inventory.size()]

func _say(text:String) -> void:
 message.text = text

func _discover(clue:Array) -> void:
 if clue[0] == "Telephone":
  _show_detail(clue[1],"[b]Rotary telephone[/b]\n"+clue[2]+"\nThe silence is unsettling.")
  return
 if not inventory.has(clue[0]):
  inventory.append(clue[0])
  _refresh_inventory()
 _show_detail(clue[1],"[b]"+clue[0]+"[/b]\n"+clue[2]+"\n[Clue added to inventory]")
 status.text = "Evidence collected: %d" % inventory.size()

func _talk(person:Array) -> void:
 portrait.texture = _texture(person[1])
 _show_detail(person[1],"[b]"+person[0]+"[/b]\n"+person[2])
 _say(person[2])

func _refresh_inventory() -> void:
 inventory_list.clear()
 for item in inventory:
  inventory_list.add_item(item)

func _inspect_inventory(index:int) -> void:
 var name = inventory[index]
 for place in EVIDENCE:
  for clue in EVIDENCE[place]:
   if clue[0] == name:
    _show_detail(clue[1],"[b]"+name+"[/b]\n"+clue[2])
    return

func _show_detail(file:String,description:String) -> void:
 overlay_image.texture = _texture(file)
 overlay_text.text = description
 overlay.show()

func _open_diary() -> void:
 var note = "[b]DIARY — INVESTIGATION NOTES[/b]\n"
 if inventory.has("Diary"):
  note += "The open pages invite closer examination.\n"
 else:
  note += "Find the diary in the detective's apartment.\n"
 note += "Evidence collected: "+(", ".join(inventory) if not inventory.is_empty() else "None yet")
 _show_detail("prop_diary_open.png",note)

func _case_notes() -> void:
 _show_detail("prop_diary_closed.png","[b]CASE NOTES[/b]\nMissing: Mara Vale\nDr. Sel Wren: deceased\nNora Bell: detective\nElias Crowe: Bellweather Archive\n\nVisited: "+str(visited.size())+" locations.\nEvidence: "+str(inventory.size())+" items.\n\nNo conclusions have been established.")

func _save() -> void:
 var f = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
 if f == null:
  _say("Save failed.")
  return
 f.store_string(JSON.stringify({"location":current_location,"inventory":inventory,"visited":visited}))
 _say("Investigation saved.")

func _load() -> void:
 if not FileAccess.file_exists(SAVE_PATH):
  menu.hide()
  _new_game()
  _say("No previous save found. Starting a new investigation.")
  return
 var data = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
 if typeof(data) != TYPE_DICTIONARY:
  _say("Save file could not be read.")
  return
 inventory.assign(data.get("inventory",[]))
 visited.assign(data.get("visited",[]))
 _refresh_inventory()
 _go(clampi(int(data.get("location",0)),0,LOCATIONS.size()-1))
 _say("Investigation loaded.")

func _about() -> void:
 menu.hide()
 _show_detail("prop_diary_closed.png","[b]BUILD 2 — MULTIPLATFORM FOUNDATION[/b]\nUse the location list to travel. Click clues to collect them. Talk to characters and inspect evidence in the right panel. Save and load using the top buttons.\n\nOriginal artwork retained. Investigation dialogue is provisional, not established canon.")


# Keyboard shortcuts and gamepad actions are mapped in project.godot.
func _unhandled_input(event:InputEvent) -> void:
 if event.is_action_pressed("ui_cancel"):
  if overlay.visible:
   overlay.hide()
  elif menu.visible:
   menu.hide()
  else:
   _toggle_pause()
  get_viewport().set_input_as_handled()
 elif event.is_action_pressed("kd_diary"):
  _open_diary()
  get_viewport().set_input_as_handled()
 elif event.is_action_pressed("kd_save"):
  _save()
  get_viewport().set_input_as_handled()
 elif event.is_action_pressed("kd_fullscreen"):
  _toggle_fullscreen()
  get_viewport().set_input_as_handled()

func _toggle_fullscreen() -> void:
 if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
  DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
 else:
  DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _toggle_pause() -> void:
 paused_by_user = not paused_by_user
 if paused_by_user:
  _show_menu()
  pause_button.text = "Resume"
 else:
  menu.hide()
  pause_button.text = "Pause"

func _unstuck() -> void:
 # Point-and-click Build 2 has no walking avatar to reposition.
 # Safely closes overlays and returns focus to the current investigation scene.
 paused_by_user = false
 menu.hide()
 overlay.hide()
 _go(current_location)
 _say("Returned to current location. Your evidence remains intact.")

func _adapt_layout() -> void:
 var compact = get_viewport_rect().size.x < 850
 # Keep all controls touch-sized; Godot stretch scales the base UI.
 for b in get_tree().get_nodes_in_group("kd_buttons"):
  if b is Button:
   b.custom_minimum_size.y = 48 if compact else 40
 if status != null:
  status.text = "Touch/click to investigate • Esc: menu • F5: save • D: diary"
