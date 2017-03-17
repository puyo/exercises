
import java.io.*;
import java.net.*;
import java.util.Random;

class Server extends Thread implements Runnable {

	private static final int PORTNUM = 1234;
	private static final int WAITFORCLIENT = 0;
	private static final int WAITFORANSWER = 1;
	private static final int WAITFORCONFIRM = 2;
	private String[] questions;
	private String[] answers;
	private ServerSocket serverSocket;
	private int numQuestions;
	private int num = 0;
	private int state = WAITFORCLIENT;
	private Random rand = new Random(System.currentTimeMillis());

	public Server() {
		super("TriviaServer");
		try {
			serverSocket = new ServerSocket(PORTNUM);
			System.out.println("Server up and running...");
		} catch (IOException e) {
			System.err.println("Exception: couldn't create socket");
			System.exit(1);
		}
	}

	public static void main(String[] args) {
		Server server = new Server();
		server.start();
	}

	public void run() {

		BufferedReader clientInStream = null;
		PrintWriter clientOutStream = null;
		String clientInput = null;
		String clientOutput = null;
		
		Socket clientSocket = null;
		
		// Initialize the arrays of questions and answers.
		if (!initQnA()) {
			System.err.println("Error: couldn't initialize questions and answers");
			return ;
		}

		// Look for clients and ask trivia questions.
		while (true) {
			// Wait for a client.
			if (serverSocket == null)
				return ;
			try {
				clientSocket = serverSocket.accept();
			} catch (IOException e) {
				System.err.println("Exception: couldn't connect to client socket");
				System.exit(1);
			}

			System.out.println("Client connected.");

			// Perform the question/answer processing.
			try {
				clientInStream = new BufferedReader(new InputStreamReader(new DataInputStream(clientSocket.getInputStream())));
				clientOutStream = new PrintWriter(clientSocket.getOutputStream());

				// Output server request
				clientOutput = processInput(null);
				clientOutStream.println(clientOutput);
				clientOutStream.flush();
				System.out.println("Server: '" + clientOutput + "'");

				// Process and output user input.
				while ((clientInput = clientInStream.readLine()) != null) {

					clientOutput = processInput(clientInput);

					System.out.println("Client: '" + clientInput + "'");
					System.out.println("Server: '" + clientOutput + "'");

					// Send the output to the client.
					clientOutStream.println(clientOutput);
					clientOutStream.flush();

					if (clientOutput.equals("Bye."))
						break;
				}

				System.out.println("Client disconnected.");

				// Cleanup.
				clientOutStream.close();
				clientInStream.close();
				clientSocket.close();
			} catch (Exception e) {
				System.err.println("Exception: " + e);
				e.printStackTrace();
			}
		}
	}

	String processInput(String inStr) {
		String outStr = null;

		switch (state) {
			case WAITFORCLIENT:
			default:
				// Ask a question.

				outStr = questions[num];
				state = WAITFORANSWER;
				break;

			case WAITFORANSWER:
				// Check the answer.

				if (inStr.equalsIgnoreCase(answers[num]))
					outStr = "That's correct! Want another? (y/n)";
				else
					outStr = "Wrong, the correct answer is '" + answers[num] + "'. Want another? (y/n)";
				state = WAITFORCONFIRM;
				break;

			case WAITFORCONFIRM:
				// See if they want another question.

				if (inStr.equalsIgnoreCase("n")) {
					outStr = "Bye.";
					state = WAITFORCLIENT;
				} else {
					num = Math.abs(rand.nextInt()) % questions.length;
					outStr = questions[num];
					state = WAITFORANSWER;
				}
				break;
		}
		return outStr;
	}

	private boolean initQnA() {
		try {
			File inFile = new File("QnA.txt");
			FileInputStream inStream = new FileInputStream(inFile);
			byte[] data = new byte[(int)inFile.length()];

			// Read the questions and answers into a byte array.
			if (inStream.read(data) <= 0) {
				System.err.println("Error: couldn't read questions and answers");
				return false;
			}

			// See how many question/answer pairs there are.
			for (int i = 0; i < data.length; i++)
				if (data[i] == (byte)'\n')
					numQuestions++;
			numQuestions /= 2;
			questions = new String[numQuestions];
			answers = new String[numQuestions];

			// Parse the questions and answers into arrays of strings.
			int start = 0, index = 0;
			boolean clientInStreamQ = true;
			for (int i = 0; i < data.length; i++)
				if (data[i] == (byte)'\n') {
					if (clientInStreamQ) {
						questions[index] = new String(data, start, i - start - 1);
						clientInStreamQ = false;
					} else {
						answers[index] = new String(data, start, i - start - 1);
						clientInStreamQ = true;
						index++;
					}
					start = i + 1;
				}
		} catch (FileNotFoundException e) {
			System.err.println("Exception: couldn't find the fortune file");
			return false;
		}
		catch (IOException e) {
			System.err.println("Exception: I/O error trying to read questions");
			return false;
		}

		return true;
	}
}
