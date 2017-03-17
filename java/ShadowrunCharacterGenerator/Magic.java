
import java.util.Properties;

public class Magic {

	private String name;

	// System cost.
	private int buildPoints;
	private char priority;
	
	public Magic(String name, Properties properties) {
		load(name, properties);
	}

	/** Load resouce data from the properties. */
	private void load(String name, Properties properties) {
		this.name = properties.getProperty(name + "_Name", name);
		buildPoints = Integer.parseInt(properties.getProperty(name + "_BuildPoints", "-1"));
		priority    = properties.getProperty(name + "_Priority", "?").charAt(0);
		if (buildPoints == -1) {
			Debug.fatalError("Build Points not specified for magic option: " + name, 1);
		}
	}
	
	public int getBuildPoints() {
		return buildPoints;
	}
	
	public char getPriority() {
		return priority;
	}
	
	public String toString() {
		return getName() + " (" + getBuildPoints() + " Build Points)";
	}

	public String getName() {
		return name;
	}
}
