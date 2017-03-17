
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;

public class ShadowrunCharacterGenerator extends JPanel {
	
	private static JFrame frame;
	private static ShadowrunCharacter character;
	private static Generator generator;

	public static void main(String args[]) {
		setLookAndFeel();

		int system = getSystem();

		if (system == Generator.BUILD_POINT_SYSTEM) {

		} else if (system == Generator.PRIORITY_SYSTEM) {
			
		} else {
			System.exit(0);
		}

		// Make a new character and feed it in to the generator.
		generator = new Generator(system, getBuildPoints());

		generateCharacter();
	}
	
	private static void setLookAndFeel() {
		try {
			UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
		} catch (Exception e) {
			System.err.println("Error loading L&F: " + e.getMessage());
		}
	}

	private static int getSystem() {
		String buildPointSystem = "Build Point System";
		String prioritySystem = "Priority System";
		Object[] possibleValues = { buildPointSystem, prioritySystem };

		String system = (String)JOptionPane.showInputDialog(
			null,
			"Choose a character creation system", "Character Creation System",
			JOptionPane.PLAIN_MESSAGE,
			null,
			possibleValues,
			possibleValues[0]);
			
		if (system == buildPointSystem) {
			return Generator.BUILD_POINT_SYSTEM;
		} else if (system == prioritySystem) {
			return Generator.PRIORITY_SYSTEM;
		} else {
			return 0;
		}
	}

	private static int getBuildPoints() {
		String buildPointSystem = "Build Point System";
		String prioritySystem = "Priority System";
		Object[] possibleValues = { buildPointSystem, prioritySystem };

		String buildPointsString =
		(String)JOptionPane.showInputDialog(
			null,
			"Enter number of Build Points to use",
			"Build Points",
			JOptionPane.PLAIN_MESSAGE,
			null,
			null,
			"120");
		return Integer.parseInt(buildPointsString);
	}

	private static void generateCharacter() {
		frame = new JFrame(getTitle());
		frame.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});

		frame.getContentPane().add(generator, BorderLayout.CENTER);
		frame.pack();
		frame.setVisible(true);
	}

	public static String getTitle() {
		return "Shadowrun Character Generator";
	}
}
