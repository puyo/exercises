
public class Debug {

    // Turn debugging on/off
    private static int debug = 1;
    private static int debugCounter = 0;
	
	public static void print(String message) {
		if (debug > 0) {
			System.out.println((debugCounter++) + ": " + message);
		}
	}

	public static void print(int importance, String message) {
		if (debug >= importance) {
			System.out.println((debugCounter++) + ": " + message);
		}
	}

	public static void error(String message) {
		System.err.println("Error: " + message);
	}

	public static void fatalError(String message, int exitCode) {
		System.err.println("Fatal error: " + message);
		System.exit(exitCode);
	}
}
