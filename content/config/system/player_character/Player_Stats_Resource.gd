@icon("res://content/ui/godot_icons/character_stats2.svg")
extends Resource
class_name Randomized_Player_Stats


@export var CHARACTER_NAME : String = ""
var Gender : Array = ["Male", "Female"]

var CODENAME : Array = [
	"Aak", "Ali", "Aaron", "Adam", "Adelon", "Arc", "Aura", "Alpha", "Aardvark", "Alpaca", "Beta", "Boris", "Bell", "Blue", "Bae", "Brick", "Bill", "Bob", "Beltway", "Big", "Blaze", "Burnz", "Baron", "Boozle", "Bytes", "Baboon", "Beagle",
	"Charlie", "Charcoal", "Casper", "Carol", "Corki", "Celine", "Chroma", "Cat", "Cecil", "Call", "Clown", "Delta", "Delaware", "Den", "Dirk", "Dork", "Doll", "Dunn", "Dome", "Dassue", "Deal", "Delie", "Dwarf", "Deer", "Donkey", "Duck",
	"Ellie", "Elk", "El", "Ent", "Echo", "Ego", "Ezie", "Foxtrot", "Fall", "Feel", "Fox", "Fern", "Fikk", "Franz", "Flash", "Fool", "Goose", "Guard", "Golf", "Gel", "Gekko", "Genin", "Grizz", "Grettle", "Hozir", "Helk", "Harmony","Hare",
	"Hans", "Hansel", "Herala", "Hawk", "Ink", "Illo", "Igor", "Ijak", "Indi", "Joe", "Judas", "Johnson", "Jordan", "John", "Jaye", "Jane", "Janitor", "Judas", "Juliet", "Kilo", "Korp", "Kardo", "Kito", "Khan", "Kidd", "Ligo", "Lea", "Lumi",    
	"Loko", "Luck", "Mouse", "Mark", "Marco", "Mike", "Morale", "Melt", "Noob", "Neon", "Nov", "Nin", "Oscar", "Ocelot", "Oddnumber", "Ork", "Oliver", "Park", "Pearl", "Possum", "Pierrot", "Pou", "Qu", "Qiya", "Quir", "Quill", "Quinn",
	"Qinling", "Quahog", "Red", "Rat", "Romeo", "Ron", "Royale", "Rombom", "Sierra", "Sello", "Silicon", "Silco", "Sinner", "Sandman", "Stun", "Stone", "Stark", "Star", "Salmon", "Sheep", "Tango", "Tae", "Tali", "Tarp", "Text", "Turner",
	"Tol", "Tempo", "Tapir", "Terra", "Tetra", "Tarc", "Umbra", "Umvi", "Uni","Undas", "Viktor", "Velo", "Veil", "Vivi", "Vervet", "Vicuna", "Volt", "Vaughn", "Whiskey", "Well", "Weasel", "Wu", "Williams", "Well", "Watts", "Wind", "Walrus",
	"Xema", "Xami", "XYZ", "Xylo", "Xero", "Xeon", "Xeno", "Yankee", "Yael", "Yela", "York", "Yunder", "Zulu", "Zebra", "Zen", "Zero", "Zoro", "Zebu", "Zuchon", "Zokor", "Zenaida", "Zonkey"
]

@export_category("Player Stats")
var RNG = RandomNumberGenerator.new()

enum Body_Type {
	SCOUT, #80 HP, 10 SPEED
	GUARD, #150 HP, 8 SPEED
	TANK #300 HP, 6 SPEED
}

@export var Player_Type : Body_Type

@export var MAX_HEALTH : int = RNG.randi_range(50, 200)
@export var MAX_STAMINA : int = RNG.randi_range(70, 150)

var SPEED : int = 8
@export var STRENGTH : int = RNG.randi_range(5, 8)
@export var DEXTERITY : int = RNG.randi_range(1, 3)
@export var LUCK : int = RNG.randi_range(5,30)
@export var ENDURANCE : int = RNG.randi_range(0, 30)
