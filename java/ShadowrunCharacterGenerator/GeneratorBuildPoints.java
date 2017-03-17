
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;
import java.util.Vector;


/** The 'Build Points' tab on the character generator. */
public class GeneratorBuildPoints extends GeneratorTab implements ItemListener, ChangeListener {

	// Character being worked on.
	private ShadowrunCharacter character;

	protected Vector races = null;
	protected Vector magicOptions = null;
	protected Vector resources = null;

	// Build Points spent.
	private int racePoints          = 0;
	private int magicPoints         = 0;
	private int attributePoints     = 0;
	private int skillPoints         = 0;
	private int resourcesPoints     = 0;
	private int edgesAndFlawsPoints = 0;
	private int buildPoints         = 0;
	
	private static final String buildPointString = "Build Point";
	private static final String buildPointsString = "Build Points";

	// Labels keeping track of Build Points spent.
	private JLabel racePointsLabel          = new JLabel(racePoints + " " + buildPointsString);
	private JLabel magicPointsLabel         = new JLabel(magicPoints + " " + buildPointsString);
	private JLabel attributePointsLabel     = new JLabel(attributePoints + " " + buildPointsString);
	private JLabel skillPointsLabel         = new JLabel(skillPoints + " " + buildPointsString);
	private JLabel resourcesPointsLabel     = new JLabel(resourcesPoints + " " + buildPointsString);
	private JLabel edgesAndFlawsPointsLabel = new JLabel(edgesAndFlawsPoints + " " + buildPointsString);
	private JLabel buildPointsLabel         = new JLabel((buildPoints - getPointsLeft()) + "/" + buildPoints + " " + buildPointsString);
	
	JComboBox raceComboBox;
	JComboBox magicComboBox;
	JSlider attributeSlider;
	JSlider skillSlider;
	JComboBox resourcesComboBox;

	public GeneratorBuildPoints(ShadowrunCharacter character, Vector races, Vector magicOptions, Vector resources) {
		this.character = character;
		this.races = races;
		this.magicOptions = magicOptions;
		this.resources = resources;
		this.buildPoints = character.getBuildPoints();
		
		buildGUI();
		recalculate();
	}
	
	public void itemStateChanged(ItemEvent e) {
		Object source = e.getSource();
		String name = ((Component)source).getName();
		
		if (name.compareTo("Race") == 0) {
			setRace((Race)e.getItem());

		} else if (name.compareTo("Magic") == 0) {
			setMagic((Magic)e.getItem());

		} else if (name.compareTo("Resources") == 0) {
			setResources((Resources)e.getItem());
		}
	}
	
	public void stateChanged(ChangeEvent e) {
		Object source = e.getSource();
		String name = ((Component)source).getName();

		if (name.compareTo("Attributes") == 0) {
			setAttributes(((JSlider)source).getValue());

		} else if (name.compareTo("Skills") == 0) {
			setSkills(((JSlider)source).getValue());
		}
	}
	
	private int getPointsLeft() {
		return buildPoints - racePoints - magicPoints - attributePoints - skillPoints - resourcesPoints - edgesAndFlawsPoints;
	}

	/** Set the character's race. Called by the GUI. */
	private void setRace(Race race) {
		if (race.getBuildPoints() > (getPointsLeft() + racePoints)) {
			// Set the selection back again.
			raceComboBox.setSelectedItem(character.getRace());
		} else {
			// Set the race.
			racePoints = race.getBuildPoints();
			character.setRace(race);
			recalculate();
		}
	}

	/** Set the character's magic. Called by the GUI. */
	private void setMagic(Magic magic) {
		if (magic.getBuildPoints() > (getPointsLeft() + magicPoints)) {
			// Set the selection back again.
			magicComboBox.setSelectedItem(character.getMagic());
		} else {
			// Set magic.
			magicPoints = magic.getBuildPoints();
			character.setMagic(magic);
			recalculate();
		}
	}

	/** Set the character's attribute point allocation. Called by the GUI. */
	private void setAttributes(int value) {
		int newAttributesPoints = value * 2;
		if (newAttributesPoints > (getPointsLeft() + attributePoints)) {
			// Set the selection back again.
			attributeSlider.setValue(attributePoints/2);
		} else {
			// Set attribute points.
			attributePoints = newAttributesPoints;
//			character.setAttributes(value);
			recalculate();
		}
	}

	/** Set the character's skill point allocation. Called by the GUI. */
	private void setSkills(int value) {
		if (value > (getPointsLeft() + skillPoints)) {
			// Set the selection back again.
			skillSlider.setValue(skillPoints);
		} else {
			// Set skill points.
			skillPoints = value;
//			character.setSkills(value);
			recalculate();
		}
	}

	/** Set the character's resources. Called by the GUI. */
	private void setResources(Resources resources) {

		if (resources.getBuildPoints() > (getPointsLeft() + resourcesPoints)) {
			// Set the selection back again.
			resourcesComboBox.setSelectedItem(character.getResources());
		} else {
			// Set resources.
			resourcesPoints = resources.getBuildPoints();
			character.setResources(resources);
			recalculate();
		}
	}

	private void recalculate() {
		// Redo all the labels.
		racePointsLabel.setText(racePoints + " " + buildPointsString);
		magicPointsLabel.setText(magicPoints + " " + buildPointsString);
		attributePointsLabel.setText(attributePoints + " " + buildPointsString);
		if (skillPoints == 1) {
			skillPointsLabel.setText(skillPoints + " " + buildPointString);
		} else {
			skillPointsLabel.setText(skillPoints + " " + buildPointsString);
		}
		resourcesPointsLabel.setText(resourcesPoints + " " + buildPointsString);
		buildPointsLabel.setText((buildPoints - getPointsLeft()) + "/" + buildPoints + " " + buildPointsString);
	}
	
