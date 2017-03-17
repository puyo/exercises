
import java.util.Properties;
import java.util.Vector;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;


public class Race {
	
	// General race information.	
	private String name;
	private String description;
	private int buildPoints;
	private char priority;
	
	// Race statistics.
	private int bodyModifier;
	private int quicknessModifier;
	private int strengthModifier;
	private int charismaModifier;
	private int intelligenceModifier;
	private int willpowerModifier;
	private boolean thermographicVision;
	private boolean lowLightVision;
	private int reachModifier;
	private int dermalArmor;
	private int diseaseAndToxinResistance;
	
	// Other races.
	private Vector races;
	private String baseRace;

	Race(String name, Properties properties, Vector races) {
		this.name = name;
		this.races = races;
		load(name, properties);
	}
	
	/** Load race data from the properties. */
	private void load(String name, Properties properties) {
		this.name            = properties.getProperty(name + "_Name", name);
		buildPoints          = Integer.parseInt(properties.getProperty(name + "_BuildPoints", "-1"));
		priority             = properties.getProperty(name + "_Priority", "?").charAt(0);
		description          = properties.getProperty(name + "_Description", "No description available.");
		bodyModifier         = Integer.parseInt(properties.getProperty(name + "_BodyModifier", "0"));
		quicknessModifier    = Integer.parseInt(properties.getProperty(name + "_QuicknessModifier", "0"));
		strengthModifier     = Integer.parseInt(properties.getProperty(name + "_StrengthModifier", "0"));
		charismaModifier     = Integer.parseInt(properties.getProperty(name + "_CharismaModifier", "0"));
		intelligenceModifier = Integer.parseInt(properties.getProperty(name + "_IntelligenceModifier", "0"));
		willpowerModifier    = Integer.parseInt(properties.getProperty(name + "_WillpowerModifier", "0"));
		thermographicVision  = ("true" == properties.getProperty(name + "_ThermographicVision", "false"));
		lowLightVision       = ("true" == properties.getProperty(name + "_LowLightVision", "false"));
		reachModifier        = Integer.parseInt(properties.getProperty(name + "_ReachModifier", "0"));
		dermalArmor          = Integer.parseInt(properties.getProperty(name + "_DermalArmor", "0"));
		diseaseAndToxinResistance = Integer.parseInt(properties.getProperty(name + "_DiseaseAndToxinResistance", "0"));
		baseRace             = properties.getProperty(name + "_BaseRace", "None");
		
		if (baseRace != "None") {
			// Base race found.
			if (buildPoints == -1) {
				// No Build Points specified.
				// Build Points = base race's Build Points + 5.
				
				// Find the base race and calculate Build Points for this race.
				Race r;
				for (int i = 0; i != races.size(); i++) {
					r = (Race)races.elementAt(i);
					if (baseRace.compareTo(r.getName()) == 0) {
						buildPoints = r.getBuildPoints() + 5;
						break;
					}
				}
				if (buildPoints == -1) {
					Debug.fatalError("Could not find base race '" + baseRace + "' for race '" + name + "'.", 1);
				}
			}
		}
		
	}

	public String toString() {
		return getName() + " (" + getBuildPoints() + " Build Points)";
	}

	// General.
	public String getName() {
		return name;
	}
	
	public String getDescription() {
		return description;
	}
	
	// System cost.
	public int getBuildPoints() {
		return buildPoints;
	}
	
	public char getPriority() {
		return priority;
	}
	
	// Attribute Modifiers.
	public int getBodyModifier() {
		return bodyModifier;
	}
	public int getQuicknessModifier() {
		return quicknessModifier;
	}
	public int getStrengthModifier() {
		return strengthModifier;
	}
	public int getCharismaModifier() {
		return charismaModifier;
	}
	public int getIntelligenceModifier() {
		return intelligenceModifier;
	}
	public int getWillpowerModifier() {
		return willpowerModifier;
	}

	// Vision.
	public boolean getThermographicVision() {
		return thermographicVision;
	}
	public boolean getLowLightVision() {
		return lowLightVision;
	}

	// Other.
	public int getReachModifier() {
		return reachModifier;
	}
	public int getDermalArmor() {
		return dermalArmor;
	}
	public int getDiseaseAndToxinResistance() {
		return diseaseAndToxinResistance;
	}
}
