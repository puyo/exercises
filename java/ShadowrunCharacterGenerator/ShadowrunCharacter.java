
import java.util.Vector;

public class ShadowrunCharacter {

	// System used (Build Points or Priority).
	private int system;

	// Author/player/owner.
	private String playerName;

	// Vital statistics.
	private String name;
	private String sex;
	private Race race = null;
	private int age;
	private String build;
	private String height;
	private String weight;
	private String hair;
	private String eyes;
	private String handedness;

	private Magic magic = null;

	private Resources resources = null;
	
	private String nuyen;

	// Priorities/Build Points.
	private int buildPoints = 120;
	private int raceAllocation;
	private int attributesAllocation;
	private int skillsAllocation;
	private int magicAllocation;
	private int resourcesAllocation;

	// Unmodified base attributes.
	private int body;
	private int quickness;
	private int strength;
	private int charisma;
	private int intelligence;
	private int willpower;
	private int essenceInteger;
	private int essenceFraction;
	private int initiativeDice;

	// Karma.
	private int karma;
	private int totalKarma;
	
	// Skills.
	private Vector skills;

	// Gear
	private Vector items;
	
	public ShadowrunCharacter() {

		body = 1;
		quickness = 1;
		strength = 1;
		charisma = 1;
		intelligence = 1;
		willpower = 1;

		initiativeDice = 1;
	}
	
	public int getSystem() {
		return system;
	}
	public int getBuildPoints() {
		return buildPoints;
	}
	
	public int getBody() {
		return body;
	}
	public int getQuickness() {
		return quickness;
	}
	public int getStrength() {
		return strength;
	}
	public int getCharisma() {
		return charisma;
	}
	public int getIntelligence() {
		return intelligence;
	}
	public int getWillpower() {
		return willpower;
	}
	public int getReaction() {
		return (getQuickness() + getIntelligence())/2;
	}
	public int getInitiativeDice() {
		return initiativeDice;
	}
	public double getEssence() {
		return (double)essenceInteger + (double)essenceFraction/(double)100;
	}
	public int getMagicAttribute() {
		return essenceInteger;
	}
	public Race getRace() {
		return race;
	}
	public Magic getMagic() {
		return magic;
	}
	public Resources getResources() {
		return resources;
	}

	public void setSystem(int system) {
		this.system = system;
	}
	public void setBuildPoints(int buildPoints) {
		this.buildPoints = buildPoints;
	}
	public void setRace(Race race) {
		this.race = race;
	}
	public void setMagic(Magic magic) {
		this.magic = magic;
	}
	public void setResources(Resources resources) {
		this.resources = resources;
	}
}
