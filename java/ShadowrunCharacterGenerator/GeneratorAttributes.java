
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;
import java.util.Vector;


/** The 'Attributes' tab on the character generator. */
public class GeneratorAttributes extends GeneratorTab implements ItemListener, ChangeListener {

	// Character being worked on.
	private ShadowrunCharacter character;

	public GeneratorAttributes(ShadowrunCharacter character) {
		this.character = character;
		buildGUI();
	}
	
	public void itemStateChanged(ItemEvent e) {
	}
	
	public void stateChanged(ChangeEvent e) {
	}
	
	private void buildGUI() {

		JPanel p = createVerticalPanel(null);
		add(p);

		JPanel attributePointAllocation = createVerticalPanel("Attribute Point Allocation");
		p.add(attributePointAllocation);
	}
}
