
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;
import java.util.Vector;
import java.util.StringTokenizer;
import java.util.Properties;
import java.io.FileInputStream;

public class Generator extends JPanel {

	public static final String EXTENSION = ".txt";
	public static final String DEFAULT_RACE_DEFINITONS = "data/races";
	public static final String DEFAULT_MAGIC_DEFINITONS = "data/magic";
	public static final String DEFAULT_RESOURCES_DEFINITONS = "data/resources";

	// Source books used.
	Vector sourceBooks = new Vector();
	Vector races = new Vector();
	Vector magicOptions = new Vector();
	Vector resources = new Vector();
	
	// Character being worked on.	
	private ShadowrunCharacter character;

	// Preferred dimensions.
	private int PREFERRED_WIDTH = 480;
	private int PREFERRED_HEIGHT = 520;
	
	// Systems.
	public static final int BUILD_POINT_SYSTEM = 1;
	public static final int PRIORITY_SYSTEM = 2;

	private JTabbedPane tabbedPane = null;

	public Generator(int system, int buildPoints) {

		// Load races.
		
		loadRaces("data/races" + EXTENSION);
		loadMagics("data/magic" + EXTENSION);
		loadResources("data/resources" + EXTENSION);
		
		character = new ShadowrunCharacter();
		character.setSystem(system);
		character.setBuildPoints(buildPoints);
		character.setRace((Race)races.get(0));
		character.setMagic((Magic)magicOptions.get(0));
		character.setResources((Resources)resources.get(1));

		buildGUI();
	}
	
	
	private Properties loadPropertiesFile(String fullDataPath, String defaultFile) {
		Properties properties = new Properties();
		FileInputStream file = null;

		// Open the file.
		try {
			file = new FileInputStream(fullDataPath);
		}
		catch (Exception e) {
			try {
				file = new FileInputStream(defaultFile);
				Debug.error("Could not open file specified: " + e.getMessage() + ". Using default file.");
			}
			catch (Exception fnfe) {
				Debug.fatalError("Could not open default file: " + fnfe.getMessage(), 1);
			}
		}
		// Load the properties from it.
		try {
			properties.load(file);
			file.close();
		}
		catch (Exception e) {
			Debug.fatalError("Could not load properties from file: " + e.getMessage(), 1);
		}
		return properties;
	}
	
 	private Vector splitList(String list) {
		StringTokenizer st = new StringTokenizer(list, ",");
		String item = null;
 		Vector result = new Vector();

		while (st.hasMoreTokens()) {
			item = st.nextToken();
			// Trim white space from ends.
			int i, j;
			for (i = 0; (i < item.length()) && (item.charAt(i) == ' '); i++) {}
			for (j = item.length() - 1; (j > 0) && (item.charAt(j) == ' '); j--) {}
			item = item.substring(i, j + 1);
			result.add(item);
		}
		return result;
 	}
	
	private void loadRaces(String dataPath) {

		// Load the race definition file.
		Properties properties = loadPropertiesFile(dataPath, DEFAULT_RACE_DEFINITONS + EXTENSION);

		String racesString = null;

		// Load races from file.
		try {
			racesString = properties.getProperty("Races");
		}
		catch (Exception e) {
			Debug.fatalError("No races defined: " + e.getMessage(), 1);
		}
		Vector raceNames = splitList(racesString);
		for (int i = 0; i != raceNames.size(); i++) {
			races.add(new Race((String)raceNames.elementAt(i), properties, races));
		}
 	}

	private void loadMagics(String dataPath) {

		// Load the race definition file.
		Properties properties = loadPropertiesFile(dataPath, DEFAULT_MAGIC_DEFINITONS + EXTENSION);

		String magicOptionsString = null;

		// Load races from file.
		try {
			magicOptionsString = properties.getProperty("MagicOptions");
		}
		catch (Exception e) {
			Debug.fatalError("No magic options defined: " + e.getMessage(), 1);
		}
		Vector magicOptionNames = splitList(magicOptionsString);
		for (int i = 0; i != magicOptionNames.size(); i++) {
			magicOptions.add(new Magic((String)magicOptionNames.elementAt(i), properties));
		}
 	}
 	
	private void loadResources(String dataPath) {

		// Load the resources definition file.
		Properties properties = loadPropertiesFile(dataPath, DEFAULT_RESOURCES_DEFINITONS + EXTENSION);

		String resourcesString = null;

		// Load resources from file.
		try {
			resourcesString = properties.getProperty("Resources");
		}
		catch (Exception e) {
			Debug.fatalError("No resources defined: " + e.getMessage(), 1);
		}
		Vector resourcesNames = splitList(resourcesString);
		for (int i = 0; i != resourcesNames.size(); i++) {
			resources.add(new Resources((String)resourcesNames.elementAt(i), properties));
		}
 	}
	
	private void buildGUI() {
		setLayout(new BorderLayout());
		setPreferredSize(new Dimension(PREFERRED_WIDTH, PREFERRED_HEIGHT));
		
		tabbedPane = new JTabbedPane(JTabbedPane.LEFT);

		tabbedPane.add("Details", new GeneratorDetails(character));
		
		// This tab depends on the system being used.
		switch (character.getSystem()) {
			case BUILD_POINT_SYSTEM:
			default:
				tabbedPane.add("Build Points", new GeneratorBuildPoints(character, races, magicOptions, resources));
				break;
			case PRIORITY_SYSTEM:
				tabbedPane.add("Priorities", new GeneratorDummy());
				break;
		}

		tabbedPane.add("Magic", new GeneratorDummy());
		tabbedPane.add("Attributes", new GeneratorAttributes(character));
		tabbedPane.add("Skills", new GeneratorDummy());
		tabbedPane.add("Resources", new GeneratorDummy());
		tabbedPane.add("Description", new GeneratorDummy());

		add(tabbedPane, BorderLayout.CENTER);
	}
}



/** A dummy tab on the character generator until I make real ones. */
class GeneratorDummy extends JPanel {
	
	GeneratorDummy() {
		setLayout(new BorderLayout());
		add(new JLabel("Dummy"), BorderLayout.CENTER);
	}
}