	private void buildGUI() {

		JPanel p = createVerticalPanel(null);
		add(p);

		JPanel buildPointAllocation = createVerticalPanel("Build Point Allocation");
		p.add(buildPointAllocation);
		
		GridBagLayout gridbag = new GridBagLayout();
		GridBagConstraints c = new GridBagConstraints();
		
		buildPointAllocation.setLayout(gridbag);
		
		c.fill = GridBagConstraints.HORIZONTAL;
		c.weightx = 1.0;
		c.weighty = 1.0;

		racePointsLabel.setBorder(border5);
		magicPointsLabel.setBorder(border5);
		attributePointsLabel.setBorder(border5);
		skillPointsLabel.setBorder(border5);
		resourcesPointsLabel.setBorder(border5);
		edgesAndFlawsPointsLabel.setBorder(border5);

		////////////////////////////
		double pointsWeight = 0.5;
		
		// Race panel.
		JPanel racePanel = createHorizontalPanel("Race");
		raceComboBox = new JComboBox(races);
		raceComboBox.setName("Race");
		raceComboBox.addItemListener(this);
		racePanel.add(raceComboBox);
		c.gridwidth = GridBagConstraints.RELATIVE;
		gridbag.setConstraints(racePanel, c);
		buildPointAllocation.add(racePanel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		gridbag.setConstraints(racePointsLabel, c);
		buildPointAllocation.add(racePointsLabel);
		
		// Magic panel.
		JPanel magicPanel = createHorizontalPanel("Magic");
		magicComboBox = new JComboBox(magicOptions);
		magicComboBox.setName("Magic");
		magicComboBox.addItemListener(this);
		magicPanel.add(magicComboBox);
		c.gridwidth = GridBagConstraints.RELATIVE;
		gridbag.setConstraints(magicPanel, c);
		buildPointAllocation.add(magicPanel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		c.weightx = pointsWeight;
		gridbag.setConstraints(magicPointsLabel, c);
		buildPointAllocation.add(magicPointsLabel);

		// Attribute panel.
		JPanel attributePanel = createHorizontalPanel("Attributes");
		attributeSlider = new JSlider(0, 30, 0);
		attributeSlider.setName("Attributes");
		attributeSlider.addChangeListener(this);
		attributeSlider.setMajorTickSpacing(5);
		attributeSlider.setMinorTickSpacing(1);
		attributeSlider.setPaintTicks(true);
		attributeSlider.setPaintLabels(true);
		attributeSlider.setSnapToTicks(true);
		attributePanel.add(attributeSlider);
		c.gridwidth = GridBagConstraints.RELATIVE;
		gridbag.setConstraints(attributePanel, c);
		buildPointAllocation.add(attributePanel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		c.weightx = pointsWeight;
		gridbag.setConstraints(attributePointsLabel, c);
		buildPointAllocation.add(attributePointsLabel);

		// Skill panel.
		JPanel skillPanel = createHorizontalPanel("Skills");
		skillSlider = new JSlider(0, 60, 0);
		skillSlider.setName("Skills");
		skillSlider.addChangeListener(this);
		skillSlider.setMajorTickSpacing(10);
		skillSlider.setMinorTickSpacing(1);
		skillSlider.setPaintTicks(true);
		skillSlider.setPaintLabels(true);
		skillSlider.setSnapToTicks(true);
		skillPanel.add(skillSlider);
		c.gridwidth = GridBagConstraints.RELATIVE;
		gridbag.setConstraints(skillPanel, c);
		buildPointAllocation.add(skillPanel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		c.weightx = pointsWeight;
		gridbag.setConstraints(skillPointsLabel, c);
		buildPointAllocation.add(skillPointsLabel);
		
		// Resources panel.
		JPanel resourcesPanel = createHorizontalPanel("Resources");
		resourcesComboBox = new JComboBox(resources);
		resourcesComboBox.setName("Resources");
		resourcesComboBox.addItemListener(this);
		resourcesComboBox.setSelectedIndex(1);
		resourcesPanel.add(resourcesComboBox);
		c.gridwidth = GridBagConstraints.RELATIVE;
		gridbag.setConstraints(resourcesPanel, c);
		buildPointAllocation.add(resourcesPanel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		c.weightx = pointsWeight;
		gridbag.setConstraints(resourcesPointsLabel, c);
		buildPointAllocation.add(resourcesPointsLabel);

		// Edges and Flaws panel.
		JPanel edgesAndFlawsPanel = createHorizontalPanel("Edges and Flaws");
		edgesAndFlawsPanel.add(new JButton("Choose Edges"));
		edgesAndFlawsPanel.add(Box.createRigidArea(HGAP10));
		edgesAndFlawsPanel.add(new JButton("Choose Flaws"));
		c.gridwidth = GridBagConstraints.RELATIVE;
		gridbag.setConstraints(edgesAndFlawsPanel, c);
		buildPointAllocation.add(edgesAndFlawsPanel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		c.weightx = pointsWeight;
		gridbag.setConstraints(edgesAndFlawsPointsLabel, c);
		buildPointAllocation.add(edgesAndFlawsPointsLabel);

		// Build Points panel.
		JPanel buildPointsPanel = createHorizontalPanel("Build Points");
		buildPointsPanel.add(buildPointsLabel);
		c.gridwidth = GridBagConstraints.REMAINDER;
		gridbag.setConstraints(buildPointsPanel, c);
		buildPointAllocation.add(buildPointsPanel);
	}
}
