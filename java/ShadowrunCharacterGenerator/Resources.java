
import java.util.Properties;

public class Resources {

	private int money;

	// System cost.
	private int buildPoints;
	private char priority;
	
	Resources(String name, Properties properties) {
		this.money = Integer.parseInt(name);
		load(name, properties);
	}

	/** Load resouce data from the properties. */
	private void load(String name, Properties properties) {
		buildPoints = Integer.parseInt(properties.getProperty(name + "_BuildPoints", "-1"));
		priority    = properties.getProperty(name + "_Priority", "?").charAt(0);
		if (buildPoints == -1) {
			Debug.fatalError("Build Points not specified for resource: " + name, 1);
		}
	}
	
	public int getMoney() {
		return money;
	}
	
	public int getBuildPoints() {
		return buildPoints;
	}
	
	public char getPriority() {
		return priority;
	}
	
	public String toString() {
		// Insert commas at intervals of 3.
		String result = new String();
		String number = money + "";
		int start = number.length() % 3;
//		for (int i = number.length() - 1; i >= 0; i--) {
//		}
		StringBuffer resultBuffer = new StringBuffer();
		
		resultBuffer.insert(0, number.charAt(number.length() - 1));
		for (int i = 1; i < number.length(); i++) {
			if ((i % 3) == 0) {
				resultBuffer.insert(0, ',');
			}
			resultBuffer.insert(0, number.charAt(number.length() - i - 1));
		}
		return resultBuffer.toString() + "¥" + " (" + getBuildPoints() + " Build Points)";
	}
}
