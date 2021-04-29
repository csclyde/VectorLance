class Const {
	// Various constants
	public static inline var FPS = 60;
	public static inline var FIXED_FPS = 30;
	public static inline var GRID = 16;
	public static inline var INFINITE = 999999;

	/** Unique value generator **/
	public static var NEXT_UNIQ(get,never) : Int; static inline function get_NEXT_UNIQ() return _uniq++;
	static var _uniq = 0;

	/** Viewport scaling **/
	public static var SCALE(get,never) : Int;
		static inline function get_SCALE() {
			// can be replaced with another way to determine the game scaling
			return 1; //dn.heaps.Scaler.bestFit_i(256,256);
		}

	/** Specific scaling for top UI elements **/
	public static var UI_SCALE(get,never) : Float;
		static inline function get_UI_SCALE() {
			// can be replaced with another way to determine the UI scaling
			return SCALE;
		}

	/** Game layers indexes **/
	static var _inc = 0;
	public static var BACKGROUND_OBJECTS = _inc++;
	public static var BACKGROUND_EFFECTS = _inc++;
	public static var MIDGROUND_OBJECTS = _inc++;
	public static var FOREGROUND_OBJECTS = _inc++;
	public static var FOREGROUND_EFFECTS = _inc++;
	public static var UI_LAYER = _inc++;
}
