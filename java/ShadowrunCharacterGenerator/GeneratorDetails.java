
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;


class GeneratorDetails extends GeneratorTab {

	private ShadowrunCharacter character;
	
	GeneratorDetails(ShadowrunCharacter character) {
		this.character = character;

		buildGUI();
	}

	private void buildGUI() {

		JPanel p = createVerticalPanel(null);
		add(p);
		
		JPanel authorPanel = createHorizontalPanel("Player Name");
		JTextField authorField = new JTextField(15);
		authorPanel.add(authorField);
		p.add(authorPanel);
		
		
		JPanel vitalStatisticsPanel = createVerticalPanel("Vital Statistics");
		p.add(vitalStatisticsPanel);

		JPanel nameSexAgePanel = createHorizontalPanel(null);
		vitalStatisticsPanel.add(nameSexAgePanel);
		
		// Name panel.
		JPanel namePanel = createHorizontalPanel("Name");
		JTextField nameField = new JTextField(15);
		namePanel.add(nameField);
		nameSexAgePanel.add(namePanel);

		// Age panel.
		JPanel agePanel = createHorizontalPanel("Age");
		JTextField ageTextField = new JTextField(3);
		agePanel.add(ageTextField);
		nameSexAgePanel.add(agePanel);

		// Sex panel.
		JPanel sexPanel = createHorizontalPanel("Sex");
		String[] sexes = {
			"Male",
			"Female",
		};
		JComboBox sexComboBox = new JComboBox(sexes);
		sexPanel.add(sexComboBox);
		nameSexAgePanel.add(sexPanel);

		JPanel appearancePanel = createHorizontalPanel(null);
		vitalStatisticsPanel.add(appearancePanel);
		
		// Build panel.
		JPanel buildPanel = createHorizontalPanel("Build");
		JTextField buildTextField = new JTextField(10);
		buildPanel.add(buildTextField);
		appearancePanel.add(buildPanel);

		// Height panel.
		JPanel heightPanel = createHorizontalPanel("Height");
		JTextField heightTextField = new JTextField(3);
		heightPanel.add(heightTextField);
		appearancePanel.add(heightPanel);
		
		// Weight panel.
		JPanel weightPanel = createHorizontalPanel("Weight");
		JTextField weightTextField = new JTextField(3);
		weightPanel.add(weightTextField);
		appearancePanel.add(weightPanel);
/*		
		private String hair;
		private String eyes;
		private String handedness;
*/
	}
}	
