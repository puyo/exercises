
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;
import java.util.Vector;

public class GeneratorTab extends JPanel {
	
	// Borders.
	protected static EmptyBorder border5 = new EmptyBorder(5, 5, 5, 5);
	protected static EmptyBorder border10 = new EmptyBorder(10, 10, 10, 10);
	
	// Gaps.
	protected static Dimension HGAP2 = new Dimension(2,1);
	protected static Dimension VGAP2 = new Dimension(1,2);

	protected static Dimension HGAP5 = new Dimension(5,1);
	protected static Dimension VGAP5 = new Dimension(1,5);
	
	protected static Dimension HGAP10 = new Dimension(10,1);
	protected static Dimension VGAP10 = new Dimension(1,10);

	protected static Dimension HGAP15 = new Dimension(15,1);
	protected static Dimension VGAP15 = new Dimension(1,15);
	
	protected static Dimension HGAP20 = new Dimension(20,1);
	protected static Dimension VGAP20 = new Dimension(1,20);

	protected static Dimension HGAP25 = new Dimension(25,1);
	protected static Dimension VGAP25 = new Dimension(1,25);

	protected static Dimension HGAP30 = new Dimension(30,1);
	protected static Dimension VGAP30 = new Dimension(1,30);

	protected static JPanel createVerticalPanel(String name) {
		JPanel p = new JPanel();
		p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
		p.setAlignmentY(TOP_ALIGNMENT);
		p.setAlignmentX(LEFT_ALIGNMENT);
		if (name != null) {
			p.setBorder(new CompoundBorder(new TitledBorder(null, " " + name + " ", TitledBorder.LEFT, TitledBorder.TOP), border5));
		}
		return p;
	}

	protected static JPanel createHorizontalPanel(String name) {
		JPanel p = new JPanel();
		p.setLayout(new BoxLayout(p, BoxLayout.X_AXIS));
		p.setAlignmentY(TOP_ALIGNMENT);
		p.setAlignmentX(LEFT_ALIGNMENT);
		if (name != null) {
			p.setBorder(new CompoundBorder(new TitledBorder(null, " " + name + " ", TitledBorder.LEFT, TitledBorder.TOP), border5));
		}
		return p;
	}
}
