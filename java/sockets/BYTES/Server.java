
import java.io.*;
import java.net.*;
import java.util.Random;

class Server extends Thread implements Runnable {
	
	// Communication codes.
	public static final int ACKNOWLEDGE = 1;
	public static final int DISCONNECT = 2;

	private static final int PORTNUM = 1234;
	private static final int WAITFORCLIENT = 0;
	private static final int WAITFORANSWER = 1;
	private ServerSocket serverSocket;
	private int state = WAITFORCLIENT;

	public Server() {
		super("Server");
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

		InputStream clientInStream = null;
		OutputStream clientOutStream = null;
		int clientInput = 0;
		int clientOutput = 0;
		
		Socket clientSocket = null;
		
		// Look for clients and ask trivia questions.
		while (true) {
			// Wait for a client.
			if (serverSocket == null)
				return ;
			try {
				clientSocket = serverSocket.accept();
			} catch (IOException e) {
				System.err.println("Exception: couldn't connect to client socket: " + e.getMessage());
				System.exit(1);
			}

			System.out.println("Client connected.");

			// Perform the question/answer processing.
			try {
				clientInStream = clientSocket.getInputStream();
				clientOutStream = clientSocket.getOutputStream();

				// Output server request
				clientOutput = processInput(0);
				clientOutStream.write(clientOutput);
				clientOutStream.flush();
				System.out.println("Server: '" + clientOutput + "'");

				// Process and output user input.
				while ((clientInput = clientInStream.read()) != 0) {

					clientOutput = processInput(clientInput);

					System.out.println("Client: '" + clientInput + "'");
					System.out.println("Server: '" + clientOutput + "'");

					// Send the output to the client.
					clientOutStream.write(clientOutput);
					clientOutStream.flush();

					if (clientOutput == DISCONNECT)
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

	int processInput(int inStr) {

		int outStr = 0;

		switch (state) {
			case WAITFORCLIENT:
			default:
				// Ask for ack.
				outStr = ACKNOWLEDGE;
				state = WAITFORANSWER;
				break;

			case WAITFORANSWER:
				// Send DISCONNECT, to tell the client to disconnect.

				// Print what they send.				
				System.out.println(inStr);
				
				outStr = DISCONNECT;
				state = WAITFORCLIENT;
				break;
		}
		return outStr;
	}
}
